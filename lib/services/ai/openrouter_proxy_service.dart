import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// OpenRouter AI Proxy 서비스 (Firebase Cloud Functions 통해 호출)
///
/// 보안 강화: API 키가 클라이언트에 노출되지 않음
/// 사용량 추적: Firestore에서 일일 사용량 관리
/// 요금제: 무료 10회/일, 프리미엄 100회/일
class OpenRouterProxyService {
  static final OpenRouterProxyService _instance = OpenRouterProxyService._internal();
  factory OpenRouterProxyService() => _instance;
  OpenRouterProxyService._internal();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// AI에게 메시지 보내기
  ///
  /// [prompt] 사용자 메시지
  /// [model] 사용할 AI 모델 (기본값: google/gemini-2.0-flash-exp:free)
  /// [maxTokens] 최대 토큰 수
  ///
  /// Returns: AI의 응답 및 사용량 정보
  Future<OpenRouterResponse> sendMessage({
    required String prompt,
    String model = 'google/gemini-2.0-flash-exp:free',
    int maxTokens = 512,
  }) async {
    try {
      // 사용자 인증 확인
      if (_auth.currentUser == null) {
        throw Exception('Login required');
      }

      debugPrint('📤 OpenRouter Proxy 호출: $model');

      // Cloud Function 호출
      final callable = _functions.httpsCallable('openRouterProxy');
      final result = await callable.call({
        'prompt': prompt,
        'model': model,
        'maxTokens': maxTokens,
      });

      final data = result.data;

      debugPrint('✅ AI 응답 수신: ${data['usageCount']}/${data['dailyLimit']} 사용');

      return OpenRouterResponse(
        success: true,
        response: data['response'] as String,
        usageCount: data['usageCount'] as int,
        dailyLimit: data['dailyLimit'] as int,
        remaining: data['remaining'] as int,
        isPremium: data['isPremium'] as bool,
      );
    } on FirebaseFunctionsException catch (e) {
      debugPrint('❌ Cloud Function 오류: ${e.code} - ${e.message}');
      throw Exception(e.message ?? 'AI call failed');
    } catch (e) {
      debugPrint('❌ OpenRouter Proxy 오류: $e');
      throw Exception('An error occurred during AI call: $e');
    }
  }

  /// 대화형 메시지 보내기 (이전 대화 맥락 포함)
  ///
  /// [messages] 대화 기록 (role과 content를 포함한 맵 리스트)
  /// [model] 사용할 AI 모델
  /// [maxTokens] 최대 토큰 수
  ///
  /// Returns: AI의 응답 및 사용량 정보
  Future<OpenRouterResponse> sendConversation({
    required List<Map<String, String>> messages,
    String model = 'google/gemini-2.0-flash-exp:free',
    int maxTokens = 512,
  }) async {
    try {
      // 사용자 인증 확인
      if (_auth.currentUser == null) {
        throw Exception('Login required');
      }

      debugPrint('📤 OpenRouter Proxy 대화 호출: $model');

      // Cloud Function 호출
      final callable = _functions.httpsCallable('openRouterProxy');
      final result = await callable.call({
        'messages': messages,
        'model': model,
        'maxTokens': maxTokens,
      });

      final data = result.data;

      debugPrint('✅ AI 응답 수신: ${data['usageCount']}/${data['dailyLimit']} 사용');

      return OpenRouterResponse(
        success: true,
        response: data['response'] as String,
        usageCount: data['usageCount'] as int,
        dailyLimit: data['dailyLimit'] as int,
        remaining: data['remaining'] as int,
        isPremium: data['isPremium'] as bool,
      );
    } on FirebaseFunctionsException catch (e) {
      debugPrint('❌ Cloud Function 오류: ${e.code} - ${e.message}');
      throw Exception(e.message ?? 'AI call failed');
    } catch (e) {
      debugPrint('❌ OpenRouter Proxy 오류: $e');
      throw Exception('An error occurred during AI call: $e');
    }
  }

  /// 사용 가능한 무료 모델들
  static const List<String> freeModels = [
    'google/gemini-2.0-flash-exp:free',  // 추천! 빠르고 강력
    'meta-llama/llama-3.2-3b-instruct:free',
    'microsoft/phi-3-mini-128k-instruct:free',
    'qwen/qwen-2-7b-instruct:free',
  ];
}

/// OpenRouter 응답 모델
class OpenRouterResponse {
  final bool success;
  final String response;
  final int usageCount;
  final int dailyLimit;
  final int remaining;
  final bool isPremium;

  OpenRouterResponse({
    required this.success,
    required this.response,
    required this.usageCount,
    required this.dailyLimit,
    required this.remaining,
    required this.isPremium,
  });

  /// 사용량 퍼센트 (0.0 ~ 1.0)
  double get usagePercentage => usageCount / dailyLimit;

  /// 사용량 초과 여부
  bool get isOverLimit => remaining <= 0;

  /// 경고 표시 여부 (80% 이상 사용)
  bool get shouldShowWarning => usagePercentage >= 0.8;
}
