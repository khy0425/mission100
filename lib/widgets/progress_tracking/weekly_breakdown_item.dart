import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';
import 'weekly_growth_chart.dart';

/// 주간 분석 아이템 위젯
class WeeklyBreakdownItem extends StatelessWidget {
  final WeeklyProgressData data;

  const WeeklyBreakdownItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final completionPercentage = (data.completionRate * 100).toInt();
    final isCompleted = data.completionRate >= 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xFF51CF66).withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF51CF66).withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFF51CF66) : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${data.week}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.week}주차',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.completedSessions}/${data.totalSessions} ${AppLocalizations.of(context).sessionsCompleted} • ${data.totalReps}회',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '$completionPercentage%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCompleted ? const Color(0xFF51CF66) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
