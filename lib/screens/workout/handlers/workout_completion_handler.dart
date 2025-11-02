import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../services/workout/workout_history_service.dart';
import '../../../services/achievements/achievement_service.dart';
import '../../../services/chad/chad_evolution_service.dart';
import '../../../services/notification/notification_service.dart';
import '../../../services/progress/challenge_service.dart';
import '../../../services/workout/pushup_mastery_service.dart';
import '../../../services/data/cloud_sync_service.dart';
import '../../../models/workout_history.dart';
import '../../../models/achievement.dart';
import '../../../models/challenge.dart';
import '../../../models/workout_reminder_settings.dart';
import '../../../data/chad_reward_dialogues.dart';

class WorkoutCompletionHandler {
  final BuildContext context;
  final dynamic workout;
  final List<int> completedReps;
  final List<int> targetReps;
  final DateTime? workoutStartTime;

  WorkoutCompletionHandler({
    required this.context,
    required this.workout,
    required this.completedReps,
    required this.targetReps,
    required this.workoutStartTime,
  });

  /// 운동 완료 처리 메인 함수
  Future<WorkoutCompletionResult> completeWorkout() async {
    debugPrint('🔥 WorkoutCompletionHandler - 운동 완료 처리 시작');

    final result = WorkoutCompletionResult();

    try {
      // 1. 운동 기록 저장
      final history = await _saveWorkoutHistory();
      result.workoutHistory = history;

      // 2. 프로그램 진행률 업데이트
      await _updateProgramProgress();

      // 3. 차드 경험치 업데이트
      final xpGained = await _updateChadExperience();
      result.xpGained = xpGained;

      // 4. 스트릭 업데이트
      await _updateStreak();

      // 5. 챌린지 진행률 업데이트
      await _updateChallenges(history, result);

      // 6. Chad 보상 대화 생성
      final rewardDialogue = await _generateRewardDialogue(history);
      result.rewardDialogue = rewardDialogue;

      // 7. 업적 확인
      final achievements = await _checkAchievements(history);
      result.newAchievements = achievements;

      // 8. 세션 정리
      await _cleanupSession();

      // 9. 내일 휴식일인지 확인하고 알림
      await _checkRestDayNotification();

      result.success = true;
      debugPrint('✅ 만삣삐! 운동 완료 처리 성공! LEGENDARY CHAD MODE! 🔥');
    } catch (e) {
      debugPrint('❌ 운동 완료 처리 실패: $e');
      result.success = false;
      result.error = e.toString();
    }

    return result;
  }

  /// 운동 기록 저장
  Future<WorkoutHistory> _saveWorkoutHistory() async {
    debugPrint('💾 운동 기록 저장 시작');

    final totalCompletedReps = completedReps.fold(0, (sum, reps) => sum + reps);
    final totalTargetReps = targetReps.fold(0, (sum, reps) => sum + reps);

    final history = WorkoutHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      workoutTitle: (workout.title as String?) ??
          '${workout.week ?? 1}주차 - ${workout.day ?? 1}일차',
      targetReps: targetReps,
      completedReps: completedReps,
      totalReps: totalCompletedReps,
      completionRate:
          totalTargetReps > 0 ? totalCompletedReps / totalTargetReps : 0.0,
      level: 'Rising',
      duration: workoutStartTime != null
          ? DateTime.now().difference(workoutStartTime!)
          : const Duration(minutes: 10),
    );

    try {
      await WorkoutHistoryService.saveWorkoutHistory(history);
      debugPrint('✅ 운동 기록 저장 완료');

      // 클라우드 동기화 (비동기로 실행하여 UX 차단 방지)
      _syncWorkoutToCloud(history);

      // 운동 완료 XP 지급 (주차별 차등 지급)
      final week = workout.week ?? 1;
      final day = workout.day ?? 1;
      await ChadEvolutionService.addWorkoutCompletionXP(week, day);
    } catch (e) {
      debugPrint('❌ 운동 기록 저장 실패, 대체 방법 시도: $e');
      await _saveWorkoutHistoryFallback(history);
    }

