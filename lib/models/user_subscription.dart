enum SubscriptionType {
  free, // 무료 사용자 (Week 1만 영구 무료, 광고 있음)
  launchPromo, // 런칭 이벤트 (60일 확장, 30일간, 광고 포함)
  premium, // 프리미엄 (60일 확장, 광고 없음, 일회성 결제)
}

enum SubscriptionStatus {
  active, // 활성 구독
  expired, // 만료됨
  cancelled, // 취소됨
  trial, // 체험중
}

class UserSubscription {
  final String id;
  final String userId;
  final SubscriptionType type;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final bool hasAds;
  final int allowedWeeks;
  final List<String> allowedFeatures;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserSubscription({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.hasAds,
    required this.allowedWeeks,
    required this.allowedFeatures,
    required this.createdAt,
    required this.updatedAt,
  });

  // 무료 사용자 기본 구독 (Week 1만 영구 무료)
  static UserSubscription createFreeSubscription(String userId) {
    final now = DateTime.now();
    return UserSubscription(
      id: 'free_${userId}_${now.millisecondsSinceEpoch}',
      userId: userId,
      type: SubscriptionType.free,
      status: SubscriptionStatus.active,
      startDate: now,
      endDate: null, // 무제한
      hasAds: true,
      allowedWeeks: 1, // Week 1만 영구 무료 (기초 기법만)
      allowedFeatures: [
        'basic_techniques',
        'dream_journal',
        'reality_checks',
        'progress_tracking',
        'basic_stats',
      ],
      createdAt: now,
      updatedAt: now,
    );
  }

  // 런칭 프로모션 구독 (첫 30일 무료, 광고 있음, 60일 프로그램 접근)
  static UserSubscription createLaunchPromoSubscription(String userId) {
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 30)); // 1개월

    return UserSubscription(
      id: 'launch_${userId}_${now.millisecondsSinceEpoch}',
      userId: userId,
      type: SubscriptionType.launchPromo,
      status: SubscriptionStatus.active,
      startDate: now,
      endDate: endDate,
      hasAds: true, // 프로모션 기간에도 광고 있음
      allowedWeeks: 8, // 60일 확장 프로그램 접근 (Week 1-8, Evolution Stage 0-13)
      allowedFeatures: [
        'full_workouts',
        'progress_tracking',
        'advanced_stats',
        'workout_variations',
        'achievement_system',
      ],
      createdAt: now,
      updatedAt: now,
    );
  }

  // 프리미엄 구독 (광고 없음, 60일 확장 프로그램, 14단계 진화)
  static UserSubscription createPremiumSubscription(String userId) {
    final now = DateTime.now();

    return UserSubscription(
      id: 'premium_${userId}_${now.millisecondsSinceEpoch}',
      userId: userId,
      type: SubscriptionType.premium,
      status: SubscriptionStatus.active,
      startDate: now,
      endDate: null, // 일회성 결제 (평생 - 무제한)
      hasAds: false, // 광고 제거
      allowedWeeks: 8, // 60일 확장 프로그램 (Week 1-8, Evolution Stage 0-13)
      allowedFeatures: [
        'full_workouts',
        'progress_tracking',
        'advanced_stats',
        'workout_variations',
        'achievement_system',
        'premium_features',
        'advanced_analytics',
        'export_data',
        'unlimited_ai_analysis',
        'extended_program_60days',
        'lumi_full_evolution',
      ],
      createdAt: now,
      updatedAt: now,
    );
  }

  // 구독 유효성 확인
  bool get isValid {
    if (status != SubscriptionStatus.active) return false;
    if (endDate != null && DateTime.now().isAfter(endDate!)) return false;
    return true;
  }

  // 남은 일수 계산
  int? get remainingDays {
    if (endDate == null) return null; // 무제한
    final remaining = endDate!.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  // 만료 여부 확인
  bool get isExpired {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  // 특정 주차 접근 권한 확인
  bool canAccessWeek(int week) {
    if (!isValid) return false;
    return week <= allowedWeeks;
  }

  // 특정 기능 사용 권한 확인
  bool hasFeature(String feature) {
    if (!isValid) return false;
    return allowedFeatures.contains(feature);
  }

  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'status': status.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'hasAds': hasAds,
      'allowedWeeks': allowedWeeks,
      'allowedFeatures': allowedFeatures,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: SubscriptionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SubscriptionType.free,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SubscriptionStatus.expired,
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      hasAds: json['hasAds'] as bool,
      allowedWeeks: json['allowedWeeks'] as int,
      allowedFeatures: List<String>.from(json['allowedFeatures'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // copyWith 메서드
  UserSubscription copyWith({
    String? id,
    String? userId,
    SubscriptionType? type,
    SubscriptionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    bool? hasAds,
    int? allowedWeeks,
    List<String>? allowedFeatures,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSubscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      hasAds: hasAds ?? this.hasAds,
      allowedWeeks: allowedWeeks ?? this.allowedWeeks,
      allowedFeatures: allowedFeatures ?? this.allowedFeatures,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserSubscription(id: $id, type: $type, status: $status, remainingDays: $remainingDays)';
  }
}

/// 프리미엄 기능 열거형
///
/// 새 구독 모델 (V3 - Model B):
/// - 무료 사용자: Week 1만 영구 무료, 광고 있음, Level 1 cap
/// - 프리미엄 사용자: Week 1-8 (60일), Lumi 진화 0-13단계 (14단계), 광고 제거, Level 9 cap
/// - 프리미엄 혜택: 광고 제거 + 무제한 AI 분석 + 고급 통계 + 60일 확장
enum PremiumFeature {
  adFree, // 광고 제거 (프리미엄만)
  unlimitedAiAnalysis, // 무제한 Lumi 꿈 분석 (프리미엄만)
  advancedStats, // 고급 통계 분석 (프리미엄만)
  extendedProgram, // 60일 확장 프로그램 (프리미엄만)
  lumiFullEvolution, // Lumi 14단계 진화 (프리미엄만)
  prioritySupport, // 우선 지원 (프리미엄만)
}
