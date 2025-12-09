import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../models/achievement.dart';
import '../../generated/l10n/app_localizations.dart';

/// 업적 통계 헤더 위젯
///
/// XP, 달성 업적 수, 레어도별 카운트 표시
class AchievementsStatsHeaderWidget extends StatelessWidget {
  final bool isLoading;
  final int totalXP;
  final int unlockedCount;
  final int totalCount;
  final Map<AchievementRarity, int> rarityCount;

  const AchievementsStatsHeaderWidget({
    super.key,
    required this.isLoading,
    required this.totalXP,
    required this.unlockedCount,
    required this.totalCount,
    required this.rarityCount,
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
                  Color(AppColors.lucidGradient[0]),
                  Color(AppColors.lucidGradient[1]),
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
            color: (isDark ? Colors.black : Colors.grey).withValues(alpha: 0.2),
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
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),

          // 메인 통계
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.emoji_events,
                  value: '$unlockedCount/$totalCount',
                  label: AppLocalizations.of(context)
                      .unlockedAchievements(unlockedCount),
                  color: Colors.amber,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.star,
                  value: '$totalXP XP',
                  label: AppLocalizations.of(context).totalExperience,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.paddingM),

          // 레어도별 통계
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRarityBadge(
                context,
                AchievementRarity.common,
                rarityCount[AchievementRarity.common] ?? 0,
              ),
              _buildRarityBadge(
                context,
                AchievementRarity.rare,
                rarityCount[AchievementRarity.rare] ?? 0,
              ),
              _buildRarityBadge(
                context,
                AchievementRarity.epic,
                rarityCount[AchievementRarity.epic] ?? 0,
              ),
              _buildRarityBadge(
                context,
                AchievementRarity.legendary,
                rarityCount[AchievementRarity.legendary] ?? 0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: AppConstants.paddingS / 2),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildRarityBadge(
    BuildContext context,
    AchievementRarity rarity,
    int count,
  ) {
    final theme = Theme.of(context);
    final color = Achievement(
      id: '',
      titleKey: 'achievementTutorialExplorerTitle',
      descriptionKey: 'achievementTutorialExplorerDesc',
      motivationKey: 'achievementTutorialExplorerMotivation',
      type: AchievementType.first,
      rarity: rarity,
      targetValue: 0,
      icon: Icons.star,
    ).getRarityColor();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingS,
        vertical: AppConstants.paddingS / 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
        border: Border.all(color: color, width: 1),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            rarity == AchievementRarity.common
                ? AppLocalizations.of(context).common
                : rarity == AchievementRarity.rare
                    ? AppLocalizations.of(context).rare
                    : rarity == AchievementRarity.epic
                        ? AppLocalizations.of(context).epic
                        : AppLocalizations.of(context).legendary,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
