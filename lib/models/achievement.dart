import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';

enum AchievementType {
  first, // 첫 번째 달성
  streak, // 연속 달성
  volume, // 총량 달성
  perfect, // 완벽한 수행
  special, // 특별한 조건
  challenge, // 챌린지 완료
  statistics, // 통계 기반 업적
}

enum AchievementRarity {
  common, // 일반
  rare, // 레어
  epic, // 에픽
  legendary, // 레전더리
}

class Achievement {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String motivationKey;
  final AchievementType type;
  final AchievementRarity rarity;
  final int targetValue; // 달성 목표값
  final int currentValue; // 현재 진행값
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int xpReward; // 경험치 보상
  final IconData icon;
  final bool isNotified; // 알림 여부

  Achievement({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.motivationKey,
    required this.type,
    required this.rarity,
    required this.targetValue,
    this.currentValue = 0,
    this.isUnlocked = false,
    this.unlockedAt,
    this.xpReward = 0,
    required this.icon,
    this.isNotified = false,
  });

  double get progress => currentValue / targetValue;
  bool get isCompleted => currentValue >= targetValue;

  // 이전 버전과의 호환성을 위한 getter들
  String get title => titleKey;
  String get description => descriptionKey;
  String get motivationalMessage => motivationKey;
  int get iconCode => icon.codePoint;

