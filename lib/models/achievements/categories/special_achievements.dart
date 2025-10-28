import 'package:flutter/material.dart';
import '../achievement.dart';
import '../achievement_type.dart';

/// 특별한 조건 시리즈 업적들 (13개)
///
/// 튜토리얼, 시간대별, 성능 기반 특별 업적
class SpecialAchievements {
  static List<Achievement> get all => [
        // 특별한 조건 시리즈
        Achievement(
          id: 'tutorial_explorer',
          titleKey: 'achievementTutorialExplorerTitle',
          descriptionKey: 'achievementTutorialExplorerDesc',
          motivationKey: 'achievementTutorialExplorerMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 200,
          icon: Icons.explore,
        ),

        Achievement(
          id: 'tutorial_student',
          titleKey: 'achievementTutorialStudentTitle',
          descriptionKey: 'achievementTutorialStudentDesc',
          motivationKey: 'achievementTutorialStudentMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.rare,
          targetValue: 3,
          xpReward: 300,
          icon: Icons.school,
        ),

        Achievement(
          id: 'tutorial_master',
          titleKey: 'achievementTutorialMasterTitle',
          descriptionKey: 'achievementTutorialMasterDesc',
          motivationKey: 'achievementTutorialMasterMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.legendary,
          targetValue: 5,
          xpReward: 1000,
          icon: Icons.psychology,
        ),

        // 시간대별 특별 업적
        Achievement(
          id: 'early_bird',
          titleKey: 'achievementEarlyBirdTitle',
          descriptionKey: 'achievementEarlyBirdDesc',
          motivationKey: 'achievementEarlyBirdMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 300,
          icon: Icons.wb_sunny,
        ),

        Achievement(
          id: 'night_owl',
          titleKey: 'achievementNightOwlTitle',
          descriptionKey: 'achievementNightOwlDesc',
          motivationKey: 'achievementNightOwlMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 300,
          icon: Icons.nightlight,
        ),

        Achievement(
          id: 'weekend_warrior',
          titleKey: 'achievementWeekendWarriorTitle',
          descriptionKey: 'achievementWeekendWarriorDesc',
          motivationKey: 'achievementWeekendWarriorMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 200,
          icon: Icons.weekend,
        ),

        Achievement(
          id: 'lunch_break_chad',
          titleKey: 'achievementLunchBreakTitle',
          descriptionKey: 'achievementLunchBreakDesc',
          motivationKey: 'achievementLunchBreakMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 150,
          icon: Icons.lunch_dining,
        ),

        // 성능 기반 업적
        Achievement(
          id: 'speed_demon',
          titleKey: 'achievementSpeedDemonTitle',
          descriptionKey: 'achievementSpeedDemonDesc',
          motivationKey: 'achievementSpeedDemonMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.epic,
          targetValue: 1,
          xpReward: 500,
          icon: Icons.speed,
        ),

        Achievement(
          id: 'endurance_king',
          titleKey: 'achievementEnduranceKingTitle',
          descriptionKey: 'achievementEnduranceKingDesc',
          motivationKey: 'achievementEnduranceKingMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.epic,
          targetValue: 1,
          xpReward: 500,
          icon: Icons.timer,
        ),

        Achievement(
          id: 'comeback_kid',
          titleKey: 'achievementComebackKidTitle',
          descriptionKey: 'achievementComebackKidDesc',
          motivationKey: 'achievementComebackKidMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 400,
          icon: Icons.refresh,
        ),

        Achievement(
          id: 'overachiever',
          titleKey: 'achievementOverachieverTitle',
          descriptionKey: 'achievementOverachieverDesc',
          motivationKey: 'achievementOverachieverMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.epic,
          targetValue: 1,
          xpReward: 600,
          icon: Icons.trending_up,
        ),

        Achievement(
          id: 'double_trouble',
          titleKey: 'achievementDoubleTroubleTitle',
          descriptionKey: 'achievementDoubleTroubleDesc',
          motivationKey: 'achievementDoubleTroubleMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 350,
          icon: Icons.double_arrow,
        ),

        Achievement(
          id: 'consistency_master',
          titleKey: 'achievementConsistencyMasterTitle',
          descriptionKey: 'achievementConsistencyMasterDesc',
          motivationKey: 'achievementConsistencyMasterMotivation',
          type: AchievementType.special,
          rarity: AchievementRarity.legendary,
          targetValue: 1,
          xpReward: 1000,
          icon: Icons.timeline,
        ),
      ];

  /// 총 EXP
  static int get totalExp => 5800;

  /// 업적 개수
  static int get count => 13;
}
