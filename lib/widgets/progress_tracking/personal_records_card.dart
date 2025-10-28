import 'package:flutter/material.dart';
import 'weekly_growth_chart.dart';
import 'record_item.dart';

/// 개인 기록 카드
class PersonalRecordsCard extends StatelessWidget {
  final List<WeeklyProgressData> weeklyData;

  const PersonalRecordsCard({
    super.key,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 개인 기록 계산
    final maxRepsInSession = weeklyData.isNotEmpty
        ? weeklyData.map((w) => w.totalReps).reduce((a, b) => a > b ? a : b)
        : 0;
    final bestWeek = weeklyData.isNotEmpty
        ? weeklyData.reduce(
            (a, b) => a.completionRate > b.completionRate ? a : b,
          )
        : null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutBack,
      child: Card(
        color: isDark ? const Color(0xFF1A1A1A) : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.military_tech, color: Color(0xFFFF6B6B), size: 24),
                  SizedBox(width: 8),
                  Text(
                    '개인 기록',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B6B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: RecordItem(
                      title: '최고 기록',
                      value: '$maxRepsInSession회',
                      icon: Icons.emoji_events,
                      color: const Color(0xFFFFD43B),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RecordItem(
                      title: '최고 주차',
                      value: bestWeek != null ? '${bestWeek.week}주차' : '-',
                      icon: Icons.star,
                      color: const Color(0xFF51CF66),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: RecordItem(
                      title: '연속 일수',
                      value: '7일', // 임시 값
                      icon: Icons.local_fire_department,
                      color: const Color(0xFFFF6B6B),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RecordItem(
                      title: '평균 점수',
                      value: '85점', // 임시 값
                      icon: Icons.grade,
                      color: const Color(0xFF4DABF7),
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
