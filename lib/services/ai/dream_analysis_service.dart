import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/dream_conversation.dart';
import 'conversation_storage_service.dart';

/// Lumi AI 꿈 분석 서비스 (OpenAI GPT-4o-mini)
class DreamAnalysisService {
  static final DreamAnalysisService _instance = DreamAnalysisService._internal();
  factory DreamAnalysisService() => _instance;
  DreamAnalysisService._internal();

  // OpenAI API 설정
  static const String _apiKey = 'YOUR_OPENAI_API_KEY_HERE'; // TODO: 실제 API 키로 교체
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _model = 'gpt-4o-mini';

  // 입력/출력 제한 (비용 절감)
  static const int _maxInputCharacters = 500; // 최대 입력 500자 (~250 토큰)
  static const int _maxOutputTokens = 500; // 최대 출력 500 토큰

  // 사용 제한 추적 키
  static const String _dailyUsageKey = 'dream_analysis_daily_usage';
  static const String _monthlyUsageKey = 'dream_analysis_monthly_usage';
  static const String _lastResetDateKey = 'dream_analysis_last_reset';

  /// 꿈 분석 결과 (OpenAI API 사용)
  Future<DreamAnalysisResult> analyzeDream({
    required String dreamContent,
    bool isPremium = false,
    bool useRealAI = true, // 실제 AI 사용 여부 (테스트용 플래그)
  }) async {
    // 사용 가능 여부 확인
    final canUse = await canUseAnalysis(isPremium: isPremium);
    if (!canUse) {
      throw Exception(
        isPremium
            ? '일일 한도 초과 (10회/일, 300회/월). 내일 다시 시도해주세요.'
            : '오늘의 무료 분석 (1회)을 모두 사용했습니다. 리워드 광고를 시청하거나 프리미엄으로 업그레이드하세요.',
      );
    }

    // 입력 길이 제한
    final limitedContent = dreamContent.length > _maxInputCharacters
        ? dreamContent.substring(0, _maxInputCharacters)
        : dreamContent;

    DreamAnalysisResult result;

    // 실제 AI 사용 시
    if (useRealAI && _apiKey != 'YOUR_OPENAI_API_KEY_HERE') {
      try {
        result = await _analyzeWithOpenAI(limitedContent, isPremium);
      } catch (e) {
        debugPrint('❌ OpenAI API 오류: $e');
        // API 실패 시 시뮬레이션으로 폴백
        result = await _analyzeWithSimulation(limitedContent, isPremium);
      }
    } else {
      // 시뮬레이션 사용 (API 키 없거나 테스트 모드)
      result = await _analyzeWithSimulation(limitedContent, isPremium);
    }

    // 사용 기록 저장
    await _recordUsage();

    return result;
  }

  /// OpenAI GPT-4o-mini로 실제 분석
  Future<DreamAnalysisResult> _analyzeWithOpenAI(
    String dreamContent,
    bool isPremium,
  ) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: json.encode({
        'model': _model,
        'messages': [
          {
            'role': 'system',
            'content': '''당신은 Lumi라는 친근한 자각몽 전문 AI 코치입니다.
사용자의 꿈을 분석하고, 자각몽 신호를 찾아주며, 실용적인 조언을 제공합니다.
분석은 한국어로 작성하고, 친근하고 따뜻한 톤을 유지하세요.

다음 항목을 포함해주세요:
1. 주요 키워드 (3-5개)
2. 감정 분석
3. 자각몽 신호 (있다면)
4. 꿈의 의미 해석
5. 자각몽 훈련 조언 (2-3가지)

간결하고 실용적으로 작성해주세요.'''
          },
          {
            'role': 'user',
            'content': '다음 꿈을 분석해주세요:\n\n$dreamContent'
          }
        ],
        'max_tokens': _maxOutputTokens,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final analysisText = data['choices'][0]['message']['content'] as String;

      // OpenAI 응답을 DreamAnalysisResult로 변환
      return _parseOpenAIResponse(analysisText, isPremium);
    } else {
      throw Exception('OpenAI API 오류: ${response.statusCode}');
    }
  }

