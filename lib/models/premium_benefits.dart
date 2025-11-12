/// 프리미엄 혜택 정의
///
/// Free vs Premium 기능 비교를 명확히 정의
class PremiumBenefits {
  /// 프로그램 기간
  static const int freeProgramDays = 30; // 무료: 30일 프로그램
  static const int premiumProgramDays = 60; // 프리미엄: 60일 확장 프로그램

  /// Lumi 진화 단계
  static const int freeEvolutionStages = 7; // 무료: 7단계 (기본 → 알파)
  static const int premiumEvolutionStages = 14; // 프리미엄: 14단계 (기본 → 기가)

  /// AI 꿈 분석 횟수
  static const int freeDailyAnalysis = 1; // 무료: 1일 1회 (리워드 광고로 추가 가능)
  static const int premiumDailyAnalysis = 10; // 프리미엄: 하루 10회
  static const int premiumMonthlyAnalysis = 300; // 프리미엄: 월 최대 300회

  /// 대화 토큰 (Lumi와 대화)
  static const int freeDailyConversationTokens = 1; // 무료: 하루 1개 (= 5회 대화)
  static const int premiumDailyConversationTokens = 5; // 프리미엄: 하루 5개 (= 25회 대화)
  static const int messagesPerToken = 5; // 토큰 1개당 5회 대화

  /// 자각몽 기법 라이브러리
  static const int freeTechniques = 5; // 무료: 기본 5가지 (WBTB, MILD, RC, 수면위생, 명상)
  static const int premiumTechniques = 15; // 프리미엄: 고급 기법 추가 (WILD, FILD, SSILD, CAT 등)

  /// 프리미엄 전용 혜택 목록 (코드로 구현 가능한 기능만)
  static List<PremiumBenefit> get allBenefits => [
        // 즉시 혜택 (구매 즉시 사용 가능)
        const PremiumBenefit(
          icon: '🚫',
          title: '광고 제거',
          description: '모든 배너/전면 광고 완전 제거 (영구)',
          category: PremiumBenefitCategory.experience,
          isFree: false,
          isImmediateBenefit: true,
        ),
        const PremiumBenefit(
          icon: '🧠',
          title: '향상된 Lumi 꿈 분석',
          description: 'Lumi가 하루 10회 꿈 분석 (무료 1회 → 10회)',
          category: PremiumBenefitCategory.feature,
          isFree: false,
          isImmediateBenefit: true,
        ),
        const PremiumBenefit(
          icon: '💬',
          title: 'Lumi와 대화',
          description: '하루 5개 토큰으로 Lumi와 25회까지 대화 가능',
          category: PremiumBenefitCategory.feature,
          isFree: false,
          isImmediateBenefit: true,
        ),
        const PremiumBenefit(
          icon: '📊',
          title: '고급 통계 분석',
          description: '꿈 패턴, 자각몽 성공률, 진화 추이 상세 분석',
          category: PremiumBenefitCategory.feature,
          isFree: false,
          isImmediateBenefit: true,
        ),

        // 진행형 혜택 (30일 완료 후 활성화)
        const PremiumBenefit(
          icon: '📅',
          title: '60일 확장 프로그램',
          description: '30일 완료 후 추가 30일 마스터 프로그램 해제',
          category: PremiumBenefitCategory.content,
          isFree: false,
          isImmediateBenefit: false,
        ),
        const PremiumBenefit(
          icon: '✨',
          title: 'Lumi 전체 진화 (14단계)',
          description: '7단계(30일) → 14단계(60일) 진화 경로 해제',
          category: PremiumBenefitCategory.content,
          isFree: false,
          isImmediateBenefit: false,
        ),

        // 무료 사용자도 받는 혜택 (비교용)
        const PremiumBenefit(
          icon: '🌙',
          title: '30일 기본 프로그램',
          description: '과학 기반 자각몽 훈련',
          category: PremiumBenefitCategory.content,
          isFree: true,
        ),
        const PremiumBenefit(
          icon: '📝',
          title: '꿈 일기',
          description: '꿈 기록 및 관리',
          category: PremiumBenefitCategory.feature,
          isFree: true,
        ),
        const PremiumBenefit(
          icon: '✅',
          title: '일일 체크리스트',
          description: 'WBTB, MILD, RC 훈련',
          category: PremiumBenefitCategory.feature,
          isFree: true,
        ),
        const PremiumBenefit(
          icon: '🎁',
          title: '리워드 광고',
          description: '광고 시청으로 프리미엄 기능 체험',
          category: PremiumBenefitCategory.feature,
          isFree: true,
        ),
      ];

  /// 프리미엄 전용 혜택만 필터링
  static List<PremiumBenefit> get premiumOnlyBenefits =>
      allBenefits.where((benefit) => !benefit.isFree).toList();

  /// 무료 사용자 혜택
  static List<PremiumBenefit> get freeBenefits =>
      allBenefits.where((benefit) => benefit.isFree).toList();

  /// 즉시 혜택만 필터링 (구매 즉시 받을 수 있는 것)
  static List<PremiumBenefit> get immediateBenefits =>
      allBenefits.where((benefit) => !benefit.isFree && benefit.isImmediateBenefit).toList();