  String getTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (titleKey) {
      case 'achievementTutorialExplorerTitle':
        return l10n.achievementTutorialExplorerTitle;
      case 'achievementTutorialStudentTitle':
        return l10n.achievementTutorialStudentTitle;
      case 'achievementTutorialMasterTitle':
        return l10n.achievementTutorialMasterTitle;
      case 'achievementPerfect3Title':
        return l10n.achievementPerfect3Title;
      case 'achievementPerfect5Title':
        return l10n.achievementPerfect5Title;
      case 'achievementPerfect10Title':
        return l10n.achievementPerfect10Title;
      case 'achievementPerfect20Title':
        return l10n.achievementPerfect20Title;
      case 'achievementLevel5Title':
        return l10n.achievementLevel5Title;
      case 'achievementFirst50Title':
        return l10n.achievementFirst50Title;
      case 'achievementFirst100SingleTitle':
        return l10n.achievementFirst100SingleTitle;
      case 'achievementStreak3Title':
        return l10n.achievementStreak3Title;
      case 'achievementStreak7Title':
        return l10n.achievementStreak7Title;
      case 'achievementStreak14Title':
        return l10n.achievementStreak14Title;
      case 'achievementStreak30Title':
        return l10n.achievementStreak30Title;
      case 'achievementStreak60Title':
        return l10n.achievementStreak60Title;
      case 'achievementStreak100Title':
        return l10n.achievementStreak100Title;
      case 'achievementTotal50Title':
        return l10n.achievementTotal50Title;
      case 'achievementTotal100Title':
        return l10n.achievementTotal100Title;
      case 'achievementTotal250Title':
        return l10n.achievementTotal250Title;
      case 'achievementTotal500Title':
        return l10n.achievementTotal500Title;
      case 'achievementTotal1000Title':
        return l10n.achievementTotal1000Title;
      case 'achievementTotal2500Title':
        return l10n.achievementTotal2500Title;
      case 'achievementTotal5000Title':
        return l10n.achievementTotal5000Title;
      case 'achievementTotal10000Title':
        return l10n.achievementTotal10000Title;
      case 'achievementEarlyBirdTitle':
        return l10n.achievementEarlyBirdTitle;
      case 'achievementNightOwlTitle':
        return l10n.achievementNightOwlTitle;
      case 'achievementWeekendWarriorTitle':
        return l10n.achievementWeekendWarriorTitle;
      case 'achievementLunchBreakTitle':
        return l10n.achievementLunchBreakTitle;
      case 'achievementSpeedDemonTitle':
        return l10n.achievementSpeedDemonTitle;
      case 'achievementEnduranceKingTitle':
        return l10n.achievementEnduranceKingTitle;
      case 'achievementComebackKidTitle':
        return l10n.achievementComebackKidTitle;
      case 'achievementOverachieverTitle':
        return l10n.achievementOverachieverTitle;
      case 'achievementDoubleTroubleTitle':
        return l10n.achievementDoubleTroubleTitle;
      case 'achievementConsistencyMasterTitle':
        return l10n.achievementConsistencyMasterTitle;
      case 'achievementCompletionRate80Title':
        return l10n.achievementCompletionRate80Title;
      case 'achievementCompletionRate90Title':
        return l10n.achievementCompletionRate90Title;
      case 'achievementCompletionRate95Title':
        return l10n.achievementCompletionRate95Title;
      case 'achievementWorkoutTime60Title':
        return l10n.achievementWorkoutTime60Title;
      case 'achievementWorkoutTime300Title':
        return l10n.achievementWorkoutTime300Title;
      default:
        return titleKey;
    }
  }

  String getDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (descriptionKey) {
      case 'achievementTutorialExplorerDesc':
        return l10n.achievementTutorialExplorerDesc;
      case 'achievementTutorialStudentDesc':
        return l10n.achievementTutorialStudentDesc;
      case 'achievementTutorialMasterDesc':
        return l10n.achievementTutorialMasterDesc;
      case 'achievementPerfect3Desc':
        return l10n.achievementPerfect3Desc;
      case 'achievementPerfect5Desc':
        return l10n.achievementPerfect5Desc;
      case 'achievementPerfect10Desc':
        return l10n.achievementPerfect10Desc;
      case 'achievementPerfect20Desc':
        return l10n.achievementPerfect20Desc;
      case 'achievementLevel5Desc':
        return l10n.achievementLevel5Desc;
      case 'achievementFirst50Desc':
        return l10n.achievementFirst50Desc;
      case 'achievementFirst100SingleDesc':
        return l10n.achievementFirst100SingleDesc;
      case 'achievementStreak3Desc':
        return l10n.achievementStreak3Desc;
      case 'achievementStreak7Desc':
        return l10n.achievementStreak7Desc;
      case 'achievementStreak14Desc':
        return l10n.achievementStreak14Desc;
      case 'achievementStreak30Desc':
        return l10n.achievementStreak30Desc;
      case 'achievementStreak60Desc':
        return l10n.achievementStreak60Desc;
      case 'achievementStreak100Desc':
        return l10n.achievementStreak100Desc;
      case 'achievementTotal50Desc':
        return l10n.achievementTotal50Desc;
      case 'achievementTotal100Desc':
        return l10n.achievementTotal100Desc;
      case 'achievementTotal250Desc':
        return l10n.achievementTotal250Desc;
      case 'achievementTotal500Desc':
        return l10n.achievementTotal500Desc;
      case 'achievementTotal1000Desc':
        return l10n.achievementTotal1000Desc;
      case 'achievementTotal2500Desc':
        return l10n.achievementTotal2500Desc;
      case 'achievementTotal5000Desc':
        return l10n.achievementTotal5000Desc;
      case 'achievementTotal10000Desc':
        return l10n.achievementTotal10000Desc;
      case 'achievementEarlyBirdDesc':
        return l10n.achievementEarlyBirdDesc;
      case 'achievementNightOwlDesc':
        return l10n.achievementNightOwlDesc;
      case 'achievementWeekendWarriorDesc':
        return l10n.achievementWeekendWarriorDesc;
      case 'achievementLunchBreakDesc':
        return l10n.achievementLunchBreakDesc;
      case 'achievementSpeedDemonDesc':
        return l10n.achievementSpeedDemonDesc;
      case 'achievementEnduranceKingDesc':
        return l10n.achievementEnduranceKingDesc;
      case 'achievementComebackKidDesc':
        return l10n.achievementComebackKidDesc;
      case 'achievementOverachieverDesc':
        return l10n.achievementOverachieverDesc;
      case 'achievementDoubleTroubleDesc':
        return l10n.achievementDoubleTroubleDesc;
      case 'achievementConsistencyMasterDesc':
        return l10n.achievementConsistencyMasterDesc;
      case 'achievementCompletionRate80Desc':
        return l10n.achievementCompletionRate80Desc;
      case 'achievementCompletionRate90Desc':
        return l10n.achievementCompletionRate90Desc;
      case 'achievementCompletionRate95Desc':
        return l10n.achievementCompletionRate95Desc;
      case 'achievementWorkoutTime60Desc':
        return l10n.achievementWorkoutTime60Desc;
      case 'achievementWorkoutTime300Desc':
        return l10n.achievementWorkoutTime300Desc;
      default:
        return descriptionKey;
    }
  }

  String getMotivation(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (motivationKey) {
      case 'achievementTutorialExplorerMotivation':
        return l10n.achievementTutorialExplorerMotivation;
      case 'achievementTutorialStudentMotivation':
        return l10n.achievementTutorialStudentMotivation;
      case 'achievementTutorialMasterMotivation':
        return l10n.achievementTutorialMasterMotivation;
      case 'achievementPerfect3Motivation':
        return l10n.achievementPerfect3Motivation;
      case 'achievementPerfect5Motivation':
        return l10n.achievementPerfect5Motivation;
      case 'achievementPerfect10Motivation':
        return l10n.achievementPerfect10Motivation;
      case 'achievementPerfect20Motivation':
        return l10n.achievementPerfect20Motivation;
      case 'achievementLevel5Motivation':
        return l10n.achievementLevel5Motivation;
      case 'achievementFirst50Motivation':
        return l10n.achievementFirst50Motivation;
      case 'achievementFirst100SingleMotivation':
        return l10n.achievementFirst100SingleMotivation;
      case 'achievementStreak3Motivation':
        return l10n.achievementStreak3Motivation;
      case 'achievementStreak7Motivation':
        return l10n.achievementStreak7Motivation;
      case 'achievementStreak14Motivation':
        return l10n.achievementStreak14Motivation;
      case 'achievementStreak30Motivation':
        return l10n.achievementStreak30Motivation;
      case 'achievementStreak60Motivation':
        return l10n.achievementStreak60Motivation;
      case 'achievementStreak100Motivation':
        return l10n.achievementStreak100Motivation;
      case 'achievementTotal50Motivation':
        return l10n.achievementTotal50Motivation;
      case 'achievementTotal100Motivation':
        return l10n.achievementTotal100Motivation;
      case 'achievementTotal250Motivation':
        return l10n.achievementTotal250Motivation;
      case 'achievementTotal500Motivation':
        return l10n.achievementTotal500Motivation;
      case 'achievementTotal1000Motivation':
        return l10n.achievementTotal1000Motivation;
      case 'achievementTotal2500Motivation':
        return l10n.achievementTotal2500Motivation;
      case 'achievementTotal5000Motivation':
        return l10n.achievementTotal5000Motivation;
      case 'achievementTotal10000Motivation':
        return l10n.achievementTotal10000Motivation;
      case 'achievementEarlyBirdMotivation':
        return l10n.achievementEarlyBirdMotivation;
      case 'achievementNightOwlMotivation':
        return l10n.achievementNightOwlMotivation;
      case 'achievementWeekendWarriorMotivation':
        return l10n.achievementWeekendWarriorMotivation;
      case 'achievementLunchBreakMotivation':
        return l10n.achievementLunchBreakMotivation;
      case 'achievementSpeedDemonMotivation':
        return l10n.achievementSpeedDemonMotivation;
      case 'achievementEnduranceKingMotivation':
        return l10n.achievementEnduranceKingMotivation;
      case 'achievementComebackKidMotivation':
        return l10n.achievementComebackKidMotivation;
      case 'achievementOverachieverMotivation':
        return l10n.achievementOverachieverMotivation;
      case 'achievementDoubleTroubleMotivation':
        return l10n.achievementDoubleTroubleMotivation;
      case 'achievementConsistencyMasterMotivation':
        return l10n.achievementConsistencyMasterMotivation;
      case 'achievementCompletionRate80Motivation':
        return l10n.achievementCompletionRate80Motivation;
      case 'achievementCompletionRate90Motivation':
        return l10n.achievementCompletionRate90Motivation;
      case 'achievementCompletionRate95Motivation':
        return l10n.achievementCompletionRate95Motivation;
      case 'achievementWorkoutTime60Motivation':
        return l10n.achievementWorkoutTime60Motivation;
      case 'achievementWorkoutTime300Motivation':
        return l10n.achievementWorkoutTime300Motivation;
      default:
        return motivationKey;
    }
  }

  String getRarityName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (rarity) {
      case AchievementRarity.common:
        return l10n.rarityCommon;
      case AchievementRarity.rare:
        return l10n.rarityRare;
      case AchievementRarity.epic:
        return l10n.rarityEpic;
      case AchievementRarity.legendary:
        return l10n.rarityLegendary;
    }
  }

  Color getRarityColor() {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
    }
  }

  Achievement copyWith({
    String? id,
    String? titleKey,
    String? descriptionKey,
    String? motivationKey,
    AchievementType? type,
    AchievementRarity? rarity,
    int? targetValue,
    int? currentValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? xpReward,
    IconData? icon,
  }) {
    return Achievement(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      motivationKey: motivationKey ?? this.motivationKey,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      xpReward: xpReward ?? this.xpReward,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titleKey': titleKey,
      'descriptionKey': descriptionKey,
      'motivationKey': motivationKey,
      'type': type.name,
      'rarity': rarity.name,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'isUnlocked': isUnlocked ? 1 : 0,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'xpReward': xpReward,
      'icon': icon.codePoint,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] as String,
      titleKey: map['titleKey'] as String,
      descriptionKey: map['descriptionKey'] as String,
      motivationKey: map['motivationKey'] as String,
      type: AchievementType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => AchievementType.first,
      ),
      rarity: AchievementRarity.values.firstWhere(
        (e) => e.toString() == map['rarity'],
        orElse: () => AchievementRarity.common,
      ),
      targetValue: map['targetValue'] as int,
      currentValue: map['currentValue'] as int? ?? 0,
      isUnlocked: (map['isUnlocked'] as int) == 1,
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.parse(map['unlockedAt'] as String)
          : null,
      xpReward: map['xpReward'] as int? ?? 0,
      icon: Icons.star,
    );
  }
}

