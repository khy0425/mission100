import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';
import '../../services/workout_program_service.dart';
import 'stat_card_item.dart';

/// 전체 통계 카드
class OverallStatsCard extends StatelessWidget {
  final ProgramProgress? programProgress;

  const OverallStatsCard({
    super.key,
    required this.programProgress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (programProgress == null) return const SizedBox.shrink();

    // 전체 통계 계산
    final averageRepsPerDay = programProgress!.totalCompletedReps /
        (programProgress!.completedSessions > 0
            ? programProgress!.completedSessions
            : 1);
    final completionRate = programProgress!.progressPercentage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
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
                    Icons.analytics,
                    color: Color(0xFF4DABF7),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).overallStats,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4DABF7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 통계 그리드
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  StatCardItem(
                    title: AppLocalizations.of(context).totalPushups,
                    value: '${programProgress!.totalCompletedReps}회',
                    icon: Icons.fitness_center,
                    color: const Color(0xFF51CF66),
                  ),
                  StatCardItem(
                    title: AppLocalizations.of(context).completedSessions,
                    value: '${programProgress!.completedSessions}회',
                    icon: Icons.check_circle,
                    color: const Color(0xFF4DABF7),
                  ),
                  StatCardItem(
                    title: AppLocalizations.of(context).averagePerSession,
                    value: '${averageRepsPerDay.toStringAsFixed(1)}회',
                    icon: Icons.trending_up,
                    color: const Color(0xFFFFD43B),
                  ),
                  StatCardItem(
                    title: Localizations.localeOf(context).languageCode == 'ko'
                        ? AppLocalizations.of(context).completionRate
                        : 'Completion',
                    value: '${(completionRate * 100).toStringAsFixed(1)}%',
                    icon: Icons.pie_chart,
                    color: const Color(0xFFFF6B6B),
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