  /// 진행형 혜택만 필터링 (30일 완료 후 활성화)
  static List<PremiumBenefit> get progressiveBenefits =>
      allBenefits.where((benefit) => !benefit.isFree && !benefit.isImmediateBenefit).toList();

  /// 카테고리별 혜택
  static List<PremiumBenefit> getBenefitsByCategory(
    PremiumBenefitCategory category,
  ) {
    return allBenefits.where((benefit) => benefit.category == category).toList();
  }

  /// 프리미엄 가격
  static const String premiumPrice = '\$6.99'; // 일회성 결제
  static const String premiumProductId = 'premium_lifetime';

  /// 가치 제안 (Value Proposition) - 즉시 혜택 우선 강조
  static const String valueProposition =
      '광고 제거 + Lumi와 대화 (5토큰/일) + 향상된 분석 (10회/일) + 60일 프로그램';

  /// 즉시 혜택 강조 메시지 (30일 진행 중에도 가치 있음)
  static String get immediateBenefitMessage =>
      '지금 바로 광고 없이 Lumi와 대화 + 향상된 분석 (10회/일) + 상세 통계 확인!';

  /// 프리미엄 구매 시 절약 금액 계산
  /// (리워드 광고로 얻어야 하는 가치 vs 일회성 결제)
  static String get savingsMessage {
    // 60일 프로그램 완주 시 필요한 리워드 광고 예상 횟수
    // - 꿈 분석: 60일 × 2회/일 (무료 1회 + 추가 1회) = 60회 광고
    // - WBTB 스킵: 8주 × 2회 = 16회 광고
    // - 진화 가속: 3회 광고
    // 총: 약 79회의 광고 시청 필요 (약 40분)

    return '프리미엄 구매 시 약 80회의 광고 시청 절약 (~40분)';
  }

  /// 프리미엄 혜택 비교 메시지 (마케팅용)
  static Map<String, dynamic> get comparisonChart => {
        'program_days': {
          'free': '$freeProgramDays일',
          'premium': '$premiumProgramDays일',
        },
        'evolution_stages': {
          'free': '$freeEvolutionStages단계',
          'premium': '$premiumEvolutionStages단계',
        },
        'daily_ai_analysis': {
          'free': '$freeDailyAnalysis회/일',
          'premium': '$premiumDailyAnalysis회/일',
        },
        'techniques': {
          'free': '$freeTechniques가지',
          'premium': '$premiumTechniques가지',
        },
        'ads': {
          'free': '있음',
          'premium': '없음',
        },
        'cloud_backup': {
          'free': '없음',
          'premium': '있음',
        },
        'meditation_audio': {
          'free': '없음',
          'premium': '있음',
        },
      };
}

/// 프리미엄 혜택 카테고리
enum PremiumBenefitCategory {
  /// 콘텐츠 (프로그램, 기법, 스킨 등)
  content,

  /// 기능 (AI 분석, 백업, 통계 등)
  feature,

  /// 경험 (광고 제거, 알림 등)
  experience,
}

/// 개별 프리미엄 혜택
class PremiumBenefit {
  final String icon;
  final String title;
  final String description;
  final PremiumBenefitCategory category;
  final bool isFree; // 무료 사용자도 받는 혜택인지
  final bool isImmediateBenefit; // 구매 즉시 받을 수 있는 혜택인지

  const PremiumBenefit({
    required this.icon,
    required this.title,
    required this.description,
    required this.category,
    this.isFree = false,
    this.isImmediateBenefit = true, // 기본값: 즉시 혜택
  });

  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'title': title,
      'description': description,
      'category': category.name,
      'isFree': isFree,
      'isImmediateBenefit': isImmediateBenefit,
    };
  }

  /// JSON에서 생성
  factory PremiumBenefit.fromJson(Map<String, dynamic> json) {
    return PremiumBenefit(
      icon: json['icon'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: PremiumBenefitCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      isFree: json['isFree'] as bool? ?? false,
      isImmediateBenefit: json['isImmediateBenefit'] as bool? ?? true,
    );
  }
}

/// 프리미엄 상태 모델
class PremiumStatus {
  final bool isPremium;
  final DateTime? purchaseDate;
  final String? productId;

  const PremiumStatus({
    required this.isPremium,
    this.purchaseDate,
    this.productId,
  });

  /// 무료 사용자
  static const PremiumStatus free = PremiumStatus(isPremium: false);

  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'isPremium': isPremium,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'productId': productId,
    };
  }

  /// JSON에서 생성
  factory PremiumStatus.fromJson(Map<String, dynamic> json) {
    return PremiumStatus(
      isPremium: json['isPremium'] as bool? ?? false,
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.parse(json['purchaseDate'] as String)
          : null,
      productId: json['productId'] as String?,
    );
  }

  /// 복사
  PremiumStatus copyWith({
    bool? isPremium,
    DateTime? purchaseDate,
    String? productId,
  }) {
    return PremiumStatus(
      isPremium: isPremium ?? this.isPremium,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      productId: productId ?? this.productId,
    );
  }
}