// 미리 정의된 업적들
class PredefinedAchievements {
  static List<Achievement> get all => [
    // 첫 번째 달성 시리즈
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

    // 연속 달성 시리즈
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

    // 총량 달성 시리즈
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

    // 완벽 수행 시리즈
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

    // 성능 기반 업적 (구현 필요)
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

    // 챌린지 완료 업적들
    Achievement(
      id: 'challenge_7_days',
      titleKey: 'achievementChallenge7DaysTitle',
      descriptionKey: 'achievementChallenge7DaysDesc',
      motivationKey: 'achievementChallenge7DaysMotivation',
      type: AchievementType.challenge,
      rarity: AchievementRarity.rare,
      targetValue: 1,
      xpReward: 500,
      icon: Icons.calendar_today,
    ),

    Achievement(
      id: 'challenge_50_single',
      titleKey: 'achievementChallenge50SingleTitle',
      descriptionKey: 'achievementChallenge50SingleDesc',
      motivationKey: 'achievementChallenge50SingleMotivation',
      type: AchievementType.challenge,
      rarity: AchievementRarity.epic,
      targetValue: 1,
      xpReward: 750,
      icon: Icons.fitness_center,
    ),

    Achievement(
      id: 'challenge_100_cumulative',
      titleKey: 'achievementChallenge100CumulativeTitle',
      descriptionKey: 'achievementChallenge100CumulativeDesc',
      motivationKey: 'achievementChallenge100CumulativeMotivation',
      type: AchievementType.challenge,
      rarity: AchievementRarity.rare,
      targetValue: 1,
      xpReward: 400,
      icon: Icons.trending_up,
    ),

    Achievement(
      id: 'challenge_200_cumulative',
      titleKey: 'achievementChallenge200CumulativeTitle',
      descriptionKey: 'achievementChallenge200CumulativeDesc',
      motivationKey: 'achievementChallenge200CumulativeMotivation',
      type: AchievementType.challenge,
      rarity: AchievementRarity.epic,
      targetValue: 1,
      xpReward: 800,
      icon: Icons.emoji_events,
    ),

    Achievement(
      id: 'challenge_14_days',
      titleKey: 'achievementChallenge14DaysTitle',
      descriptionKey: 'achievementChallenge14DaysDesc',
      motivationKey: 'achievementChallenge14DaysMotivation',
      type: AchievementType.challenge,
      rarity: AchievementRarity.legendary,
      targetValue: 1,
      xpReward: 1200,
      icon: Icons.military_tech,
    ),

    Achievement(
      id: 'challenge_master',
      titleKey: 'achievementChallengeMasterTitle',
      descriptionKey: 'achievementChallengeMasterDesc',
      motivationKey: 'achievementChallengeMasterMotivation',
      type: AchievementType.challenge,
      rarity: AchievementRarity.legendary,
      targetValue: 5, // 5개 챌린지 모두 완료
      xpReward: 2000,
      icon: Icons.workspace_premium,
    ),

    // ================================
    // 통계 기반 업적들
    // ================================

    // 평균 완료율 관련 업적
    Achievement(
      id: 'completion_rate_80',
      titleKey: 'achievementCompletionRate80Title',
      descriptionKey: 'achievementCompletionRate80Desc',
      motivationKey: 'achievementCompletionRate80Motivation',
      type: AchievementType.statistics,
      rarity: AchievementRarity.rare,
      targetValue: 80,
      xpReward: 400,
      icon: Icons.percent,
    ),

    Achievement(
      id: 'completion_rate_90',
      titleKey: 'achievementCompletionRate90Title',
      descriptionKey: 'achievementCompletionRate90Desc',
      motivationKey: 'achievementCompletionRate90Motivation',
      type: AchievementType.statistics,
      rarity: AchievementRarity.epic,
      targetValue: 90,
      xpReward: 600,
      icon: Icons.verified_user,
    ),

    Achievement(
      id: 'completion_rate_95',
      titleKey: 'achievementCompletionRate95Title',
      descriptionKey: 'achievementCompletionRate95Desc',
      motivationKey: 'achievementCompletionRate95Motivation',
      type: AchievementType.statistics,
      rarity: AchievementRarity.legendary,
      targetValue: 95,
      xpReward: 1000,
      icon: Icons.stars,
    ),

    // 총 운동 시간 관련 업적
    Achievement(
      id: 'total_workout_time_60',
      titleKey: 'achievementWorkoutTime60Title',
      descriptionKey: 'achievementWorkoutTime60Desc',
      motivationKey: 'achievementWorkoutTime60Motivation',
      type: AchievementType.statistics,
      rarity: AchievementRarity.common,
      targetValue: 60,
      xpReward: 200,
      icon: Icons.timer,
    ),

    Achievement(
      id: 'total_workout_time_300',
      titleKey: 'achievementWorkoutTime300Title',
      descriptionKey: 'achievementWorkoutTime300Desc',
      motivationKey: 'achievementWorkoutTime300Motivation',
      type: AchievementType.statistics,
      rarity: AchievementRarity.rare,
      targetValue: 300,
      xpReward: 500,
      icon: Icons.fitness_center,
    ),

    Achievement(
      id: 'total_workout_time_600',
      titleKey: '10시간 운동 헌신자',
      descriptionKey: '총 운동 시간 600분(10시간)을 달성했습니다',
      motivationKey: '운동에 대한 헌신이 놀랍습니다!',
      type: AchievementType.statistics,
      rarity: AchievementRarity.epic,
      targetValue: 600,
      xpReward: 800,
      icon: Icons.schedule,
    ),

    Achievement(
      id: 'total_workout_time_1200',
      titleKey: '20시간 운동 전설',
      descriptionKey: '총 운동 시간 1200분(20시간)을 달성했습니다',
      motivationKey: '당신은 진정한 운동 전설입니다!',
      type: AchievementType.statistics,
      rarity: AchievementRarity.legendary,
      targetValue: 1200,
      xpReward: 1500,
      icon: Icons.emoji_events,
    ),

    // 평균 운동 시간 관련 업적
    Achievement(
      id: 'avg_workout_time_5',
      titleKey: '효율적인 운동가',
      descriptionKey: '평균 운동 시간 5분 이상을 달성했습니다',
      motivationKey: '짧지만 효과적인 운동을 하고 있습니다!',
      type: AchievementType.statistics,
      rarity: AchievementRarity.common,
      targetValue: 5,
      xpReward: 150,
      icon: Icons.speed,
    ),

    Achievement(
      id: 'avg_workout_time_10',
      titleKey: '집중력 마스터',
      descriptionKey: '평균 운동 시간 10분 이상을 달성했습니다',
      motivationKey: '집중해서 운동하는 습관이 훌륭합니다!',
      type: AchievementType.statistics,
      rarity: AchievementRarity.rare,
      targetValue: 10,
      xpReward: 300,
      icon: Icons.psychology,
    ),

    Achievement(
      id: 'avg_workout_time_15',
      titleKey: '지구력 챔피언',
      descriptionKey: '평균 운동 시간 15분 이상을 달성했습니다',
      motivationKey: '탁월한 지구력을 보여주고 있습니다!',
      type: AchievementType.statistics,
      rarity: AchievementRarity.epic,
      targetValue: 15,
      xpReward: 500,
      icon: Icons.sports_score,
    ),

    // 주간 통계 관련 업적
    Achievement(
      id: 'weekly_sessions_5',
      titleKey: '주간 운동 달성자',
      descriptionKey: '주 5회 이상 운동을 달성했습니다',
      motivationKey: '규칙적인 운동 습관이 자리잡았습니다!',
      type: AchievementType.statistics,
      rarity: AchievementRarity.rare,
      targetValue: 5,
      xpReward: 400,
      icon: Icons.date_range,
    ),

    Achievement(
      id: 'weekly_sessions_7',
      titleKey: '매일 운동 챔피언',
      descriptionKey: '매일 운동을 실천했습니다',
      motivationKey: '완벽한 운동 루틴을 유지하고 있습니다!',
      type: AchievementType.statistics,
      rarity: AchievementRarity.legendary,
      targetValue: 7,
      xpReward: 1000,
      icon: Icons.today,
    ),

    // 월간 통계 관련 업적
    Achievement(
      id: 'monthly_sessions_20',
      titleKey: '월간 운동 마스터',
      descriptionKey: '한 달에 20회 이상 운동을 완료했습니다',
      motivationKey: '꾸준함의 힘을 보여주고 있습니다!',
      type: AchievementType.statistics,
      rarity: AchievementRarity.epic,
      targetValue: 20,
      xpReward: 800,
      icon: Icons.calendar_today,
    ),

    Achievement(
      id: 'monthly_pushups_1000',
      titleKey: '월간 1000개 달성',
      descriptionKey: '한 달에 1000개 이상의 푸쉬업을 완료했습니다',
      motivationKey: '놀라운 운동량을 기록했습니다!',
      type: AchievementType.statistics,
      rarity: AchievementRarity.legendary,
      targetValue: 1000,
      xpReward: 1200,
      icon: Icons.trending_up,
    ),

    // 개인 기록 관련 업적
    Achievement(
      id: 'personal_best_improvement',
      titleKey: '개인 기록 갱신자',
      descriptionKey: '개인 최고 기록을 갱신했습니다',
      motivationKey: '한계를 뛰어넘는 성장을 보여주고 있습니다!',
      type: AchievementType.statistics,
      rarity: AchievementRarity.rare,
      targetValue: 1,
      xpReward: 350,
      icon: Icons.trending_up,
    ),

    Achievement(
      id: 'consistency_score_high',
      titleKey: '일관성 마스터',
      descriptionKey: '높은 일관성 점수를 달성했습니다',
      motivationKey: '꾸준한 운동 패턴이 인상적입니다!',
      type: AchievementType.statistics,
      rarity: AchievementRarity.epic,
      targetValue: 85,
      xpReward: 600,
      icon: Icons.timeline,
    ),

    // 운동 빈도 관련 업적
    Achievement(
      id: 'workout_frequency_daily',
      titleKey: '데일리 운동 전문가',
      descriptionKey: '하루도 빠짐없이 운동을 실천했습니다',
      motivationKey: '완벽한 운동 일정을 지키고 있습니다!',
      type: AchievementType.statistics,
      rarity: AchievementRarity.legendary,
      targetValue: 30,
      xpReward: 2000,
      icon: Icons.event_available,
    ),

    // === 챌린지 관련 업적들 ===

    // 첫 번째 챌린지 완료
    Achievement(
      id: 'first_challenge_complete',
      titleKey: '챌린지 도전자',
      descriptionKey: '첫 번째 챌린지를 완료했습니다',
      motivationKey: '챌린지의 첫 걸음을 뗀 CHAD! 멋지다! 💪',
      type: AchievementType.challenge,
      rarity: AchievementRarity.common,
      targetValue: 1,
      xpReward: 100,
      icon: Icons.flag,
    ),

    // 일일 완벽 자세 챌린지 완료
    Achievement(
      id: 'daily_perfect_challenger',
      titleKey: '완벽한 하루 CHAD',
      descriptionKey: '일일 완벽 자세 챌린지를 완료했습니다',
      motivationKey: '오늘 하루 완벽했다! CHAD의 자세가 빛났다! ✨',
      type: AchievementType.challenge,
      rarity: AchievementRarity.common,
      targetValue: 1,
      xpReward: 150,
      icon: Icons.stars,
    ),

    // 스킬 챌린지 완료 (30개 또는 50개)
    Achievement(
      id: 'skill_master',
      titleKey: '스킬 마스터 CHAD',
      descriptionKey: '스킬 챌린지를 완료했습니다',
      motivationKey: '한 번에 그 개수를? 당신은 진정한 BEAST! 🔥',
      type: AchievementType.challenge,
      rarity: AchievementRarity.rare,
      targetValue: 1,
      xpReward: 300,
      icon: Icons.local_fire_department,
    ),

    // 완벽한 휴식 주기 챌린지 완료
    Achievement(
      id: 'perfect_cycle_champion',
      titleKey: '완벽한 휴식 주기 마스터',
      descriptionKey: '완벽한 휴식 주기 챌린지를 완료했습니다',
      motivationKey: '운동→휴식→운동→휴식! 완벽한 패턴! 이것이 진정한 CHAD의 라이프스타일! 🔄',
      type: AchievementType.challenge,
      rarity: AchievementRarity.epic,
      targetValue: 1,
      xpReward: 500,
      icon: Icons.refresh,
    ),

    // 주간 완벽 스케줄 완료
    Achievement(
      id: 'weekly_schedule_master',
      titleKey: '완벽한 주간 CHAD',
      descriptionKey: '주간 완벽 스케줄 챌린지를 완료했습니다',
      motivationKey: '휴식도 계획대로! 운동도 완벽하게! LEGENDARY! 👑',
      type: AchievementType.challenge,
      rarity: AchievementRarity.epic,
      targetValue: 1,
      xpReward: 500,
      icon: Icons.calendar_view_week,
    ),

    // 월요일 모티베이션 완료
    Achievement(
      id: 'monday_crusher',
      titleKey: 'Monday Crusher',
      descriptionKey: '월요일 모티베이션 챌린지를 완료했습니다',
      motivationKey: '월요병? 그게 뭔가요? CHAD는 월요일도 CRUSH! 💥',
      type: AchievementType.challenge,
      rarity: AchievementRarity.common,
      targetValue: 1,
      xpReward: 200,
      icon: Icons.wb_sunny,
    ),

    // 챌린지 연속 완료 (5개)
    Achievement(
      id: 'challenge_streak_5',
      titleKey: '챌린지 스트리커',
      descriptionKey: '5개의 챌린지를 연속으로 완료했습니다',
      motivationKey: '연속 챌린지 완료! 당신의 의지력이 무섭다! 😤',
      type: AchievementType.challenge,
      rarity: AchievementRarity.rare,
      targetValue: 5,
      xpReward: 600,
      icon: Icons.trending_up,
    ),

    // 모든 타입의 챌린지 완료
    Achievement(
      id: 'all_challenge_types',
      titleKey: '챌린지 컬렉터',
      descriptionKey: '모든 타입의 챌린지를 완료했습니다',
      motivationKey: '일일, 주간, 스킬, 스프린트, 이벤트! 다 정복한 CHAD! 🏆',
      type: AchievementType.challenge,
      rarity: AchievementRarity.epic,
      targetValue: 5, // 5가지 타입 모두 완료
      xpReward: 800,
      icon: Icons.emoji_events,
    ),

    // 챌린지 마스터 (10개 완료)
    Achievement(
      id: 'challenge_master',
      titleKey: '챌린지 마스터',
      descriptionKey: '10개의 챌린지를 완료했습니다',
      motivationKey: '10개 완료? 당신은 진정한 챌린지 마스터! GODLIKE! ⚡',
      type: AchievementType.challenge,
      rarity: AchievementRarity.legendary,
      targetValue: 10,
      xpReward: 1000,
      icon: Icons.military_tech,
    ),

    // 챌린지 레전드 (20개 완료)
    Achievement(
      id: 'challenge_legend',
      titleKey: '챌린지 레전드',
      descriptionKey: '20개의 챌린지를 완료했습니다',
      motivationKey: '20개라고? 당신은 이미 전설이다! IMMORTAL CHAD! 👑',
      type: AchievementType.challenge,
      rarity: AchievementRarity.legendary,
      targetValue: 20,
      xpReward: 2000,
      icon: Icons.workspace_premium,
    ),

    // 동시 활성 챌린지 (3개 동시에)
    Achievement(
      id: 'multi_challenger',
      titleKey: '멀티 챌린저',
      descriptionKey: '3개의 챌린지를 동시에 진행했습니다',
      motivationKey: '동시에 3개? 당신의 멀티태스킹 능력이 무섭다! 🤹',
      type: AchievementType.challenge,
      rarity: AchievementRarity.rare,
      targetValue: 3,
      xpReward: 400,
      icon: Icons.layers,
    ),

    // 빠른 챌린지 완료 (시작 후 24시간 내)
    Achievement(
      id: 'speed_challenger',
      titleKey: '스피드 챌린저',
      descriptionKey: '챌린지를 24시간 내에 완료했습니다',
      motivationKey: '24시간 완료? 이 속도감! FLASH보다 빠르다! ⚡',
      type: AchievementType.challenge,
      rarity: AchievementRarity.rare,
      targetValue: 1,
      xpReward: 350,
      icon: Icons.flash_on,
    ),
  ];
}
