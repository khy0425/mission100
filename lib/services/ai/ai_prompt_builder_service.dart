/// AI 어시스턴트 기능별 프롬프트 빌더 서비스
///
/// 각 AI 기능(꿈 일기, 기법 추천, 명상 스크립트 등)에 맞는
/// 전문적인 프롬프트를 생성합니다.
class AIPromptBuilderService {
  /// 꿈 일기 작성 프롬프트
  static String buildDreamJournalPrompt(String dreamContent) {
    return '''
당신은 Stephen LaBerge 박사의 연구를 기반으로 훈련받은 자각몽 전문가입니다.
아래 꿈 내용을 과학적 관점에서 분석하여 구조화된 꿈 일기로 작성해주세요:

"$dreamContent"

다음 형식으로 작성해주세요:

**📖 꿈 제목**
(한 문장으로 핵심 요약)

**🎬 주요 장면**
• [장면 1: 구체적 묘사]
• [장면 2: 구체적 묘사]
• [장면 3: 구체적 묘사]

**💭 감정 상태**
[꿈 속 감정과 깨어난 후 감정 분석]

**🔍 Dream Signs (자각몽 신호)**
• [비현실적 요소 1]
• [비현실적 요소 2]
• [패턴이나 반복 요소]

**💡 다음 시도할 기법**
[Stephen LaBerge의 MILD 또는 Paul Tholey의 Reflection 기법 중 적합한 것 추천]

한국어로 간결하고 실용적으로 작성하세요.
''';
  }

  /// 자각몽 기법 추천 프롬프트
  static String buildTechniqueRecommendationPrompt(String userLevel) {
    final level = userLevel.isEmpty ? '초보자' : userLevel;
    return '''
당신은 자각몽 연구의 선구자 Stephen LaBerge, Paul Tholey, Denholm Aspy의 연구를 종합한 전문가입니다.
$level를 위한 과학적으로 검증된 자각몽 기법 3가지를 추천해주세요.

각 기법마다 다음 형식으로 작성:

**1️⃣ [기법명] (연구자/연도)**

📋 **실행 방법**
[단계별 구체적 설명 - 초보자도 따라할 수 있게]

📊 **효과 & 성공률**
[과학 연구 결과 기반 - 구체적 수치나 연구 인용]

⚠️ **주의사항**
[실패 패턴, 피해야 할 실수]

✅ **실전 팁**
[성공 확률을 높이는 구체적 조언]

---

한국어로 즉시 실천 가능하도록 구체적으로 설명해주세요.
''';
  }

  /// 명상 스크립트 프롬프트
  static String buildMeditationScriptPrompt(String duration) {
    final minutes = duration.isEmpty ? '5' : duration;
    return '''
당신은 마음챙김(Mindfulness) 명상과 자각몽 유도를 전문으로 하는 명상 가이드입니다.
$minutes분짜리 자각몽 유도 명상 스크립트를 작성해주세요.

다음 순서로 구성:

**🌙 [0-1분] 편안한 시작**
[호흡 안내 - 4-7-8 호흡법 또는 복식호흡]

**💆 [1-3분] 신체 이완**
[머리부터 발끝까지 Progressive Muscle Relaxation]

**✨ [3-4분] 꿈 세계 시각화**
[꿈 세계로 들어가는 구체적 이미지 - 문, 계단, 빛 등]

**🧠 [4-5분] 자각 강화**
["나는 지금 꿈을 꾸고 있다"는 인식 강화]

**💫 [5분] 긍정 확언**
["오늘 밤 나는 꿈 속에서 깨어난다" 등 3-5개]

---

따뜻하고 차분한 어조로 한국어로 작성하세요.
실제 명상 가이드처럼 "~하세요", "~느껴보세요" 형식으로 작성하세요.
''';
  }

  /// Reality Check 아이디어 프롬프트
  static String buildRealityCheckPrompt(String context) {
    final contextNote = context.isNotEmpty ? '\n특히 다음 상황을 고려해주세요: $context' : '';
    return '''
당신은 Stephen LaBerge의 Reality Testing 이론을 마스터한 자각몽 전문가입니다.
일상생활에서 실천 가능한 Reality Check 아이디어 5가지를 제안해주세요.

각 아이디어마다:

**✋ RC #1: [상황/트리거]**

🎯 **체크 방법**
[구체적인 확인 절차 - 손바닥 보기, 코 막고 숨쉬기 등]

💭 **꿈에서 나타나는 특징**
[현실과 꿈에서의 차이점]

📝 **실천 팁**
[습관화 전략, 성공률 높이는 방법]

🔬 **과학적 근거**
[왜 이 RC가 효과적인지 간단한 설명]

---

창의적이면서도 실용적인 아이디어를 제안하세요.$contextNote

한국어로 작성하세요.
''';
  }

  /// 자유 대화 프롬프트
  static String buildFreeChatPrompt(String question) {
    return '''
당신은 자각몽 분야의 최고 전문가 AI 어시스턴트입니다.
다음과 같은 배경 지식을 가지고 있습니다:
- Stephen LaBerge의 MILD, WILD 기법 연구
- Paul Tholey의 Reflection 기법 및 자각몽 심리학
- Denholm Aspy의 최신 자각몽 실험 연구 (2017, 2020)
- REM 수면 생리학 및 신경과학

사용자의 질문에 친절하고 전문적으로 답변해주세요:

"$question"

답변 구성:
1. **핵심 답변** (2-3문장으로 핵심 요약)
2. **과학적 근거** (연구나 이론 인용)
3. **실전 조언** (즉시 적용 가능한 구체적 방법)
4. **주의사항** (있다면)

한국어로 간결하고 이해하기 쉽게 작성하세요.
과학적 증거와 실용적 조언의 균형을 맞추세요.
''';
  }
}
