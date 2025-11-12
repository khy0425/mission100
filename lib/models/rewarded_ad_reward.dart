/// 리워드 광고 보상 타입
enum RewardedAdType {
  /// Lumi AI 꿈 분석 리포트 (1일 1회 무료, 광고로 추가)
  dreamAnalysis,

  /// WBTB 체크인 스킵권 (주 2회)
  wbtbSkip,

  /// 진화 가속권 (총 3회 사용 가능)
  evolutionBoost,

  /// 60일 프로그램 미리보기 (기법당 1회)
  premiumPreview,

  /// Lumi 스페셜 스킨 (스킨당 1회)
  specialSkin,
}

/// 리워드 광고 보상 정보
class RewardedAdReward {
  final RewardedAdType type;
  final String title;
  final String description;
  final String icon;
  final int maxUsage; // -1이면 무제한
  final Duration? cooldown; // 쿨다운 시간

  const RewardedAdReward({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.maxUsage,
    this.cooldown,
  });

  /// 꿈 분석 리워드
  static const dreamAnalysis = RewardedAdReward(
    type: RewardedAdType.dreamAnalysis,
    title: 'Lumi AI 꿈 분석',
    description: '광고를 보고 Lumi가 당신의 꿈을 분석받으세요',
    icon: '🧠',
    maxUsage: -1, // 무제한 (하지만 1일 1회 무료 후)
    cooldown: Duration(hours: 1), // 1시간 쿨다운
  );

  /// WBTB 스킵권 리워드
  static const wbtbSkip = RewardedAdReward(
    type: RewardedAdType.wbtbSkip,
    title: 'WBTB 스킵권',
    description: '바쁜 하루였나요? 오늘 WBTB를 완료한 것으로 인정해드릴게요',
    icon: '⏰',
    maxUsage: 2, // 주 2회
    cooldown: Duration(days: 3), // 3일 쿨다운
  );

  /// 진화 가속권 리워드
  static const evolutionBoost = RewardedAdReward(
    type: RewardedAdType.evolutionBoost,
    title: '진화 가속권',
    description: '다음 진화까지 1일 단축! (총 3회 사용 가능)',
    icon: '⚡',
    maxUsage: 3, // 총 3회
    cooldown: Duration(days: 5), // 5일 쿨다운
  );

  /// 프리미엄 미리보기 리워드
  static const premiumPreview = RewardedAdReward(
    type: RewardedAdType.premiumPreview,
    title: '60일 프로그램 미리보기',
    description: '프리미엄 자각몽 기법을 체험해보세요 (WILD, FILD 등)',
    icon: '🔓',
    maxUsage: 1, // 기법당 1회
    cooldown: Duration(days: 1), // 1일 쿨다운
  );

  /// 스페셜 스킨 리워드
  static const specialSkin = RewardedAdReward(
    type: RewardedAdType.specialSkin,
    title: 'Lumi 스페셜 스킨',
    description: '한정판 Lumi 스킨을 언락하세요',
    icon: '🎨',
    maxUsage: 1, // 스킨당 1회
  );

  /// 모든 리워드 목록
  static const List<RewardedAdReward> all = [
    dreamAnalysis,
    wbtbSkip,
    evolutionBoost,
    premiumPreview,
    specialSkin,
  ];
}

/// 리워드 사용 기록
class RewardUsageRecord {
  final RewardedAdType type;
  final int usageCount;
  final DateTime? lastUsedAt;

  RewardUsageRecord({
    required this.type,
    required this.usageCount,
    this.lastUsedAt,
  });

  /// 사용 가능 여부 확인
  bool canUse(RewardedAdReward reward) {
    // 최대 사용 횟수 확인
    if (reward.maxUsage != -1 && usageCount >= reward.maxUsage) {
      return false;
    }

    // 쿨다운 확인
    if (reward.cooldown != null && lastUsedAt != null) {
      final cooldownEnd = lastUsedAt!.add(reward.cooldown!);
      if (DateTime.now().isBefore(cooldownEnd)) {
        return false;
      }
    }

    return true;
  }

  /// 다음 사용 가능 시간
  DateTime? getNextAvailableTime(RewardedAdReward reward) {
    if (reward.cooldown != null && lastUsedAt != null) {
      return lastUsedAt!.add(reward.cooldown!);
    }
    return null;
  }

  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'usageCount': usageCount,
      'lastUsedAt': lastUsedAt?.toIso8601String(),
    };
  }

  /// JSON에서 생성
  factory RewardUsageRecord.fromJson(Map<String, dynamic> json) {
    return RewardUsageRecord(
      type: RewardedAdType.values[json['type'] as int],
      usageCount: json['usageCount'] as int,
      lastUsedAt: json['lastUsedAt'] != null
          ? DateTime.parse(json['lastUsedAt'] as String)
          : null,
    );
  }
}
