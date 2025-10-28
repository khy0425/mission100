import 'package:flutter/material.dart';
import '../../models/workout_session.dart';
import 'workout_session_card.dart';

/// 선택된 날짜의 워크아웃 카드
class SelectedDayWorkoutsCard extends StatelessWidget {
  final DateTime selectedDay;
  final List<WorkoutSession> workouts;

  const SelectedDayWorkoutsCard({
    super.key,
    required this.selectedDay,
    required this.workouts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      child: Card(
        color: isDark ? const Color(0xFF1A1A1A) : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF4DABF7),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${selectedDay.month}월 ${selectedDay.day}일 워크아웃',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4DABF7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (workouts.isEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '이 날에는 워크아웃이 없습니다.',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                ...workouts.map(
                  (workout) => WorkoutSessionCard(session: workout),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
