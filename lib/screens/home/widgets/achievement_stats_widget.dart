import 'package:flutter/material.dart';
import '../../../utils/config/constants.dart';
import '../../../generated/l10n/app_localizations.dart';

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
      padding: const EdgeInsets.all(6),
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
        const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
        const SizedBox(width: AppConstants.paddingS),
        Text(
          AppLocalizations.of(context).achievementStatus,
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
        Flexible(
          child: _buildAchievementStat(
            context,
            theme,
            AppLocalizations.of(context).achievementsUnlocked,
            '$unlockedCount/$totalCount',
            Icons.military_tech,
            Colors.amber,
          ),
        ),
        Flexible(
          child: _buildAchievementStat(
            context,
            theme,
            AppLocalizations.of(context).totalXP,
            '$totalXP XP',
            Icons.star,
            Colors.purple,
          ),
        ),
        Flexible(
          child: _buildAchievementStat(
            context,
            theme,
            AppLocalizations.of(context).completion,
            totalCount > 0
                ? '${((unlockedCount / totalCount) * 100).toStringAsFixed(0)}%'
                : '0%',
            Icons.percent,
            Colors.green,
          ),
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
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 11,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            fontSize: 8,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
