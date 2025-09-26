import 'package:flutter/material.dart';
import '../../../generated/app_localizations.dart';
import '../../../utils/constants.dart';

/// 업적 현황을 표시하는 위젯
///
/// 기능:
/// - 달성한 업적 수 / 총 업적 수
/// - 총 경험치 (XP)
/// - 업적 완료율
/// - 각 통계별 아이콘과 색상으로 시각화
class AchievementStatsWidget extends StatelessWidget {
  final int totalXP;
  final int unlockedCount;
  final int totalCount;

  const AchievementStatsWidget({
    super.key,
    required this.totalXP,
    required this.unlockedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: Color(isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, theme),
          const SizedBox(height: AppConstants.paddingM),
          _buildAchievementStats(context, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.emoji_events, color: Colors.amber, size: 24),
        const SizedBox(width: AppConstants.paddingS),
        Text(
          Localizations.localeOf(context).languageCode == 'ko'
              ? '업적 현황'
              : 'Achievements',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementStats(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildAchievementStat(
          context,
          theme,
          Localizations.localeOf(context).languageCode == 'ko'
              ? '달성한 업적'
              : 'Unlocked',
          '$unlockedCount/$totalCount',
          Icons.military_tech,
          Colors.amber,
        ),
        _buildAchievementStat(
          context,
          theme,
          Localizations.localeOf(context).languageCode == 'ko'
              ? '총 경험치'
              : 'Total XP',
          '${totalXP} XP',
          Icons.star,
          Colors.purple,
        ),
        _buildAchievementStat(
          context,
          theme,
          Localizations.localeOf(context).languageCode == 'ko'
              ? '완료율'
              : 'Completion',
          totalCount > 0
              ? '${((unlockedCount / totalCount) * 100).toStringAsFixed(0)}%'
              : '0%',
          Icons.percent,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildAchievementStat(
    BuildContext context,
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
