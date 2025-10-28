import 'package:flutter/material.dart';
import '../../models/achievement.dart';
import 'workout_stats.dart';
import 'program_progress.dart';
import 'completed_challenges.dart';
import 'new_achievements.dart';
import 'rest_day_message.dart';

/// 운동 완료 다이얼로그
class WorkoutCompleteDialog extends StatelessWidget {
  final int totalReps;
  final int xpGained;
  final int minutes;
  final int seconds;
  final int progressPercentage;
  final int completedWorkouts;
  final int totalDays;
  final List<dynamic> completedChallenges;
  final List<Achievement> newlyUnlockedAchievements;
  final bool isTomorrowRestDay;
  final VoidCallback? onViewAllAchievements;
  final VoidCallback onComplete;

  const WorkoutCompleteDialog({
    super.key,
    required this.totalReps,
    required this.xpGained,
    required this.minutes,
    required this.seconds,
    required this.progressPercentage,
    required this.completedWorkouts,
    required this.totalDays,
    required this.completedChallenges,
    required this.newlyUnlockedAchievements,
    required this.isTomorrowRestDay,
    this.onViewAllAchievements,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(
            Icons.local_fire_department,
            color: Colors.red,
            size: 28,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '💀 WORKOUT DESTROYED! 💀',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🔥 FXXK YEAH! 오늘의 운동 완전 파괴! 만삣삐! 💪',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // 운동 통계
            WorkoutStats(
              totalReps: totalReps,
              xpGained: xpGained,
              minutes: minutes,
              seconds: seconds,
            ),
            const SizedBox(height: 12),

            // 프로그램 진행률
            ProgramProgress(
              progressPercentage: progressPercentage,
              completedWorkouts: completedWorkouts,
              totalDays: totalDays,
            ),
            const SizedBox(height: 12),

            // 완료된 챌린지
            CompletedChallenges(completedChallenges: completedChallenges),
            if (completedChallenges.isNotEmpty) const SizedBox(height: 12),

            // 새로운 업적
            NewAchievements(
              newlyUnlockedAchievements: newlyUnlockedAchievements,
              onViewAll: onViewAllAchievements,
            ),
            if (newlyUnlockedAchievements.isNotEmpty) const SizedBox(height: 12),

            // 내일 휴식일/운동일 메시지
            RestDayMessage(isTomorrowRestDay: isTomorrowRestDay),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onComplete,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '🔥 FXXK YEAH! 🔥',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