    return history;
  }

  /// 운동 기록 저장 대체 방법
  Future<void> _saveWorkoutHistoryFallback(WorkoutHistory history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = jsonEncode({
        'id': history.id,
        'date': history.date.toIso8601String(),
        'workoutTitle': history.workoutTitle,
        'totalReps': history.totalReps,
        'completionRate': history.completionRate,
      });
      final historyList = prefs.getStringList('workout_history') ?? [];
      historyList.add(historyJson);
      await prefs.setStringList('workout_history', historyList);
      debugPrint('✅ 운동 기록 저장 완료 (대체 버전)');
    } catch (e) {
      debugPrint('❌ 대체 저장도 실패: $e');
      rethrow;
    }
  }

  /// 프로그램 진행률 업데이트
  Future<void> _updateProgramProgress() async {
    try {
      debugPrint('📈 프로그램 진행률 업데이트 시작');

      // SharedPreferences로 진행률 업데이트 (간단한 방법)
      final prefs = await SharedPreferences.getInstance();
      final currentWeek = workout.week ?? 1;
      final currentDay = workout.day ?? 1;

      // 완료된 운동 기록 (프로그램 진행률용)
      final completedWorkouts = prefs.getStringList('completed_workouts') ?? [];
      final workoutKey = 'week_${currentWeek}_day_$currentDay';

      if (!completedWorkouts.contains(workoutKey)) {
        completedWorkouts.add(workoutKey);
        await prefs.setStringList('completed_workouts', completedWorkouts);

        // 진행률 계산 (총 14주 * 3일 = 42일 기준, 주 3회 운동)
        const totalDays = 42;
        final progressPercentage =
            (completedWorkouts.length / totalDays * 100).round();
        await prefs.setInt('program_progress', progressPercentage);

        debugPrint(
          '✅ 프로그램 진행률 업데이트: ${completedWorkouts.length}/$totalDays ($progressPercentage%)',
        );
      }

      // 날짜별 운동 완료 기록 (연속 운동 차단용)
      final today = DateTime.now();
      final todayKey = 'workout_${today.year}_${today.month}_${today.day}';
      final dailyCompletedWorkouts =
          prefs.getStringList('daily_completed_workouts') ?? [];

      if (!dailyCompletedWorkouts.contains(todayKey)) {
        dailyCompletedWorkouts.add(todayKey);
        await prefs.setStringList(
          'daily_completed_workouts',
          dailyCompletedWorkouts,
        );
        debugPrint('✅ 날짜별 운동 완료 기록: $todayKey');
      }
    } catch (e) {
      debugPrint('❌ 프로그램 진행률 업데이트 실패: $e');
    }
  }

  /// 차드 경험치 업데이트 (성과 기반 보상)
  Future<int> _updateChadExperience() async {
    try {
      debugPrint('💪 차드 경험치 업데이트 시작');

      final totalReps = completedReps.fold(0, (sum, reps) => sum + reps);
      final totalTargetReps = targetReps.fold(0, (sum, reps) => sum + reps);
      final completionRate =
          totalTargetReps > 0 ? (totalReps / totalTargetReps) : 0.0;

      // === 기본 XP 계산 ===
      int totalXP = 0;

      // 1. 기본 운동 완료 XP
      const baseXP = 50;
      totalXP += baseXP;

      // 2. 횟수 보너스 XP (rep당 0.5 XP)
      final repBonus = (totalReps * 0.5).round();
      totalXP += repBonus;

      // === 성과 보너스 XP ===
      // 3. 완료율 보너스
      int completionBonus = 0;
      if (completionRate >= 1.0) {
        completionBonus = 30; // 100% 완료 보너스
      } else if (completionRate >= 0.8) {
        completionBonus = 20; // 80% 이상 완료 보너스
      } else if (completionRate >= 0.6) {
        completionBonus = 10; // 60% 이상 완료 보너스
      }
      totalXP += completionBonus;

      // 4. 초과 달성 보너스 (목표치 초과시)
      int overachievementBonus = 0;
      if (completionRate > 1.0) {
        final extraReps = totalReps - totalTargetReps;
        overachievementBonus = (extraReps * 1.0).round(); // 초과분은 rep당 1.0 XP
        totalXP += overachievementBonus;
      }

      // 5. 운동 시간 보너스 (장시간 운동시)
      int timeBonus = 0;
      if (workoutStartTime != null) {
        final workoutDuration =
            DateTime.now().difference(workoutStartTime!).inMinutes;
        if (workoutDuration >= 30) {
          timeBonus = 20; // 30분 이상 운동 보너스
        } else if (workoutDuration >= 20) {
          timeBonus = 10; // 20분 이상 운동 보너스
        }
        totalXP += timeBonus;
      }

      // ChadEvolutionService의 static 메서드 호출
      await ChadEvolutionService.addExperience(totalXP);

      debugPrint('✅ 차드 경험치 업데이트 완료: +${totalXP}XP');
      debugPrint(
        '   📊 XP 상세: 기본($baseXP) + 횟수($repBonus) + 완료율($completionBonus) + 초과달성($overachievementBonus) + 시간($timeBonus)',
      );
      debugPrint(
        '   🎯 완료율: ${(completionRate * 100).toStringAsFixed(1)}% ($totalReps/$totalTargetReps)',
      );

      return totalXP;
    } catch (e) {
      debugPrint('❌ 차드 경험치 업데이트 실패: $e');
      return 0;
    }
  }

  /// 스트릭 업데이트
  Future<void> _updateStreak() async {
    try {
      debugPrint('🔥 스트릭 업데이트 시작');

      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now();
      final lastWorkoutDate = prefs.getString('last_workout_date');

      if (lastWorkoutDate != null) {
        final lastDate = DateTime.parse(lastWorkoutDate);
        final daysDifference = today.difference(lastDate).inDays;

        if (daysDifference == 1) {
          // 연속 운동
          final currentStreak = prefs.getInt('workout_streak') ?? 0;
          await prefs.setInt('workout_streak', currentStreak + 1);
        } else if (daysDifference > 1) {
          // 스트릭 끊김
          await prefs.setInt('workout_streak', 1);
        }
      } else {
        // 첫 운동
        await prefs.setInt('workout_streak', 1);
      }

      await prefs.setString('last_workout_date', today.toIso8601String());
      debugPrint('✅ 스트릭 업데이트 완료');
    } catch (e) {
      debugPrint('❌ 스트릭 업데이트 실패: $e');
    }
  }

  /// Chad 보상 대화 생성
  Future<RewardDialogue> _generateRewardDialogue(WorkoutHistory history) async {
    try {
      debugPrint('💬 Chad 보상 대화 생성 시작');

      // 현재 Chad 레벨 가져오기
      final chadEvolutionService = ChadEvolutionService();
      final currentLevel = chadEvolutionService.evolutionState.currentStage.index;

      // 완료율 계산
      final completionRate = history.completionRate;

      // 보상 대화 가져오기
      final dialogue = ChadRewardDialogues.getWorkoutReward(
        chadLevel: currentLevel,
        completionRate: completionRate,
      );

      debugPrint('✅ Chad 보상 대화 생성 완료');
      debugPrint('   🎯 레벨: $currentLevel, 완료율: ${(completionRate * 100).toStringAsFixed(1)}%');
      debugPrint('   💬 "${dialogue.title}" - ${dialogue.message}');

      return dialogue;
    } catch (e) {
      debugPrint('❌ Chad 보상 대화 생성 실패: $e');
      // 기본 대화 반환
      return const RewardDialogue(
        level: 1,
        tier: PerformanceTier.normal,
        title: '운동 완료!',
        message: 'Chad는 완성형이다. 남은 것은 뇌절뿐.',
      );
    }
  }

  /// 업적 확인
  Future<List<Achievement>> _checkAchievements(WorkoutHistory history) async {
    try {
      debugPrint('🎯 업적 확인 시작');

      // AchievementService가 업적 확인 및 pending_achievement_events 저장을 모두 처리함
      // (unlockAchievement() -> _saveAchievementEvent() 호출)
      final achievements =
          await AchievementService.checkAndUpdateAchievements();

      debugPrint('✅ 업적 확인 완료: ${achievements.length}개 새로 달성');
      return achievements;
    } catch (e) {
      debugPrint('❌ 업적 확인 실패: $e');
      return [];
    }
  }

  /// 세션 정리
  Future<void> _cleanupSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_workout_session');
      debugPrint('✅ FXXK YEAH! 세션 정리 완료! 💪');
    } catch (e) {
      debugPrint('❌ 세션 정리 실패: $e');
    }
  }

  /// 챌린지 진행률 업데이트
  Future<void> _updateChallenges(
    WorkoutHistory history,
    WorkoutCompletionResult result,
  ) async {
    try {
      debugPrint('🏆 챌린지 진행률 업데이트 시작');

      final challengeService = ChallengeService();
      await challengeService.initialize();

      // 완료된 총 횟수로 챌린지 업데이트
      final totalReps = history.totalReps;
      final updatedChallenges = await challengeService
          .updateChallengesOnWorkoutComplete(totalReps, 1);

      if (updatedChallenges.isNotEmpty) {
        debugPrint('✅ 챌린지 업데이트 완료: ${updatedChallenges.length}개 챌린지 진행률 변경');

        // 완료된 챌린지가 있는지 확인
        final completedChallenges = <Challenge>[];
        for (final challenge in updatedChallenges) {
          final targetValue = challenge.targetValue ?? challenge.targetCount;
          if (challenge.currentProgress >= targetValue) {
            completedChallenges.add(challenge);
            debugPrint('🎉 챌린지 완료: ${challenge.title}');
          }
        }

        // 완료된 챌린지 알림 저장 (운동 완료 다이얼로그에서 표시하기 위해)
        if (completedChallenges.isNotEmpty) {
          result.completedChallenges = completedChallenges;
        }
      } else {
        debugPrint('ℹ️ 업데이트된 챌린지 없음');
      }

      // 푸시업 마스터 진행률 업데이트
      await _updatePushupMastery(history);
    } catch (e) {
      debugPrint('❌ 챌린지 업데이트 실패: $e');
    }
  }

  /// 푸시업 마스터 진행률 업데이트
  Future<void> _updatePushupMastery(WorkoutHistory history) async {
    try {
      debugPrint('💪 푸시업 마스터 진행률 업데이트 시작');

      // 푸시업 운동인지 확인 (제목에 "pushup" 또는 "푸시업" 포함)
      final workoutTitle = history.workoutTitle.toLowerCase();
      if (workoutTitle.contains('pushup') || workoutTitle.contains('푸시업')) {
        await PushupMasteryService.updateTotalPushupReps(history.totalReps);
        debugPrint('✅ 푸시업 마스터 진행률 업데이트 완료: +${history.totalReps}회');
      } else {
        debugPrint('ℹ️ 푸시업 운동이 아니므로 마스터 진행률 업데이트 안함');
      }
    } catch (e) {
      debugPrint('❌ 푸시업 마스터 업데이트 실패: $e');
    }
  }

  /// 내일 휴식일인지 확인하고 알림
  Future<void> _checkRestDayNotification() async {
    try {
      debugPrint('🔍 내일 휴식일 확인 중...');

      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('workout_reminder_settings');

      if (settingsJson != null) {
        final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
        final settings = WorkoutReminderSettings.fromJson(settingsMap);

        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final isTomorrowRestDay = !settings.activeDays.contains(
          tomorrow.weekday,
        );

        if (isTomorrowRestDay) {
          // 휴식일 알림 표시
          await NotificationService.showRestDayNotification();
          debugPrint('😴 내일은 휴식일! CHAD도 쉬어야 강해진다! 💪');
        } else {
          debugPrint('🔥 TOMORROW: WORKOUT DAY! BEAST MODE CONTINUES! 💀');
        }
      } else {
        // 기본 설정: 월-금 운동, 주말 휴식
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final isWeekend =
            tomorrow.weekday == 6 || tomorrow.weekday == 7; // 토요일 또는 일요일

        if (isWeekend) {
          await NotificationService.showRestDayNotification();
          debugPrint('🌴 주말은 휴식! CHAD의 회복 타임! 💪');
        }
      }
    } catch (e) {
      debugPrint('❌ 휴식일 확인 실패: $e');
    }
  }

  /// 운동 기록을 클라우드에 동기화 (비동기)
  void _syncWorkoutToCloud(WorkoutHistory history) {
    // 백그라운드에서 비동기 실행 (UX 차단 방지)
    Future.microtask(() async {
      try {
        debugPrint('☁️ 운동 기록 클라우드 동기화 시작');

        final cloudSyncService = CloudSyncService();
        await cloudSyncService.syncWorkoutRecord(history);

        debugPrint('✅ 운동 기록 클라우드 동기화 완료');
      } catch (e) {
        debugPrint('❌ 운동 기록 클라우드 동기화 실패: $e');
        // 동기화 실패 시 로컬에 대기 큐에 추가
        try {
          final cloudSyncService = CloudSyncService();
          cloudSyncService.queueChange('workout_record', {
            'action': 'create',
            'data': history.toJson(),
          });
          debugPrint('📝 운동 기록을 동기화 대기 큐에 추가');
        } catch (queueError) {
          debugPrint('❌ 동기화 큐 추가 실패: $queueError');
        }
      }
    });
  }
}

/// 운동 완료 결과 클래스
class WorkoutCompletionResult {
  bool success = false;
  String? error;
  WorkoutHistory? workoutHistory;
  List<Achievement> newAchievements = [];
  List<Challenge> completedChallenges = [];
  int xpGained = 0;
  RewardDialogue? rewardDialogue; // Chad 보상 대화

  bool get hasNewAchievements => newAchievements.isNotEmpty;
  bool get hasCompletedChallenges => completedChallenges.isNotEmpty;
  bool get hasRewardDialogue => rewardDialogue != null;
}
