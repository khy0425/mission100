import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../models/achievement.dart';
import '../../generated/app_localizations.dart';
import 'achievements_stat_item.dart';
import 'achievements_rarity_badge.dart';

/// 업적 통계 헤더
class AchievementsStatsHeader extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;
  final int totalXP;
  final Map<AchievementRarity, int> rarityCount;
  final bool isLoading;

  const AchievementsStatsHeader({
    super.key,
    required this.unlockedCount,
    required this.totalCount,
    required this.totalXP,
    required this.rarityCount,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingM),
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [
                  Color(AppColors.chadGradient[0]),
                  Color(AppColors.chadGradient[1]),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: <Color>[
                  Color(0xFF2196F3), // 밝은 파란색
                  Color(0xFF1976D2), // 진한 파란색
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: (isDark ? theme.colorScheme.onSurface : Colors.grey).withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '🏆 ${AppLocalizations.of(context).achievements}',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),

          // 메인 통계
          Row(
            children: [
              Expanded(
                child: AchievementsStatItem(
                  icon: Icons.emoji_events,
                  value: '$unlockedCount/$totalCount',
                  label: AppLocalizations.of(context).unlockedAchievements(unlockedCount),
                  color: Colors.amber,
                ),
              ),
              Expanded(
                child: AchievementsStatItem(
                  icon: Icons.star,
                  value: '$totalXP XP',
                  label: AppLocalizations.of(context).totalExperience,
                  color: theme.colorScheme.surface,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.paddingM),

          // 레어도별 통계
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AchievementsRarityBadge(
                rarity: AchievementRarity.common,
                count: rarityCount[AchievementRarity.common] ?? 0,
              ),
              AchievementsRarityBadge(
                rarity: AchievementRarity.rare,
                count: rarityCount[AchievementRarity.rare] ?? 0,
              ),
              AchievementsRarityBadge(
                rarity: AchievementRarity.epic,
                count: rarityCount[AchievementRarity.epic] ?? 0,
              ),
              AchievementsRarityBadge(
                rarity: AchievementRarity.legendary,
                count: rarityCount[AchievementRarity.legendary] ?? 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
