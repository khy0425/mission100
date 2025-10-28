import 'package:flutter/material.dart';
import 'streak_stat.dart';

/// 스트릭 정보 카드
class StreakInfoCard extends StatelessWidget {
  final int currentStreak;
  final int totalWorkouts;
  final int thisMonthWorkouts;
  final String currentStreakLabel;
  final String totalWorkoutsLabel;
  final String thisMonthLabel;

  const StreakInfoCard({
    super.key,
    required this.currentStreak,
    required this.totalWorkouts,
    required this.thisMonthWorkouts,
    required this.currentStreakLabel,
    required this.totalWorkoutsLabel,
    required this.thisMonthLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreakStat(
              icon: Icons.local_fire_department,
              label: currentStreakLabel,
              value: '$currentStreak',
              color: Colors.orange,
            ),
            StreakStat(
              icon: Icons.fitness_center,
              label: totalWorkoutsLabel,
              value: '$totalWorkouts',
              color: const Color(0xFF00BCD4),
            ),
            StreakStat(
              icon: Icons.calendar_month,
              label: thisMonthLabel,
              value: '$thisMonthWorkouts',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
