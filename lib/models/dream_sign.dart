/// Dream Sign (꿈 신호) 모델
///
/// 출처: Paul Tholey의 연구 (1980s)
/// Stephen LaBerge의 Dream Sign 분류 (1985)
///
/// 꿈 신호는 꿈에서 자주 나타나는 비정상적 요소로,
/// 이를 인식하면 자각몽을 유도할 수 있습니다.
class DreamSign {
  final String id;
  final DreamSignCategory category;
  final String description;
  final int frequency; // 출현 횟수
  final DateTime firstSeen;
  final DateTime lastSeen;

  const DreamSign({
    required this.id,
    required this.category,
    required this.description,
    required this.frequency,
    required this.firstSeen,
    required this.lastSeen,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'description': description,
      'frequency': frequency,
      'firstSeen': firstSeen.toIso8601String(),
      'lastSeen': lastSeen.toIso8601String(),
    };
  }

  factory DreamSign.fromJson(Map<String, dynamic> json) {
    return DreamSign(
      id: json['id'] as String,
      category: DreamSignCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      description: json['description'] as String,
      frequency: json['frequency'] as int,
      firstSeen: DateTime.parse(json['firstSeen'] as String),
      lastSeen: DateTime.parse(json['lastSeen'] as String),
    );
  }
}

/// Dream Sign 카테고리 (Paul Tholey의 4대 분류)
///
/// 출처: Tholey, P. (1983). "Techniques for inducing and manipulating lucid dreams"
enum DreamSignCategory {
  /// Awareness (자각) - 생각, 감정, 인식의 비정상성
  /// 예: "이상하다고 느꼈지만 꿈인지 몰랐다"
  awareness,

  /// Action (행동) - 본인 또는 타인의 비정상적 행동
  /// 예: 날기, 벽 통과, 순간이동, 죽었다 살아남
  action,

  /// Form (형태) - 사람, 장소, 사물의 비정상적 형태
  /// 예: 변형된 얼굴, 이상한 동물, 존재하지 않는 장소
  form,

  /// Context (맥락) - 시간, 장소, 상황의 비정상적 맥락
  /// 예: 죽은 사람이 살아있음, 과거와 현재 혼재
  context,
}

extension DreamSignCategoryExtension on DreamSignCategory {
  String get displayName {
    switch (this) {
      case DreamSignCategory.awareness:
        return '자각 (Awareness)';
      case DreamSignCategory.action:
        return '행동 (Action)';
      case DreamSignCategory.form:
        return '형태 (Form)';
      case DreamSignCategory.context:
        return '맥락 (Context)';
    }
  }

  String get description {
    switch (this) {
      case DreamSignCategory.awareness:
        return '생각, 감정, 인식의 비정상성';
      case DreamSignCategory.action:
        return '본인 또는 타인의 비정상적 행동';
      case DreamSignCategory.form:
        return '사람, 장소, 사물의 비정상적 형태';
      case DreamSignCategory.context:
        return '시간, 장소, 상황의 비정상적 맥락';
    }
  }

  String get example {
    switch (this) {
      case DreamSignCategory.awareness:
        return '예: 이상하다고 느꼈지만 꿈인지 몰랐다';
      case DreamSignCategory.action:
        return '예: 날기, 벽 통과, 순간이동';
      case DreamSignCategory.form:
        return '예: 변형된 얼굴, 이상한 동물';
      case DreamSignCategory.context:
        return '예: 죽은 사람이 살아있음, 시간 불일치';
    }
  }

  /// 자각몽 유도 잠재력 (0.0 - 1.0)
  /// 연구에 따르면 Action과 Context가 가장 효과적
  double get lucidityPotential {
    switch (this) {
      case DreamSignCategory.awareness:
        return 0.7;
      case DreamSignCategory.action:
        return 0.9; // 가장 효과적
      case DreamSignCategory.form:
        return 0.6;
      case DreamSignCategory.context:
        return 0.8;
    }
  }
}

