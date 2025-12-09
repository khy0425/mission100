/// XP 및 레벨 계산 유틸리티
///
/// DreamFlow의 경험치 시스템:
/// - 체크리스트 완료 시 XP 획득 (AchievementService 통해)
/// - XP 누적 → Week 레벨 상승
/// - Week 레벨 → 캐릭터 진화 및 기능 해금

class XPCalculator {
  // 매일 체크리스트 완료 시 기본 XP (achievement 'daily_checklist_complete')
  static const int dailyChecklistXP = 100;

  // 주당 필요 XP (7일 * 100 XP = 700 XP)
  static const int xpPerWeek = 700;

  /// XP로부터 현재 주차 계산
  ///
  /// 예시:
  /// - 0 XP = Week 0
  /// - 700 XP = Week 1
  /// - 1400 XP = Week 2
  /// - 2100 XP = Week 3
  static int getWeekFromXP(int totalXP) {
    if (totalXP <= 0) return 0;
    return totalXP ~/ xpPerWeek;
  }

  /// 현재 주차에서의 진행률 (0.0 - 1.0)
  ///
  /// 예시: 750 XP → Week 1, 진행률 50/700 = 0.071
  static double getWeekProgress(int totalXP) {
    if (totalXP <= 0) return 0.0;
    final currentWeekXP = totalXP % xpPerWeek;
    return currentWeekXP / xpPerWeek;
  }

  /// 다음 주차까지 필요한 XP
  static int getXPToNextWeek(int totalXP) {
    if (totalXP <= 0) return xpPerWeek;
    final currentWeekXP = totalXP % xpPerWeek;
    return xpPerWeek - currentWeekXP;
  }

  /// 특정 주차에 도달하기 위한 총 XP
  static int getXPForWeek(int week) {
    if (week <= 0) return 0;
    return week * xpPerWeek;
  }

  /// 현재 주차에서 얻은 XP
  static int getCurrentWeekXP(int totalXP) {
    if (totalXP <= 0) return 0;
    return totalXP % xpPerWeek;
  }

  /// XP와 주차 정보를 포함한 레벨 정보 반환
  static LevelInfo getLevelInfo(int totalXP) {
    final week = getWeekFromXP(totalXP);
    final progress = getWeekProgress(totalXP);
    final xpToNext = getXPToNextWeek(totalXP);
    final currentWeekXP = getCurrentWeekXP(totalXP);

    return LevelInfo(
      totalXP: totalXP,
      week: week,
      weekProgress: progress,
      xpToNextWeek: xpToNext,
      currentWeekXP: currentWeekXP,
    );
  }
}

/// 레벨 정보를 담는 클래스
class LevelInfo {
  final int totalXP;
  final int week;
  final double weekProgress; // 0.0 - 1.0
  final int xpToNextWeek;
  final int currentWeekXP;

  const LevelInfo({
    required this.totalXP,
    required this.week,
    required this.weekProgress,
    required this.xpToNextWeek,
    required this.currentWeekXP,
  });

  @override
  String toString() {
    return 'LevelInfo(week: $week, XP: $totalXP, progress: ${(weekProgress * 100).toStringAsFixed(1)}%, toNext: $xpToNextWeek)';
  }
}
