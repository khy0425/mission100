import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

/// 안전한 꿈 분석 서비스 (Firebase Functions 사용)
///
/// API 키가 앱에 노출되지 않으며, 서버에서만 OpenAI를 호출합니다.
/// 이 방식은 보안이 강화되어 프로덕션 환경에 적합합니다.
class DreamAnalysisServiceSecure {
  static final DreamAnalysisServiceSecure _instance =
      DreamAnalysisServiceSecure._internal();
  factory DreamAnalysisServiceSecure() => _instance;
  DreamAnalysisServiceSecure._internal();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// 빠른 꿈 분석 (1토큰 - Gemini 2.0 Flash)
  ///
  /// [dreamText]: 분석할 꿈 내용 (최대 500자)
  /// [userTitle]: 사용자 칭호 (레벨 기반, 예: 드리머님, 각성자님)
  ///
  /// Returns: AI 분석 결과
  Future<String> quickAnalysis({
    required String dreamText,
    String? userTitle,
  }) async {
    try {
      // 입력 검증
      if (dreamText.trim().isEmpty) {
        throw Exception('꿈 내용을 입력해주세요');
      }

      if (dreamText.length > 500) {
        throw Exception('꿈 내용은 500자 이내로 입력해주세요');
      }

      debugPrint('📡 Calling Firebase Functions: quickDreamAnalysis');
      debugPrint('   User title: ${userTitle ?? "드리머님"}');

      // Firebase Functions 호출
      // userTitle은 이미 클라이언트에서 l10n을 통해 다국어로 전달됨
      final callable = _functions.httpsCallable('quickDreamAnalysis');
      final result = await callable.call({
        'dreamText': dreamText,
        'userTitle': userTitle, // null이면 서버에서 기본 처리
      });

      final data = result.data as Map<String, dynamic>;

      if (data['success'] == true) {
        debugPrint('✅ Quick analysis completed');
        return data['analysis'] as String;
      } else {
        throw Exception('분석 실패');
      }
    } on FirebaseFunctionsException catch (e) {
      debugPrint('❌ Firebase Functions error: ${e.code} - ${e.message}');
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      debugPrint('❌ Quick analysis error: $e');
      rethrow;
    }
  }

  /// Lumi와 대화형 분석 (1토큰 - Gemini 2.0 Flash)
  ///
  /// [conversationId]: 대화 ID (null이면 새 대화 시작)
  /// [userMessage]: 사용자 메시지 (최대 500자)
  /// [userTitle]: 사용자 칭호 (레벨 기반, 예: 드리머님, 각성자님)
  ///
  /// Returns: 대화 결과 (conversationId, AI 응답, 남은 토큰 등)
  Future<ConversationResult> analyzeWithConversation({
    String? conversationId,
    required String userMessage,
    String? userTitle,
  }) async {
    try {
      // 입력 검증
      if (userMessage.trim().isEmpty) {
        throw Exception('메시지를 입력해주세요');
      }

      if (userMessage.length > 500) {
        throw Exception('메시지는 500자 이내로 입력해주세요');
      }

      debugPrint('📡 Calling Firebase Functions: analyzeWithLumi');
      debugPrint('   Conversation ID: $conversationId');
      debugPrint('   User title: ${userTitle ?? "드리머님"}');

      // Firebase Functions 호출
      // userTitle은 이미 클라이언트에서 l10n을 통해 다국어로 전달됨
      final callable = _functions.httpsCallable('analyzeWithLumi');
      final result = await callable.call({
        'conversationId': conversationId,
        'userMessage': userMessage,
        'userTitle': userTitle, // null이면 서버에서 기본 처리
      });

      final data = result.data as Map<String, dynamic>;

      if (data['success'] == true) {
        debugPrint('✅ Conversation analysis completed');
        debugPrint('   Tokens remaining: ${data['tokensRemaining']}');

        return ConversationResult(
          conversationId: data['conversationId'] as String,
          response: data['response'] as String,
          tokensRemaining: data['tokensRemaining'] as int,
          messageCount: data['messageCount'] as int,
        );
      } else {
        throw Exception('대화 분석 실패');
      }
    } on FirebaseFunctionsException catch (e) {
      debugPrint('❌ Firebase Functions error: ${e.code} - ${e.message}');
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      debugPrint('❌ Conversation analysis error: $e');
      rethrow;
    }
  }

  /// Firebase Functions 에러 메시지 변환
  String _getErrorMessage(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'unauthenticated':
        return '로그인이 필요합니다';
      case 'permission-denied':
        return '권한이 없습니다';
      case 'resource-exhausted':
        return 'API 사용량 한도 초과. 잠시 후 다시 시도해주세요';
      case 'deadline-exceeded':
        return '요청 시간 초과. 다시 시도해주세요';
      default:
        return e.message ?? '알 수 없는 오류가 발생했습니다';
    }
  }
}

/// 대화 분석 결과
class ConversationResult {
  final String conversationId;
  final String response;
  final int tokensRemaining;
  final int messageCount;

  ConversationResult({
    required this.conversationId,
    required this.response,
    required this.tokensRemaining,
    required this.messageCount,
  });

  @override
  String toString() {
    return 'ConversationResult(id: $conversationId, tokensRemaining: $tokensRemaining, messages: $messageCount)';
  }
}
