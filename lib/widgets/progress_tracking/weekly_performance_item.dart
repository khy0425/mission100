import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';
import 'weekly_growth_chart.dart';

/// 주간 성능 아이템 위젯
class WeeklyPerformanceItem extends StatelessWidget {
  final WeeklyProgressData data;

  const WeeklyPerformanceItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final completionPercentage = (data.completionRate * 100).toInt();
    final isExcellent = completionPercentage >= 100;
    final isGood = completionPercentage >= 80;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (isExcellent) {
      statusColor = const Color(0xFF51CF66);
      statusIcon = Icons.star;
      statusText = AppLocalizations.of(context).perfect;
    } else if (isGood) {
      statusColor = const Color(0xFF4DABF7);
      statusIcon = Icons.thumb_up;
      statusText = AppLocalizations.of(context).good;
    } else {
      statusColor = const Color(0xFFFFD43B);
      statusIcon = Icons.trending_up;
      statusText = AppLocalizations.of(context).improvement;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.week}주차',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${data.totalReps}회 완료',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$completionPercentage%',
                style: TextStyle(
                  fontSize: 14,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
