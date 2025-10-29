import 'package:flutter/material.dart';
import '../../../generated/app_localizations.dart';
import 'achievement_type.dart';

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
