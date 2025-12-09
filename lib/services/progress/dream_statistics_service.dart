import 'package:flutter/foundation.dart';
import '../../models/lucid_dream_task.dart';
import '../workout/checklist_history_service.dart';

/// 자각몽 훈련 통계 및 진행 상황을 추적하는 서비스
///
/// Phase 1 기능:
/// - 총 훈련 일수 추적
/// - 현재 연속 기록 (streak) 계산
/// - 주간/월간 진행 상황
/// - 태스크 완료율
class DreamStatisticsService {
  /// 기본 통계 정보 가져오기
  static Future<DreamStatistics> getStatistics() async {
    try {
      final checklists = await ChecklistHistoryService.getAllChecklists();
      final streak = await ChecklistHistoryService.getCurrentStreak();
      final last7Days = await ChecklistHistoryService.getChecklistDaysInPeriod(7);
      final last30Days = await ChecklistHistoryService.getChecklistDaysInPeriod(30);
      final programProgress = await ChecklistHistoryService.getProgramProgress();

      // 꿈 일기 작성 횟수 (dreamJournal 태스크 완료 횟수)
      int dreamJournalCount = 0;
      // 현실 확인 총 횟수
      int realityCheckCount = 0;
      // 평균 완료율
      double avgCompletionRate = 0.0;

      if (checklists.isNotEmpty) {
        for (var checklist in checklists) {
          if (checklist.completedTasks.contains(LucidDreamTaskType.dreamJournal.name)) {
            dreamJournalCount++;
          }
          if (checklist.completedTasks.contains(LucidDreamTaskType.realityCheck.name)) {
            realityCheckCount++;
          }
        }

        avgCompletionRate = checklists
            .map((c) => c.completionRate)
            .reduce((a, b) => a + b) / checklists.length;
      }

      return DreamStatistics(
        totalTrainingDays: checklists.length,
        currentStreak: streak,
        dreamJournalCount: dreamJournalCount,
        realityCheckCount: realityCheckCount,
        averageCompletionRate: avgCompletionRate,
        last7DaysCount: last7Days,
        last30DaysCount: last30Days,
        programProgress: programProgress,
        programTotal: 30,
      );
    } catch (e) {
      debugPrint('❌ Error getting dream statistics: $e');
      return DreamStatistics.empty();
    }
  }

  /// 주간 진행 상황 가져오기 (지난 7일)
  static Future<List<DailyProgress>> getWeeklyProgress() async {
    try {
      final now = DateTime.now();
      final weeklyData = <DailyProgress>[];

      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateNormalized = DateTime(date.year, date.month, date.day);

        final checklist = await ChecklistHistoryService.getChecklistByDate(dateNormalized);

        weeklyData.add(DailyProgress(
          date: dateNormalized,
          completed: checklist != null,
          completionRate: checklist?.completionRate ?? 0.0,
          taskCount: checklist?.totalTasksCompleted ?? 0,
        ));
      }

      return weeklyData;
    } catch (e) {
      debugPrint('❌ Error getting weekly progress: $e');
      return [];
    }
  }

  /// 월간 진행 상황 가져오기
  static Future<List<DailyProgress>> getMonthlyProgress(DateTime month) async {
    try {
      final checklists = await ChecklistHistoryService.getChecklistsByMonth(month);
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      final monthlyData = <DailyProgress>[];

      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(month.year, month.month, day);
        final checklist = checklists.where((c) =>
          c.date.year == date.year &&
          c.date.month == date.month &&
          c.date.day == date.day
        ).firstOrNull;

        monthlyData.add(DailyProgress(
          date: date,
          completed: checklist != null,
          completionRate: checklist?.completionRate ?? 0.0,
          taskCount: checklist?.totalTasksCompleted ?? 0,
        ));
      }

      return monthlyData;
    } catch (e) {
      debugPrint('❌ Error getting monthly progress: $e');
      return [];
    }
  }

  /// 연속 보너스 XP 계산
  ///
  /// 연속으로 체크리스트를 완료한 일수에 따라 보너스 XP 제공
  /// - 3일 연속: +50 XP
  /// - 7일 연속: +100 XP
  /// - 14일 연속: +200 XP
  /// - 30일 연속: +500 XP (레전드!)
  static int getStreakBonusXP(int streak) {
    if (streak >= 30) return 500; // 30일 연속 (레전드!)
    if (streak >= 14) return 200; // 14일 연속 (2주)
    if (streak >= 7) return 100;  // 7일 연속 (1주)
    if (streak >= 3) return 50;   // 3일 연속
    return 0; // 보너스 없음
  }

  /// 레벨 계산 (경험치 기반 시스템 + 연속 보너스)
  ///
  /// 체크리스트 완료 → 경험치 획득 → 레벨업
  ///
  /// 경험치 계산:
  /// - 체크리스트 100% 완료: 100 XP
  /// - 체크리스트 50% 완료: 50 XP
  /// - 레벨업 기준: 700 XP (= 7일 × 100% 완료)
  ///
  /// 연속 보너스 (Streak Bonus):
  /// - 3일 연속: +50 XP
  /// - 7일 연속: +100 XP
  /// - 14일 연속: +200 XP
  /// - 30일 연속: +500 XP (레전드!)
  ///
  /// 레벨 제한 (구독 기반 - Model B):
  /// - 무료 사용자: Level 1까지만 (Week 1만 영구 무료)
  /// - 프리미엄 사용자: Level 9까지 (Week 1-9 전체)
  ///
  /// 예시:
  /// - 7일 100% 완료 + 7일 연속 = 700 + 100 = 800 XP → Level 2 (프리미엄 필요!)
  /// - 14일 100% 완료 + 14일 연속 = 1400 + 200 = 1600 XP → Level 3 (프리미엄!)
  /// - 5일 100% 완료 = 500 XP → Level 1 (무료로 플레이 가능)
  static int calculateLevel(DreamStatistics stats, {int maxAllowedLevel = 9}) {
    // 기본 경험치 = (체크리스트 완료한 날 수 × 평균 완료율 × 100)
    final baseXP = stats.totalTrainingDays * stats.averageCompletionRate * 100;

    // 연속 보너스 XP
    final streakBonus = getStreakBonusXP(stats.currentStreak);

    // 총 경험치 = 기본 XP + 연속 보너스
    final totalXP = baseXP + streakBonus;

    debugPrint('📊 XP Calculation: Base=$baseXP, Streak(${stats.currentStreak})=$streakBonus, Total=$totalXP');

    // 레벨업 기준: 700 XP = 1주 (7일 × 100% 완료)
    const xpPerLevel = 700;

    // XP 기반 레벨 계산
    final calculatedLevel = (totalXP / xpPerLevel).floor() + 1;

    // 구독 상태에 따른 레벨 제한 적용
    final level = calculatedLevel.clamp(1, maxAllowedLevel);

    debugPrint('🎯 Level: $calculatedLevel → Capped: $level (Max: $maxAllowedLevel, XP: $totalXP)');

    return level;
  }

  /// 다음 레벨까지 필요한 경험치
  ///
  /// 체크리스트를 몇 번 더 완료해야 레벨업 하는지 계산 (연속 보너스 포함)
  ///
  /// maxAllowedLevel에 도달한 경우 -1 반환 (프리미엄 필요)
  static int daysToNextLevel(DreamStatistics stats, {int maxAllowedLevel = 9}) {
    final currentLevel = calculateLevel(stats, maxAllowedLevel: maxAllowedLevel);

    // 이미 허용된 최대 레벨에 도달했으면 (프리미엄 필요)
    if (currentLevel >= maxAllowedLevel) return -1;

    // 절대 최대 레벨 (Level 9)에 도달했으면
    if (currentLevel >= 9) return 0;

    // 현재 총 XP (연속 보너스 포함)
    final baseXP = stats.totalTrainingDays * stats.averageCompletionRate * 100;
    final streakBonus = getStreakBonusXP(stats.currentStreak);
    final totalXP = baseXP + streakBonus;

    // 다음 레벨에 필요한 총 XP
    const xpPerLevel = 700;
    final nextLevelXP = currentLevel * xpPerLevel;

    // 남은 XP
    final remainingXP = nextLevelXP - totalXP;

    if (remainingXP <= 0) return 0;

    // 평균 완료율로 계산: 하루에 얻는 평균 XP
    final dailyAverageXP = stats.averageCompletionRate * 100;

    if (dailyAverageXP > 0) {
      return (remainingXP / dailyAverageXP).ceil();
    }

    return 999; // 완료율이 0이면 계산 불가
  }
}

