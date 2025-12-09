import '../../models/user_subscription.dart';

/// 레벨 기반 컨텐츠 접근 제어 서비스
///
/// 사용자의 레벨과 구독 상태에 따라 컨텐츠 접근 가능 여부를 판단
class ContentAccessService {
  /// Day별 필요 레벨
  /// - Day 1-7: Lv.1 (무료)
  /// - Day 8-14: Lv.2
  /// - Day 15-21: Lv.3
  /// - Day 22-30: Lv.4+
  static int getRequiredLevelForDay(int day) {
    if (day <= 7) return 1;
    if (day <= 14) return 2;
    if (day <= 21) return 3;
    return 4; // Day 22-30
  }

  /// Week별 필요 레벨 (Day / 7 올림)
  static int getRequiredLevelForWeek(int week) {
    return week.clamp(1, 4);
  }

  /// Day 접근 가능 여부
  ///
  /// [day] - 확인할 일차 (1-30)
  /// [userLevel] - 사용자 현재 레벨
  /// [isPremium] - 프리미엄 구독 여부
  /// Returns: true if accessible
  static bool canAccessDay(int day, int userLevel, bool isPremium) {
    // 프리미엄 사용자는 레벨만 충족하면 모든 Day 접근 가능
    if (isPremium) {
      final requiredLevel = getRequiredLevelForDay(day);
      return userLevel >= requiredLevel;
    }

    // 무료 사용자는 Week 1 (Day 1-7)만 접근 가능
    return day <= 7 && userLevel >= 1;
  }

  /// Week 접근 가능 여부
  static bool canAccessWeek(int week, int userLevel, bool isPremium) {
    if (week < 1 || week > 4) return false;

    // 무료 사용자는 Week 1만
    if (!isPremium) {
      return week == 1 && userLevel >= 1;
    }

    // 프리미엄: 레벨만 충족하면 접근 가능
    final requiredLevel = getRequiredLevelForWeek(week);
    return userLevel >= requiredLevel;
  }

  /// AI 어시스턴트 접근 가능 여부
  ///
  /// Lv.2+ 또는 프리미엄 필요
  static bool canAccessAIAssistant(int userLevel, bool isPremium) {
    return isPremium || userLevel >= 2;
  }

  /// WBTB 기법 접근 가능 여부
  ///
  /// Lv.3+ 또는 프리미엄 필요
  static bool canAccessWBTB(int userLevel, bool isPremium) {
    return isPremium || userLevel >= 3;
  }

  /// 고급 명상 기법 접근 가능 여부
  ///
  /// Lv.3+ 또는 프리미엄 필요
  static bool canAccessAdvancedMeditation(int userLevel, bool isPremium) {
    return isPremium || userLevel >= 3;
  }

  /// 꿈 일기 AI 분석 접근 가능 여부
  ///
  /// Lv.2+ 또는 프리미엄 필요
  static bool canAccessDreamAnalysis(int userLevel, bool isPremium) {
    return isPremium || userLevel >= 2;
  }

  /// 레벨업 필요 메시지
  ///
  /// [requiredLevel] - 필요한 레벨
  /// [userLevel] - 사용자 현재 레벨
  /// [isPremium] - 프리미엄 구독 여부
  /// Returns: 레벨업 필요 메시지 또는 null (접근 가능 시)
  static String? getLevelUpMessage(
    int requiredLevel,
    int userLevel,
    bool isPremium,
  ) {
    if (isPremium) {
      if (userLevel >= requiredLevel) return null;
      return '레벨 $requiredLevel 달성이 필요합니다 (현재: Lv.$userLevel)';
    }

    // 무료 사용자
    if (requiredLevel > 1) {
      return '프리미엄 구독 또는 레벨 $requiredLevel 달성이 필요합니다';
    }

    if (userLevel < requiredLevel) {
      return '레벨 $requiredLevel 달성이 필요합니다 (현재: Lv.$userLevel)';
    }

    return null;
  }

  /// 컨텐츠 잠금 상태
  static ContentLockStatus getContentLockStatus(
    int requiredLevel,
    int userLevel,
    bool isPremium,
  ) {
    if (isPremium) {
      if (userLevel >= requiredLevel) {
        return ContentLockStatus.unlocked;
      }
      return ContentLockStatus.lockedByLevel;
    }

    // 무료 사용자
    if (requiredLevel > 1) {
      return ContentLockStatus.lockedByPremium;
    }

    if (userLevel < requiredLevel) {
      return ContentLockStatus.lockedByLevel;
    }

    return ContentLockStatus.unlocked;
  }
}

/// 컨텐츠 잠금 상태
enum ContentLockStatus {
  /// 해금됨
  unlocked,

  /// 레벨 부족으로 잠김
  lockedByLevel,

  /// 프리미엄 필요
  lockedByPremium,
}
