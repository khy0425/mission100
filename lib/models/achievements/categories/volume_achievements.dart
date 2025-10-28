import 'package:flutter/material.dart';
import '../achievement.dart';
import '../achievement_type.dart';

/// 총량 달성 시리즈 업적들 (8개)
///
/// 푸쉬업 총 개수 목표 달성
class VolumeAchievements {
  static List<Achievement> get all => [
        Achievement(
          id: 'total_50_pushups',
          titleKey: 'achievementTotal50Title',
          descriptionKey: 'achievementTotal50Desc',
          motivationKey: 'achievementTotal50Motivation',
          type: AchievementType.volume,
          rarity: AchievementRarity.common,
          targetValue: 50,
          xpReward: 100,
          icon: Icons.eco,
        ),

        Achievement(
          id: 'total_100_pushups',
          titleKey: 'achievementTotal100Title',
          descriptionKey: 'achievementTotal100Desc',
          motivationKey: 'achievementTotal100Motivation',
          type: AchievementType.volume,
          rarity: AchievementRarity.common,
          targetValue: 100,
          xpReward: 200,
          icon: Icons.sports_score,
        ),

        Achievement(
          id: 'total_250_pushups',
          titleKey: 'achievementTotal250Title',
          descriptionKey: 'achievementTotal250Desc',
          motivationKey: 'achievementTotal250Motivation',
          type: AchievementType.volume,
          rarity: AchievementRarity.common,
          targetValue: 250,
          xpReward: 300,
          icon: Icons.gps_fixed,
        ),

        Achievement(
          id: 'total_500_pushups',
          titleKey: 'achievementTotal500Title',
          descriptionKey: 'achievementTotal500Desc',
          motivationKey: 'achievementTotal500Motivation',
          type: AchievementType.volume,
          rarity: AchievementRarity.rare,
          targetValue: 500,
          xpReward: 500,
          icon: Icons.rocket_launch,
        ),

        Achievement(
          id: 'total_1000_pushups',
          titleKey: 'achievementTotal1000Title',
          descriptionKey: 'achievementTotal1000Desc',
          motivationKey: 'achievementTotal1000Motivation',
          type: AchievementType.volume,
          rarity: AchievementRarity.epic,
          targetValue: 1000,
          xpReward: 1000,
          icon: Icons.bolt,
        ),

        Achievement(
          id: 'total_2500_pushups',
          titleKey: 'achievementTotal2500Title',
          descriptionKey: 'achievementTotal2500Desc',
          motivationKey: 'achievementTotal2500Motivation',
          type: AchievementType.volume,
          rarity: AchievementRarity.epic,
          targetValue: 2500,
          xpReward: 1500,
          icon: Icons.local_fire_department,
        ),

        Achievement(
          id: 'total_5000_pushups',
          titleKey: 'achievementTotal5000Title',
          descriptionKey: 'achievementTotal5000Desc',
          motivationKey: 'achievementTotal5000Motivation',
          type: AchievementType.volume,
          rarity: AchievementRarity.legendary,
          targetValue: 5000,
          xpReward: 2000,
          icon: Icons.stars,
        ),

        Achievement(
          id: 'total_10000_pushups',
          titleKey: 'achievementTotal10000Title',
          descriptionKey: 'achievementTotal10000Desc',
          motivationKey: 'achievementTotal10000Motivation',
          type: AchievementType.volume,
          rarity: AchievementRarity.legendary,
          targetValue: 10000,
          xpReward: 5000,
          icon: Icons.emoji_events,
        ),
      ];

  /// 총 EXP
  static int get totalExp => 10600;

  /// 업적 개수
  static int get count => 8;
}