/// 자각몽 훈련 통계 데이터 모델
class DreamStatistics {
  final int totalTrainingDays; // 총 훈련 일수
  final int currentStreak; // 현재 연속 기록 (일)
  final int dreamJournalCount; // 꿈 일기 작성 횟수
  final int realityCheckCount; // 현실 확인 횟수
  final double averageCompletionRate; // 평균 완료율 (0.0 - 1.0)
  final int last7DaysCount; // 최근 7일 훈련 일수
  final int last30DaysCount; // 최근 30일 훈련 일수
  final int programProgress; // 30일 프로그램 진행 (1-30)
  final int programTotal; // 30일 프로그램 총 일수

  const DreamStatistics({
    required this.totalTrainingDays,
    required this.currentStreak,
    required this.dreamJournalCount,
    required this.realityCheckCount,
    required this.averageCompletionRate,
    required this.last7DaysCount,
    required this.last30DaysCount,
    required this.programProgress,
    required this.programTotal,
  });

  /// 빈 통계 (초기 상태)
  factory DreamStatistics.empty() {
    return const DreamStatistics(
      totalTrainingDays: 0,
      currentStreak: 0,
      dreamJournalCount: 0,
      realityCheckCount: 0,
      averageCompletionRate: 0.0,
      last7DaysCount: 0,
      last30DaysCount: 0,
      programProgress: 0,
      programTotal: 30,
    );
  }

  /// 프로그램 완료율 (0.0 - 1.0)
  double get programCompletionRate {
    if (programTotal == 0) return 0.0;
    return programProgress / programTotal;
  }

  /// 프로그램 완료 여부
  bool get isProgramComplete => programProgress >= programTotal;

  /// 완료율 퍼센트 (0-100)
  int get completionPercent => (averageCompletionRate * 100).round();

  /// 최근 활동 여부 (지난 7일 중 3일 이상 훈련)
  bool get isActiveRecently => last7DaysCount >= 3;

  /// 성과 레벨 (초보자/숙련자/마스터)
  String get performanceLevel {
    if (totalTrainingDays >= 30 && averageCompletionRate >= 0.8) {
      return 'master'; // 마스터
    } else if (totalTrainingDays >= 14 && averageCompletionRate >= 0.6) {
      return 'skilled'; // 숙련자
    } else {
      return 'novice'; // 초보자
    }
  }
}

/// 일일 진행 상황 데이터
class DailyProgress {
  final DateTime date;
  final bool completed; // 해당 날짜에 체크리스트 완료 여부
  final double completionRate; // 완료율
  final int taskCount; // 완료한 태스크 수

  const DailyProgress({
    required this.date,
    required this.completed,
    required this.completionRate,
    required this.taskCount,
  });

  /// 날짜 표시용 문자열 (MM/DD)
  String get dateLabel => '${date.month}/${date.day}';

  /// 요일 표시용 문자열
  String get weekdayLabel {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[date.weekday - 1];
  }
}
