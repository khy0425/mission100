import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// 운동 통계 위젯
class WorkoutStats extends StatelessWidget {
  final int totalReps;
  final int xpGained;
  final int minutes;
  final int seconds;

  const WorkoutStats({
    super.key,
    required this.totalReps,
    required this.xpGained,
    required this.minutes,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                l10n.repsDestroyed,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$totalReps',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                l10n.xpGained,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '+$xpGained XP',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                l10n.timeDestroyed,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$minutes${l10n.minutes} $seconds${l10n.seconds}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
