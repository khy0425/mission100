import 'package:flutter/material.dart';
import '../achievement.dart';
import '../achievement_type.dart';

/// 연속 달성 업적들 (6개)
///
/// 연속으로 운동한 일수를 기준으로 획득하는 업적
class StreakAchievements {
  static List<Achievement> get all => [
        // 3일 연속
        Achievement(
          id: 'streak_3_days',
          titleKey: 'achievementStreak3Title',
          descriptionKey: 'achievementStreak3Desc',
          motivationKey: 'achievementStreak3Motivation',
          type: AchievementType.streak,
          rarity: AchievementRarity.common,
          targetValue: 3,
          xpReward: 300,
          icon: Icons.local_fire_department,
        ),

        // 7일 연속
        Achievement(
          id: 'streak_7_days',
          titleKey: 'achievementStreak7Title',
          descriptionKey: 'achievementStreak7Desc',
          motivationKey: 'achievementStreak7Motivation',
          type: AchievementType.streak,
          rarity: AchievementRarity.rare,
          targetValue: 7,
          xpReward: 500,
          icon: Icons.fitness_center,
        ),

        // 14일 연속
        Achievement(
          id: 'streak_14_days',
          titleKey: 'achievementStreak14Title',
          descriptionKey: 'achievementStreak14Desc',
          motivationKey: 'achievementStreak14Motivation',
          type: AchievementType.streak,
          rarity: AchievementRarity.epic,
          targetValue: 14,
          xpReward: 800,
          icon: Icons.directions_run,
        ),

        // 30일 연속
        Achievement(
          id: 'streak_30_days',
          titleKey: 'achievementStreak30Title',
          descriptionKey: 'achievementStreak30Desc',
          motivationKey: 'achievementStreak30Motivation',
          type: AchievementType.streak,
          rarity: AchievementRarity.legendary,
          targetValue: 30,
          xpReward: 1500,
          icon: Icons.emoji_events,
        ),

        // 60일 연속
        Achievement(
          id: 'streak_60_days',
          titleKey: 'achievementStreak60Title',
          descriptionKey: 'achievementStreak60Desc',
          motivationKey: 'achievementStreak60Motivation',
          type: AchievementType.streak,
          rarity: AchievementRarity.legendary,
          targetValue: 60,
          xpReward: 2500,
          icon: Icons.military_tech,
        ),

        // 100일 연속
        Achievement(
          id: 'streak_100_days',
          titleKey: 'achievementStreak100Title',
          descriptionKey: 'achievementStreak100Desc',
          motivationKey: 'achievementStreak100Motivation',
          type: AchievementType.streak,
          rarity: AchievementRarity.legendary,
          targetValue: 100,
          xpReward: 5000,
          icon: Icons.stars,
        ),
      ];

  /// 총 EXP
  static int get totalExp => 10600;

  /// 업적 개수
  static int get count => 6;
}
