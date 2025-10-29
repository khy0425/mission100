import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';
import '../../services/workout/workout_program_service.dart';
import 'stat_item.dart';

/// 프로그램 진행 요약 카드
class ProgressSummaryCard extends StatelessWidget {
  final ProgramProgress? programProgress;

  const ProgressSummaryCard({
    super.key,
    required this.programProgress,
  });

  @override
  Widget build(BuildContext context) {
    if (programProgress == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      child: Card(
        color: isDark ? const Color(0xFF1A1A1A) : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: const Color(0xFF4DABF7).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: Color(0xFF4DABF7),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).overallProgress,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4DABF7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: programProgress!.progressPercentage,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: const Color(0xFF4DABF7),
                minHeight: 8,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(programProgress!.progressPercentage * 100).toStringAsFixed(1)}% ${AppLocalizations.of(context).completed}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${programProgress!.completedSessions}/${programProgress!.totalSessions} ${AppLocalizations.of(context).sessions}',
                    style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatItem(
                      label: AppLocalizations.of(context).completedCount,
                      value: '${programProgress!.totalCompletedReps}회',
                      icon: Icons.fitness_center,
                      color: const Color(0xFF51CF66),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatItem(
                      label: AppLocalizations.of(context).remainingCount,
                      value: '${programProgress!.remainingReps}회',
                      icon: Icons.schedule,
                      color: const Color(0xFFFFD43B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
