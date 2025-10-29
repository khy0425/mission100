import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../models/achievement.dart';
import '../../generated/app_localizations.dart';

/// 업적 레어도 뱃지
class AchievementsRarityBadge extends StatelessWidget {
  final AchievementRarity rarity;
  final int count;

  const AchievementsRarityBadge({
    super.key,
    required this.rarity,
    required this.count,
  });

  Color _getRarityColor() {
    return Achievement(
      id: '',
      titleKey: 'achievementTutorialExplorerTitle',
      descriptionKey: 'achievementTutorialExplorerDesc',
      motivationKey: 'achievementTutorialExplorerMotivation',
      type: AchievementType.first,
      rarity: rarity,
      targetValue: 0,
      icon: Icons.star,
    ).getRarityColor();
  }

  String _getRarityLabel(BuildContext context) {
    switch (rarity) {
      case AchievementRarity.common:
        return AppLocalizations.of(context).common;
      case AchievementRarity.rare:
        return AppLocalizations.of(context).rare;
      case AchievementRarity.epic:
        return AppLocalizations.of(context).epic;
      case AchievementRarity.legendary:
        return AppLocalizations.of(context).legendary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getRarityColor();

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
              color: theme.colorScheme.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _getRarityLabel(context),
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