  /// OpenAI 응답을 DreamAnalysisResult로 파싱
  DreamAnalysisResult _parseOpenAIResponse(String analysisText, bool isPremium) {
    // 간단한 파싱 (실제로는 더 정교하게 구현 가능)
    return DreamAnalysisResult(
      keywords: _extractKeywordsFromText(analysisText),
      emotions: _extractEmotionsFromText(analysisText),
      symbols: [],
      lucidDreamPotential: 0.5,
      interpretation: analysisText,
      recommendations: _extractRecommendationsFromText(analysisText),
      isPremiumAnalysis: isPremium,
    );
  }

  List<String> _extractKeywordsFromText(String text) {
    // TODO: 더 정교한 키워드 추출 로직
    return ['자각몽', '꿈 분석', 'Lumi'];
  }

  List<String> _extractEmotionsFromText(String text) {
    // TODO: 감정 추출 로직
    return ['중립'];
  }

  List<String> _extractRecommendationsFromText(String text) {
    // TODO: 조언 추출 로직
    return ['꿈 일기를 계속 작성하세요', 'Reality Check를 연습하세요'];
  }

  /// 시뮬레이션 분석 (폴백용)
  Future<DreamAnalysisResult> _analyzeWithSimulation(
    String dreamContent,
    bool isPremium,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    // 간단한 키워드 분석
    final keywords = _extractKeywords(dreamContent);
    final emotions = _analyzeEmotions(dreamContent);
    final symbols = _identifySymbols(dreamContent);
    final lucidDreamPotential = _assessLucidDreamPotential(dreamContent);

    return DreamAnalysisResult(
      keywords: keywords,
      emotions: emotions,
      symbols: symbols,
      lucidDreamPotential: lucidDreamPotential,
      interpretation: _generateInterpretation(keywords, emotions, symbols),
      recommendations: _generateRecommendations(lucidDreamPotential, isPremium),
      isPremiumAnalysis: isPremium,
    );
  }

  List<String> _extractKeywords(String content) {
    final keywords = <String>[];
    final lowerContent = content.toLowerCase();

    // 자각몽 관련 키워드
    if (lowerContent.contains('날아') || lowerContent.contains('비행')) {
      keywords.add('비행');
    }
    if (lowerContent.contains('떨어') || lowerContent.contains('추락')) {
      keywords.add('추락');
    }
    if (lowerContent.contains('물') || lowerContent.contains('바다')) {
      keywords.add('물');
    }
    if (lowerContent.contains('쫓') || lowerContent.contains('도망')) {
      keywords.add('추격');
    }
    if (lowerContent.contains('집') || lowerContent.contains('건물')) {
      keywords.add('건물/공간');
    }

    return keywords.isEmpty ? ['일상', '경험'] : keywords;
  }

  List<String> _analyzeEmotions(String content) {
    final emotions = <String>[];
    final lowerContent = content.toLowerCase();

    if (lowerContent.contains('무서') || lowerContent.contains('두렵')) {
      emotions.add('두려움');
    }
    if (lowerContent.contains('기쁘') || lowerContent.contains('행복')) {
      emotions.add('기쁨');
    }
    if (lowerContent.contains('슬프') || lowerContent.contains('우울')) {
      emotions.add('슬픔');
    }
    if (lowerContent.contains('화가') || lowerContent.contains('짜증')) {
      emotions.add('분노');
    }

    return emotions.isEmpty ? ['중립'] : emotions;
  }

  List<DreamSymbol> _identifySymbols(String content) {
    final symbols = <DreamSymbol>[];
    final lowerContent = content.toLowerCase();

    if (lowerContent.contains('날아') || lowerContent.contains('비행')) {
      symbols.add(DreamSymbol(
        name: '비행',
        meaning: '자유, 해방, 제약에서 벗어남',
        lucidDreamSignal: true,
      ));
    }

    if (lowerContent.contains('물') || lowerContent.contains('바다')) {
      symbols.add(DreamSymbol(
        name: '물',
        meaning: '감정, 무의식, 정화',
        lucidDreamSignal: false,
      ));
    }

    if (lowerContent.contains('거울')) {
      symbols.add(DreamSymbol(
        name: '거울',
        meaning: '자아 성찰, 자각',
        lucidDreamSignal: true,
      ));
    }

    return symbols;
  }

