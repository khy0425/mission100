import 'package:flutter/material.dart';
import '../achievement.dart';
import '../achievement_type.dart';

/// 완벽 수행 시리즈 업적들 (4개)
///
/// 완벽한 자세로 연속 운동 완료
class PerfectAchievements {
  static List<Achievement> get all => [
        Achievement(
          id: 'perfect_workout_3',
          titleKey: 'achievementPerfect3Title',
          descriptionKey: 'achievementPerfect3Desc',
          motivationKey: 'achievementPerfect3Motivation',
          type: AchievementType.perfect,
          rarity: AchievementRarity.common,
          targetValue: 3,
          xpReward: 250,
          icon: Icons.gps_fixed,
        ),

        Achievement(
          id: 'perfect_workout_5',
          titleKey: 'achievementPerfect5Title',
          descriptionKey: 'achievementPerfect5Desc',
          motivationKey: 'achievementPerfect5Motivation',
          type: AchievementType.perfect,
          rarity: AchievementRarity.rare,
          targetValue: 5,
          xpReward: 400,
          icon: Icons.verified,
        ),

        Achievement(
          id: 'perfect_workout_10',
          titleKey: 'achievementPerfect10Title',
          descriptionKey: 'achievementPerfect10Desc',
          motivationKey: 'achievementPerfect10Motivation',
          type: AchievementType.perfect,
          rarity: AchievementRarity.epic,
          targetValue: 10,
          xpReward: 750,
          icon: Icons.workspace_premium,
        ),

        Achievement(
          id: 'perfect_workout_20',
          titleKey: 'achievementPerfect20Title',
          descriptionKey: 'achievementPerfect20Desc',
          motivationKey: 'achievementPerfect20Motivation',
          type: AchievementType.perfect,
          rarity: AchievementRarity.legendary,
          targetValue: 20,
          xpReward: 1200,
          icon: Icons.diamond,
        ),
      ];

  /// 총 EXP
  static int get totalExp => 2600;

  /// 업적 개수
  static int get count => 4;
}
