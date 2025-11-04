import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import 'weekly_growth_chart.dart';
import 'weekly_performance_item.dart';

/// 주간별 성과 카드
class WeeklyPerformanceCard extends StatelessWidget {
  final List<WeeklyProgressData> weeklyData;
  final VoidCallback onViewAll;

  const WeeklyPerformanceCard({
    super.key,
    required this.weeklyData,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
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
                    Icons.calendar_view_week,
                    color: Color(0xFF51CF66),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).weeklyPerformance,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF51CF66),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 주간별 성과 리스트
              ...weeklyData
                  .take(3)
                  .map((data) => WeeklyPerformanceItem(data: data)),

              if (weeklyData.length > 3) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: onViewAll,
                    child: const Text(
                      '전체 보기',
                      style: TextStyle(
                        color: Color(0xFF51CF66),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