  double _assessLucidDreamPotential(String content) {
    int signals = 0;
    final lowerContent = content.toLowerCase();

    // 자각몽 신호 체크
    if (lowerContent.contains('이상하')) signals++;
    if (lowerContent.contains('현실')) signals++;
    if (lowerContent.contains('꿈')) signals++;
    if (lowerContent.contains('날아')) signals++;
    if (lowerContent.contains('텍스트') || lowerContent.contains('글자')) signals++;

    // 0.0 ~ 1.0 사이 값
    return (signals / 5).clamp(0.2, 1.0);
  }

  String _generateInterpretation(
    List<String> keywords,
    List<String> emotions,
    List<DreamSymbol> symbols,
  ) {
    final parts = <String>[];

    if (keywords.isNotEmpty) {
      parts.add('이 꿈은 ${keywords.join(', ')}와 관련이 있습니다.');
    }

    if (emotions.isNotEmpty) {
      parts.add('주요 감정은 ${emotions.join(', ')}입니다.');
    }

    if (symbols.isNotEmpty) {
      final lucidSignals = symbols.where((s) => s.lucidDreamSignal).length;
      if (lucidSignals > 0) {
        parts.add('$lucidSignals개의 자각몽 신호가 발견되었습니다!');
      }
    }

    return parts.isEmpty
        ? '당신의 꿈은 평범한 일상을 반영하고 있습니다.'
        : parts.join(' ');
  }

  List<String> _generateRecommendations(
    double lucidPotential,
    bool isPremium,
  ) {
    final recommendations = <String>[];

    if (lucidPotential > 0.7) {
      recommendations.add('높은 자각몽 가능성! Reality Check를 더 자주 연습하세요.');
      recommendations.add('꿈 일기를 계속 작성하면 패턴을 발견할 수 있습니다.');
    } else if (lucidPotential > 0.4) {
      recommendations.add('자각몽 신호가 일부 발견되었습니다.');
      recommendations.add('MILD 기법으로 자각을 높여보세요.');
    } else {
      recommendations.add('꿈을 더 자세히 기록해보세요.');
      recommendations.add('Reality Check를 꾸준히 연습하세요.');
    }

    if (isPremium) {
      recommendations.add('💎 [프리미엄] WILD 기법을 시도해보세요.');
      recommendations.add('💎 [프리미엄] 바이노럴 비트 명상을 활용하세요.');
    }

    return recommendations;
  }

  /// 사용량 추적 및 제한 관리

