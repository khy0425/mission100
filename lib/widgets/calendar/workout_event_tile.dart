import 'package:flutter/material.dart';
import '../../models/workout_history.dart';

/// 운동 이벤트 타일
class WorkoutEventTile extends StatelessWidget {
  final WorkoutHistory workout;

  const WorkoutEventTile({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            width: 4,
            color: workout.completionRate >= 1.0
                ? Colors.green
                : workout.completionRate >= 0.8
                    ? const Color(0xFF00BCD4)
                    : workout.completionRate >= 0.5
                        ? Colors.orange
                        : Colors.red,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.workoutTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${workout.totalReps}개 (${(workout.completionRate * 100).toInt()}%)',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            workout.completionRate >= 1.0
                ? Icons.check_circle
                : workout.completionRate >= 0.8
                    ? Icons.check_circle_outline
                    : Icons.radio_button_unchecked,
            color: workout.completionRate >= 1.0
                ? Colors.green
                : workout.completionRate >= 0.8
                    ? const Color(0xFF00BCD4)
                    : Colors.grey,
          ),
        ],
      ),
    );
  }
}
