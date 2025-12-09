import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// 프로그램 진행률 위젯
class ProgramProgress extends StatelessWidget {
  final int progressPercentage;
  final int completedWorkouts;
  final int totalDays;

  const ProgramProgress({
    super.key,
    required this.progressPercentage,
    required this.completedWorkouts,
    required this.totalDays,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        children: [
          Text(
            l10n.chadEvolutionProgress,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressPercentage / 100,
            backgroundColor: Colors.grey,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Colors.green,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$progressPercentage% ($completedWorkouts/$totalDays ${l10n.days})',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
