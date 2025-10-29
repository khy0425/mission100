import 'package:flutter/material.dart';
import '../achievement.dart';
import '../achievement_type.dart';

/// 첫 번째 달성 업적들 (4개)
///
/// 처음으로 특정 목표를 달성했을 때 획득하는 업적
class FirstAchievements {
  static List<Achievement> get all => [
        // 첫 운동
        Achievement(
          id: 'first_workout',
          titleKey: 'achievementTutorialExplorerTitle',
          descriptionKey: 'achievementTutorialExplorerDesc',
          motivationKey: 'achievementTutorialExplorerMotivation',
          type: AchievementType.first,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 100,
          icon: Icons.play_arrow,
        ),

        // 첫 50개 푸시업
        Achievement(
          id: 'first_50_pushups',
          titleKey: 'achievementFirst50Title',
          descriptionKey: 'achievementFirst50Desc',
          motivationKey: 'achievementFirst50Motivation',
          type: AchievementType.first,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 150,
          icon: Icons.fitness_center,
        ),

        // 한 번에 100개
        Achievement(
          id: 'first_100_single',
          titleKey: 'achievementFirst100SingleTitle',
          descriptionKey: 'achievementFirst100SingleDesc',
          motivationKey: 'achievementFirst100SingleMotivation',
          type: AchievementType.first,
          rarity: AchievementRarity.epic,
          targetValue: 1,
          xpReward: 500,
          icon: Icons.flash_on,
        ),

        // 첫 레벨업
        Achievement(
          id: 'first_level_up',
          titleKey: 'achievementLevel5Title',
          descriptionKey: 'achievementLevel5Desc',
          motivationKey: 'achievementLevel5Motivation',
          type: AchievementType.first,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 300,
          icon: Icons.trending_up,
        ),
      ];

  /// 총 EXP
  static int get totalExp => 1050;

  /// 업적 개수
  static int get count => 4;
}
