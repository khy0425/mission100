/// Mission100 구독 등급
enum SubscriptionTier {
  /// 무료 사용자 (제한적)
  free,

  /// 1주 무료 체험 (신규 가입자)
  trial,

  /// 10월 가입자 특별 혜택 (프리미엄 기능, 광고 O)
  earlyAdopter,

  /// 유료 프리미엄 (프리미엄 기능, 광고 X)
  premium,
}

/// 구독 등급별 기능 접근 권한
class SubscriptionFeatures {
  final SubscriptionTier tier;

  SubscriptionFeatures(this.tier);

  /// 무제한 운동 기록 가능 여부
  bool get hasUnlimitedWorkouts {
    return tier != SubscriptionTier.free;
  }

  /// 고급 통계 분석 접근 가능 여부
  bool get hasAdvancedStats {
    return tier != SubscriptionTier.free;
  }

  /// 광고 제거 여부 (유료 프리미엄만)
  bool get hasAdFree {
    return tier == SubscriptionTier.premium;
  }

  /// 프리미엄 Chad 사용 가능 여부
  bool get hasPremiumChad {
    return tier != SubscriptionTier.free;
  }

  /// 독점 도전과제 접근 가능 여부
  bool get hasExclusiveChallenges {
    return tier == SubscriptionTier.premium ||
        tier == SubscriptionTier.earlyAdopter;
  }

  /// Tier 표시 이름
  String get tierName {
    switch (tier) {
      case SubscriptionTier.free:
        return '무료';
      case SubscriptionTier.trial:
        return '체험 중';
      case SubscriptionTier.earlyAdopter:
        return 'Early Adopter';
      case SubscriptionTier.premium:
        return '프리미엄';
    }
  }

  /// Tier 아이콘
  String get tierIcon {
    switch (tier) {
      case SubscriptionTier.free:
        return '🆓';
      case SubscriptionTier.trial:
        return '⏰';
      case SubscriptionTier.earlyAdopter:
        return '⭐';
      case SubscriptionTier.premium:
        return '💎';
    }
  }
}