  /// 일일 사용 횟수 조회
  Future<int> getDailyUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    await _resetUsageIfNeeded(prefs);
    return prefs.getInt(_dailyUsageKey) ?? 0;
  }

  /// 월간 사용 횟수 조회
  Future<int> getMonthlyUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    await _resetUsageIfNeeded(prefs);
    return prefs.getInt(_monthlyUsageKey) ?? 0;
  }

  /// 사용 가능 여부 확인
  Future<bool> canUseAnalysis({required bool isPremium}) async {
    final dailyCount = await getDailyUsageCount();
    final monthlyCount = await getMonthlyUsageCount();

    if (isPremium) {
      // 프리미엄: 하루 10회, 월 300회
      return dailyCount < 10 && monthlyCount < 300;
    } else {
      // 무료: 하루 1회
      return dailyCount < 1;
    }
  }

  /// 사용 기록 저장
  Future<void> _recordUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final dailyCount = await getDailyUsageCount();
    final monthlyCount = await getMonthlyUsageCount();

    await prefs.setInt(_dailyUsageKey, dailyCount + 1);
    await prefs.setInt(_monthlyUsageKey, monthlyCount + 1);
  }

  /// 사용 기록 초기화 (날짜가 바뀌었을 때)
  Future<void> _resetUsageIfNeeded(SharedPreferences prefs) async {
    final now = DateTime.now();
    final lastResetStr = prefs.getString(_lastResetDateKey);

    if (lastResetStr == null) {
      // 첫 실행
      await prefs.setString(_lastResetDateKey, now.toIso8601String());
      return;
    }

    final lastReset = DateTime.parse(lastResetStr);

    // 날짜가 바뀌었으면 일일 사용량 초기화
    if (now.day != lastReset.day ||
        now.month != lastReset.month ||
        now.year != lastReset.year) {
      await prefs.setInt(_dailyUsageKey, 0);
      await prefs.setString(_lastResetDateKey, now.toIso8601String());
    }

    // 월이 바뀌었으면 월간 사용량 초기화
    if (now.month != lastReset.month || now.year != lastReset.year) {
      await prefs.setInt(_monthlyUsageKey, 0);
    }
  }

  /// 사용량 초기화 (테스트용)
  Future<void> resetUsageForTesting() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyUsageKey, 0);
    await prefs.setInt(_monthlyUsageKey, 0);
    await prefs.setString(_lastResetDateKey, DateTime.now().toIso8601String());
  }

  // ========== 대화형 분석 (Conversational Analysis) ==========

  /// 대화형 꿈 분석 (대화 내역 포함)
  ///
  /// 토큰을 소모하여 Lumi와 연속적인 대화 가능
  Future<DreamConversation> analyzeWithConversation({
    required DreamConversation conversation,
    required String userMessage,
    bool useRealAI = true,
  }) async {
    // 시스템 프롬프트 추가 (대화 시작 시)
    DreamConversation updatedConversation = conversation;
    if (conversation.messages.isEmpty) {
      updatedConversation = conversation.addMessage(
        ConversationMessage.system(_getConversationalSystemPrompt()),
      );
    }

    // 사용자 메시지 추가
    updatedConversation = updatedConversation.addMessage(
      ConversationMessage.user(userMessage),
    );

    // 대화 제한 확인 (메시지 수 또는 토큰 수)
    if (updatedConversation.messages.length >
        20) {
      // 최근 10개 메시지만 유지 (시스템 프롬프트 + 9개)
      final systemPrompt = updatedConversation.messages.first;
      final recentMessages =
          updatedConversation.messages.skip(1).toList().sublist(
                updatedConversation.messages.length - 10,
              );
      updatedConversation = DreamConversation(
        id: updatedConversation.id,
        userId: updatedConversation.userId,
        createdAt: updatedConversation.createdAt,
        updatedAt: DateTime.now(),
        messages: [systemPrompt, ...recentMessages],
        tokenCount: updatedConversation.tokenCount,
      );
    }

    // AI 분석 (대화 내역 포함)
    String aiResponse;
    if (useRealAI && _apiKey != 'YOUR_OPENAI_API_KEY_HERE') {
      try {
        aiResponse = await _analyzeConversationWithOpenAI(updatedConversation);
      } catch (e) {
        debugPrint('❌ OpenAI API 오류: $e');
        aiResponse = await _analyzeConversationWithSimulation(
          updatedConversation,
          userMessage,
        );
      }
    } else {
      aiResponse = await _analyzeConversationWithSimulation(
        updatedConversation,
        userMessage,
      );
    }

    // AI 응답 추가
    updatedConversation = updatedConversation.addMessage(
      ConversationMessage.assistant(aiResponse),
    );

    // 대화 저장
    await ConversationStorageService().saveConversation(updatedConversation);

    return updatedConversation;
  }

  /// 대화형 시스템 프롬프트
  String _getConversationalSystemPrompt() {
    return '''당신은 Lumi라는 친근한 자각몽 전문 AI 코치입니다.
사용자와 연속적인 대화를 통해 꿈을 분석하고, 자각몽 신호를 찾아주며, 실용적인 조언을 제공합니다.

대화 스타일:
- 친근하고 따뜻한 톤 유지
- 이전 대화 내용을 기억하고 참조
- 사용자의 질문에 구체적으로 답변
- 필요시 추가 질문으로 정보 수집

분석 포함 사항:
1. 이전 꿈과의 연관성 (있다면)
2. 자각몽 신호 식별
3. 꿈의 의미 해석
4. 실용적인 자각몽 훈련 조언

한국어로 작성하고, 자연스러운 대화체를 사용하세요.''';
  }

  /// OpenAI로 대화형 분석
  Future<String> _analyzeConversationWithOpenAI(
    DreamConversation conversation,
  ) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: json.encode({
        'model': _model,
        'messages': conversation.toOpenAIMessages(),
        'max_tokens': _maxOutputTokens,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('OpenAI API 오류: ${response.statusCode}');
    }
  }

  /// 시뮬레이션으로 대화형 분석
  Future<String> _analyzeConversationWithSimulation(
    DreamConversation conversation,
    String userMessage,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final lowerMessage = userMessage.toLowerCase();

    // 간단한 대화 시뮬레이션
    if (lowerMessage.contains('자각몽') && lowerMessage.contains('신호')) {
      return '''네, 자각몽 신호에 대해 설명해드릴게요!

자각몽 신호는 꿈에서 현실과 다른 이상한 요소들입니다. 대표적인 예시는:

🌟 비행: 꿈에서 날아다니는 경험
🔄 반복되는 패턴: 같은 장소나 상황의 반복
⏰ 작동하지 않는 시계: 시간이 계속 바뀜
📝 읽을 수 없는 글자: 텍스트가 계속 변함

이런 신호를 발견하면 Reality Check를 해보세요!''';
    } else if (lowerMessage.contains('비행') || lowerMessage.contains('날아')) {
      return '''비행 꿈은 자각몽의 강력한 신호입니다! 🌟

다음번 비행 경험을 할 때:
1. "내가 지금 꿈을 꾸고 있나?" 자문해보세요
2. Reality Check: 손을 자세히 보거나 코를 막고 숨쉬기
3. 자각이 되면 천천히 날며 꿈 환경을 탐험하세요

비행은 자유와 해방의 상징이기도 합니다!''';
    } else if (lowerMessage.contains('어떻게') || lowerMessage.contains('방법')) {
      return '''자각몽 훈련 방법을 알려드릴게요:

📝 꿈 일기 작성 (매일)
- 일어나자마자 꿈을 기록
- 패턴과 자각몽 신호 찾기

🔍 Reality Check (하루 10회 이상)
- "지금 꿈인가?" 자문
- 손가락 세기, 코 막고 숨쉬기

⏰ WBTB 기법
- 잠든 후 5-6시간 뒤 깨어 30분 활동
- 다시 잠들며 자각몽 의도 설정

꾸준히 연습하면 2-4주 내 결과가 나타납니다!''';
    } else if (lowerMessage.contains('고마워') ||
        lowerMessage.contains('감사')) {
      return '''천만에요! 😊 자각몽 여행을 응원할게요!

궁금한 점이 더 있으시면 언제든 물어보세요.
함께 꿈의 세계를 탐험해봐요! ✨''';
    } else {
      // 기본 응답
      final keywords = _extractKeywords(userMessage);
      return '''말씀하신 내용에 대해 조금 더 자세히 설명해주시겠어요?

${keywords.isNotEmpty ? '${keywords.join(', ')}에 대해' : '꿈 내용에 대해'} 더 궁금한 점이 있으시면 구체적으로 질문해주세요!

예를 들어:
- "이게 자각몽 신호인가요?"
- "다음에는 어떻게 해야 하나요?"
- "왜 이런 꿈을 꾸는 건가요?"''';
    }
  }
}

/// 꿈 분석 결과
class DreamAnalysisResult {
  final List<String> keywords;
  final List<String> emotions;
  final List<DreamSymbol> symbols;
  final double lucidDreamPotential; // 0.0 ~ 1.0
  final String interpretation;
  final List<String> recommendations;
  final bool isPremiumAnalysis;

  DreamAnalysisResult({
    required this.keywords,
    required this.emotions,
    required this.symbols,
    required this.lucidDreamPotential,
    required this.interpretation,
    required this.recommendations,
    required this.isPremiumAnalysis,
  });
}

/// 꿈 상징
class DreamSymbol {
  final String name;
  final String meaning;
  final bool lucidDreamSignal; // 자각몽 신호인지 여부

  DreamSymbol({
    required this.name,
    required this.meaning,
    required this.lucidDreamSignal,
  });
}
