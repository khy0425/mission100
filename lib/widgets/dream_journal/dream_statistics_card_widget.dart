import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';

/// 꿈 일기 통계 카드 위젯
///
/// 총 꿈, 자각몽, 평균 자각도, 연속 기록 표시
class DreamStatisticsCardWidget extends StatelessWidget {
  final int totalDreams;
  final int lucidDreams;
  final double avgLucidity;
  final int currentStreak;

  const DreamStatisticsCardWidget({
    super.key,
    required this.totalDreams,
    required this.lucidDreams,
    required this.avgLucidity,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.all(AppConstants.paddingM),
      elevation: AppConstants.elevationM,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.auto_stories,
              label: l10n.statTotalDreams,
              value: '$totalDreams',
              color: Colors.blue,
            ),
            _buildStatItem(
              icon: Icons.star,
              label: l10n.statLucidDreams,
              value: '$lucidDreams',
              color: Colors.amber,
            ),
            _buildStatItem(
              icon: Icons.trending_up,
              label: l10n.statAvgLucidity,
              value: avgLucidity.toStringAsFixed(1),
              color: Colors.green,
            ),
            _buildStatItem(
              icon: Icons.local_fire_department,
              label: l10n.statStreakLabel,
              value: l10n.statStreakDays(currentStreak.toString()),
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeXS,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