/// 자각도 척도 (Stephen LaBerge)
///
/// 출처: LaBerge, S. (1985). "Lucid Dreaming: The Power of Being Awake and Aware in Your Dreams"
enum LucidityLevel {
  /// 0 - 일반 꿈 (자각 없음)
  none,

  /// 1-3 - 낮은 자각
  /// "뭔가 이상하다"고 느끼지만 꿈임을 인식하지 못함
  low,

  /// 4-6 - 중간 자각
  /// 꿈임을 알지만 통제가 어렵고 곧 잊어버림
  medium,

  /// 7-9 - 높은 자각
  /// 꿈임을 알고 부분적으로 통제 가능
  high,

  /// 10 - 완전 자각
  /// 완전한 통제와 명료함, 깨어있을 때와 동일한 의식
  full,
}

extension LucidityLevelExtension on LucidityLevel {
  int get minScore {
    switch (this) {
      case LucidityLevel.none:
        return 0;
      case LucidityLevel.low:
        return 1;
      case LucidityLevel.medium:
        return 4;
      case LucidityLevel.high:
        return 7;
      case LucidityLevel.full:
        return 10;
    }
  }

  int get maxScore {
    switch (this) {
      case LucidityLevel.none:
        return 0;
      case LucidityLevel.low:
        return 3;
      case LucidityLevel.medium:
        return 6;
      case LucidityLevel.high:
        return 9;
      case LucidityLevel.full:
        return 10;
    }
  }

  String get displayName {
    switch (this) {
      case LucidityLevel.none:
        return '일반 꿈';
      case LucidityLevel.low:
        return '낮은 자각';
      case LucidityLevel.medium:
        return '중간 자각';
      case LucidityLevel.high:
        return '높은 자각';
      case LucidityLevel.full:
        return '완전 자각';
    }
  }

  String get description {
    switch (this) {
      case LucidityLevel.none:
        return '자각 없음';
      case LucidityLevel.low:
        return '이상함을 느끼지만 꿈임을 모름';
      case LucidityLevel.medium:
        return '꿈임을 알지만 통제 어려움';
      case LucidityLevel.high:
        return '꿈임을 알고 부분 통제 가능';
      case LucidityLevel.full:
        return '완전한 통제와 명료함';
    }
  }

  static LucidityLevel fromScore(int score) {
    if (score == 0) return LucidityLevel.none;
    if (score <= 3) return LucidityLevel.low;
    if (score <= 6) return LucidityLevel.medium;
    if (score <= 9) return LucidityLevel.high;
    return LucidityLevel.full;
  }
}

/// 자각몽 유도 기법 (과학적으로 입증된)
///
/// 출처:
/// - LaBerge, S. (1980). "Lucid dreaming as a learnable skill"
/// - Stumbrys et al. (2012). "Induction of lucid dreams: A systematic review of evidence"
/// - Aspy et al. (2017). "Reality testing and the mnemonic induction of lucid dreams"
enum LucidDreamTechnique {
  /// MILD (Mnemonic Induction of Lucid Dreams)
  /// 효과: ★★★★★ (LaBerge, 1980)
  /// 취침 전 "다음 꿈에서 꿈임을 알아차리겠다" 반복
  mild,

  /// WBTB (Wake Back to Bed)
  /// 효과: ★★★★★ (Stumbrys et al., 2012)
  /// 5-6시간 수면 후 깨서 30-60분 깨어있다가 다시 수면
  wbtb,

  /// Reality Check (현실 확인)
  /// 효과: ★★★★☆ (Aspy et al., 2017)
  /// 하루 10회 이상 "지금 꿈인가?" 확인
  realityCheck,

  /// SSILD (Senses Initiated Lucid Dream)
  /// 효과: ★★★★☆
  /// 시각, 청각, 촉각에 순차적으로 집중
  ssild,

  /// WILD (Wake Initiated Lucid Dream)
  /// 효과: ★★★☆☆ (어려움)
  /// 의식을 유지하며 직접 꿈으로 진입
  wild,

  /// Dream Signs Recognition
  /// 효과: ★★★★☆ (Tholey, 1983)
  /// 꿈 신호를 인식하고 Reality Check 수행
  dreamSigns,
}

