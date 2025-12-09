import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// OpenRouter AI API 서비스
///
/// Firebase Remote Config를 통해 API 키를 관리합니다.
/// Fallback: .env 파일의 OPENROUTER_API_KEY 사용
class OpenRouterService {
  static final OpenRouterService _instance = OpenRouterService._internal();
  factory OpenRouterService() => _instance;
  OpenRouterService._internal();

  String _apiKey = '';
  String _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  FirebaseRemoteConfig? _remoteConfig;

  /// 서비스 초기화
  ///
  /// Firebase Remote Config에서 API 키를 가져옵니다.
  /// 실패시 .env 파일을 fallback으로 사용합니다.
  Future<void> initialize() async {
    try {
      // Firebase Remote Config 초기화
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Remote Config 설정
      await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1), // 프로덕션: 1시간마다 갱신
      ));

      // 기본값 설정
      await _remoteConfig!.setDefaults({
        'openrouter_api_key': '',
        'openrouter_api_url': 'https://openrouter.ai/api/v1/chat/completions',
      });

      // Remote Config fetch & activate
      await _remoteConfig!.fetchAndActivate();

      // Remote Config에서 값 가져오기
      _apiKey = _remoteConfig!.getString('openrouter_api_key');
      _apiUrl = _remoteConfig!.getString('openrouter_api_url');

      debugPrint('✅ Remote Config에서 API 키 로드 성공');
    } catch (e) {
      debugPrint('⚠️ Remote Config 로드 실패: $e');
      debugPrint('📝 .env 파일에서 fallback 시도...');
    }

    // Remote Config에서 키를 못 가져왔으면 .env에서 가져오기
    if (_apiKey.isEmpty) {
      _apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';
      _apiUrl = dotenv.env['OPENROUTER_API_URL'] ?? _apiUrl;

      if (_apiKey.isNotEmpty) {
        debugPrint('✅ .env 파일에서 API 키 로드 성공 (fallback)');
      }
    }

    if (_apiKey.isEmpty) {
      debugPrint('⚠️ OpenRouter API 키가 설정되지 않았습니다.');
      debugPrint('   Firebase Remote Config 또는 .env 파일에 설정해주세요.');
    }
  }

  /// AI에게 메시지 보내기
  /// 
  /// [prompt] 사용자 메시지
  /// [model] 사용할 AI 모델 (기본값: google/gemini-2.0-flash-exp:free)
  /// [maxTokens] 최대 토큰 수
  /// 
  /// Returns: AI의 응답 텍스트
  Future<String> sendMessage({
    required String prompt,
    String model = 'google/gemini-2.0-flash-exp:free',
    int maxTokens = 512,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://dreamflow.app',
          'X-Title': 'DreamFlow',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'max_tokens': maxTokens,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return content;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('OpenRouter API 오류 (${response.statusCode}): ${errorData['error']?['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('OpenRouter API 호출 실패: $e');
    }
  }

  /// 대화형 메시지 보내기 (이전 대화 맥락 포함)
  /// 
  /// [messages] 대화 기록 (role과 content를 포함한 맵 리스트)
  /// [model] 사용할 AI 모델
  /// [maxTokens] 최대 토큰 수
  /// 
  /// Returns: AI의 응답 텍스트
  Future<String> sendConversation({
    required List<Map<String, String>> messages,
    String model = 'google/gemini-2.0-flash-exp:free',
    int maxTokens = 512,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://dreamflow.app',
          'X-Title': 'DreamFlow',
        },
        body: jsonEncode({
          'model': model,
          'messages': messages,
          'max_tokens': maxTokens,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return content;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('OpenRouter API 오류 (${response.statusCode}): ${errorData['error']?['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('OpenRouter API 호출 실패: $e');
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