extension LucidDreamTechniqueExtension on LucidDreamTechnique {
  String get displayName {
    switch (this) {
      case LucidDreamTechnique.mild:
        return 'MILD (기억 유도법)';
      case LucidDreamTechnique.wbtb:
        return 'WBTB (중간 기상법)';
      case LucidDreamTechnique.realityCheck:
        return 'Reality Check (현실 확인)';
      case LucidDreamTechnique.ssild:
        return 'SSILD (감각 유도법)';
      case LucidDreamTechnique.wild:
        return 'WILD (직접 진입법)';
      case LucidDreamTechnique.dreamSigns:
        return 'Dream Signs (꿈 신호)';
    }
  }

  String get description {
    switch (this) {
      case LucidDreamTechnique.mild:
        return '취침 전 "다음 꿈에서 꿈임을 알아차리겠다" 반복';
      case LucidDreamTechnique.wbtb:
        return '5-6시간 수면 후 30-60분 깨어있다가 다시 수면';
      case LucidDreamTechnique.realityCheck:
        return '하루 10회 이상 "지금 꿈인가?" 확인';
      case LucidDreamTechnique.ssild:
        return '시각, 청각, 촉각에 순차적으로 집중';
      case LucidDreamTechnique.wild:
        return '의식을 유지하며 직접 꿈으로 진입';
      case LucidDreamTechnique.dreamSigns:
        return '꿈 신호를 인식하고 Reality Check 수행';
    }
  }

  /// 효과성 (0.0 - 1.0, 연구 기반)
  double get effectiveness {
    switch (this) {
      case LucidDreamTechnique.mild:
        return 0.9; // 가장 효과적 (LaBerge, 1980)
      case LucidDreamTechnique.wbtb:
        return 0.95; // MILD와 결합시 최고 효과
      case LucidDreamTechnique.realityCheck:
        return 0.7;
      case LucidDreamTechnique.ssild:
        return 0.75;
      case LucidDreamTechnique.wild:
        return 0.5; // 어렵지만 성공시 강력
      case LucidDreamTechnique.dreamSigns:
        return 0.8;
    }
  }

  /// 난이도 (0.0 - 1.0)
  double get difficulty {
    switch (this) {
      case LucidDreamTechnique.mild:
        return 0.3; // 쉬움
      case LucidDreamTechnique.wbtb:
        return 0.4;
      case LucidDreamTechnique.realityCheck:
        return 0.2; // 매우 쉬움
      case LucidDreamTechnique.ssild:
        return 0.5;
      case LucidDreamTechnique.wild:
        return 0.9; // 매우 어려움
      case LucidDreamTechnique.dreamSigns:
        return 0.4;
    }
  }
}

/// 꿈 회상 프롬프트 (과학적 근거 기반)
///
/// 출처: Schredl, M. (2002). "Questionnaires and diaries as research instruments in dream research"
class DreamRecallPrompt {
  /// 1. 감정부터 기록 (감정이 내용보다 오래 유지됨)
  static const String emotionFirst =
      '꿈에서 느낀 감정을 먼저 떠올려보세요. 기쁨? 불안? 흥분?';

  /// 2. 마지막 장면부터 역순으로 (역순 회상이 더 효과적)
  static const String reverseOrder = '꿈의 마지막 장면부터 거꾸로 떠올려보세요.';

  /// 3. 단편적인 기억도 기록 (작은 조각이 더 큰 기억을 불러옴)
  static const String fragmentsOkay = '작은 조각이라도 괜찮습니다. 떠오르는 대로 적어보세요.';

  /// 4. 5분 이내에 기록 (깨어난 후 5분 내 50% 잊음, Ebbinghaus)
  static const String writeFast = '깨어나자마자 바로 기록하세요 (5분 이내 권장)';

  /// 5. 키워드만이라도 (완벽한 문장이 아니어도 됨)
  static const String keywordsOkay = '완벽한 문장이 아니어도 됩니다. 키워드만 적어도 좋습니다.';
}
