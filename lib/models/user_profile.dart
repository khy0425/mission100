import 'package:flutter/material.dart';

/// 피트니스 목표 열거형
enum FitnessGoal {
  weightLoss,    // 체중 감량
  muscleGain,    // 근육 증가
  endurance,     // 체력 향상
  general,       // 전반적 건강
}

/// 피트니스 레벨 열거형
enum FitnessLevel {
  beginner,     // 초보자
  intermediate, // 중급자
  advanced,     // 고급자
}

extension FitnessGoalExtension on FitnessGoal {
  String get displayName {
    switch (this) {
      case FitnessGoal.weightLoss:
        return '체중 감량';
      case FitnessGoal.muscleGain:
        return '근육 증가';
      case FitnessGoal.endurance:
        return '체력 향상';
      case FitnessGoal.general:
        return '전반적 건강';
    }
  }

  String get emoji {
    switch (this) {
      case FitnessGoal.weightLoss:
        return '🔥';
      case FitnessGoal.muscleGain:
        return '💪';
      case FitnessGoal.endurance:
        return '⚡';
      case FitnessGoal.general:
        return '🌟';
    }
  }
}

extension FitnessLevelExtension on FitnessLevel {
  String get displayName {
    switch (this) {
      case FitnessLevel.beginner:
        return '초보자';
      case FitnessLevel.intermediate:
        return '중급자';
      case FitnessLevel.advanced:
        return '고급자';
    }
  }
}

class UserProfile {
  final int? id;
  final UserLevel level;
  final int initialMaxReps;
  final DateTime startDate;
  final int chadLevel;
  final bool reminderEnabled;
  final String? reminderTime;
  final List<bool>? workoutDays; // 월~일 (7개 요소)

  // 개인화를 위한 새 필드들
  final double? currentWeight;
  final double? targetWeight;
  final FitnessLevel? fitnessLevel;
  final FitnessGoal? fitnessGoal;
  final List<String>? preferredWorkoutTimes;
  final bool? likesCompetition;
  final DateTime? onboardingCompletedAt;

  // Chad XP 및 레벨 시스템 (Firestore 동기화용)
  final int chadExperience;
  final int chadCurrentLevel;
  final int chadCurrentStage;
  final int chadTotalLevelUps;
  final DateTime? chadLastLevelUpAt;

  UserProfile({
    this.id,
    required this.level,
    required this.initialMaxReps,
    required this.startDate,
    this.chadLevel = 0,
    this.reminderEnabled = false,
    this.reminderTime,
    this.workoutDays,
    this.currentWeight,
    this.targetWeight,
    this.fitnessLevel,
    this.fitnessGoal,
    this.preferredWorkoutTimes,
    this.likesCompetition,
    this.onboardingCompletedAt,
    this.chadExperience = 0,
    this.chadCurrentLevel = 1,
    this.chadCurrentStage = 0,
    this.chadTotalLevelUps = 0,
    this.chadLastLevelUpAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level.toString(),
      'initial_max_reps': initialMaxReps,
      'start_date': startDate.toIso8601String(),
      'chad_level': chadLevel,
      'reminder_enabled': reminderEnabled ? 1 : 0,
      'reminder_time': reminderTime,
      'workout_days': workoutDays?.join(','), // 1,0,1,0,1,0,0 형태로 저장
      'current_weight': currentWeight,
      'target_weight': targetWeight,
      'fitness_level': fitnessLevel?.toString(),
      'fitness_goal': fitnessGoal?.toString(),
      'preferred_workout_times': preferredWorkoutTimes?.join(','),
      'likes_competition': likesCompetition != null ? (likesCompetition! ? 1 : 0) : null,
      'onboarding_completed_at': onboardingCompletedAt?.toIso8601String(),
      'chad_experience': chadExperience,
      'chad_current_level': chadCurrentLevel,
      'chad_current_stage': chadCurrentStage,
      'chad_total_level_ups': chadTotalLevelUps,
      'chad_last_level_up_at': chadLastLevelUpAt?.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as int?,
      level: UserLevel.values.firstWhere(
        (e) => e.toString() == map['level'] as String,
        orElse: () => UserLevel.rookie,
      ),
      initialMaxReps: map['initial_max_reps'] as int,
      startDate: DateTime.parse(map['start_date'] as String),
      chadLevel: map['chad_level'] as int? ?? 0,
      reminderEnabled: (map['reminder_enabled'] as int) == 1,
      reminderTime: map['reminder_time'] as String?,
      workoutDays: _parseWorkoutDays(map['workout_days'] as String?),
      currentWeight: map['current_weight'] as double?,
      targetWeight: map['target_weight'] as double?,
      fitnessLevel: map['fitness_level'] != null
          ? FitnessLevel.values.firstWhere(
              (e) => e.toString() == map['fitness_level'] as String,
              orElse: () => FitnessLevel.intermediate,
            )
          : null,
      fitnessGoal: map['fitness_goal'] != null
          ? FitnessGoal.values.firstWhere(
              (e) => e.toString() == map['fitness_goal'] as String,
              orElse: () => FitnessGoal.general,
            )
          : null,
      preferredWorkoutTimes: _parseWorkoutTimes(map['preferred_workout_times'] as String?),
      likesCompetition: map['likes_competition'] != null
          ? (map['likes_competition'] as int) == 1
          : null,
      onboardingCompletedAt: map['onboarding_completed_at'] != null
          ? DateTime.parse(map['onboarding_completed_at'] as String)
          : null,
      chadExperience: map['chad_experience'] as int? ?? 0,
      chadCurrentLevel: map['chad_current_level'] as int? ?? 1,
      chadCurrentStage: map['chad_current_stage'] as int? ?? 0,
      chadTotalLevelUps: map['chad_total_level_ups'] as int? ?? 0,
      chadLastLevelUpAt: map['chad_last_level_up_at'] != null
          ? DateTime.parse(map['chad_last_level_up_at'] as String)
          : null,
    );
  }

  static List<bool>? _parseWorkoutDays(String? workoutDaysStr) {
    if (workoutDaysStr == null || workoutDaysStr.isEmpty) return null;
    try {
      return workoutDaysStr.split(',').map((e) => e.trim() == 'true').toList();
    } catch (e) {
      return null;
    }
  }

  static List<String>? _parseWorkoutTimes(String? workoutTimesStr) {
    if (workoutTimesStr == null || workoutTimesStr.isEmpty) return null;
    try {
      return workoutTimesStr.split(',').map((e) => e.trim()).toList();
    } catch (e) {
      return null;
    }
  }

  UserProfile copyWith({
    int? id,
    UserLevel? level,
    int? initialMaxReps,
    DateTime? startDate,
    int? chadLevel,
    bool? reminderEnabled,
    String? reminderTime,
    TimeOfDay? reminderTimeOfDay,
    List<bool>? workoutDays,
    double? currentWeight,
    double? targetWeight,
    FitnessLevel? fitnessLevel,
    FitnessGoal? fitnessGoal,
    List<String>? preferredWorkoutTimes,
    bool? likesCompetition,
    DateTime? onboardingCompletedAt,
    int? chadExperience,
    int? chadCurrentLevel,
    int? chadCurrentStage,
    int? chadTotalLevelUps,
    DateTime? chadLastLevelUpAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      level: level ?? this.level,
      initialMaxReps: initialMaxReps ?? this.initialMaxReps,
      startDate: startDate ?? this.startDate,
      chadLevel: chadLevel ?? this.chadLevel,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTimeOfDay != null
          ? '${reminderTimeOfDay.hour.toString().padLeft(2, '0')}:${reminderTimeOfDay.minute.toString().padLeft(2, '0')}'
          : (reminderTime ?? this.reminderTime),
      workoutDays: workoutDays ?? this.workoutDays,
      currentWeight: currentWeight ?? this.currentWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      preferredWorkoutTimes: preferredWorkoutTimes ?? this.preferredWorkoutTimes,
      likesCompetition: likesCompetition ?? this.likesCompetition,
      onboardingCompletedAt: onboardingCompletedAt ?? this.onboardingCompletedAt,
      chadExperience: chadExperience ?? this.chadExperience,
      chadCurrentLevel: chadCurrentLevel ?? this.chadCurrentLevel,
      chadCurrentStage: chadCurrentStage ?? this.chadCurrentStage,
      chadTotalLevelUps: chadTotalLevelUps ?? this.chadTotalLevelUps,
      chadLastLevelUpAt: chadLastLevelUpAt ?? this.chadLastLevelUpAt,
    );
  }

  /// reminderTime 문자열을 TimeOfDay로 변환
  TimeOfDay? get reminderTimeOfDay {
    if (reminderTime == null) return null;
    try {
      final parts = reminderTime!.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (e) {
      debugPrint('reminderTime 파싱 오류: $e');
    }
    return null;
  }
}

enum UserLevel {
  rookie, // 초급 (5개 이하)
  rising, // 중급 (6-10개)
  alpha, // 고급 (11-20개)
  giga, // 마스터 (21개 이상)
}

extension UserLevelExtension on UserLevel {
  String get displayName {
    switch (this) {
      case UserLevel.rookie:
        return 'Rookie Chad';
      case UserLevel.rising:
        return 'Rising Chad';
      case UserLevel.alpha:
        return 'Alpha Chad';
      case UserLevel.giga:
        return 'Giga Chad';
    }
  }

  String getDescription(BuildContext context) {
    final isKorean = Localizations.localeOf(context).languageCode == 'ko';
    switch (this) {
      case UserLevel.rookie:
        return isKorean ? '5개 이하 → 100개 달성' : '≤5 reps → Achieve 100';
      case UserLevel.rising:
        return isKorean ? '6-10개 → 100개 달성' : '6-10 reps → Achieve 100';
      case UserLevel.alpha:
        return isKorean ? '11-20개 → 100개 달성' : '11-20 reps → Achieve 100';
      case UserLevel.giga:
        return isKorean ? '21개 이상 → 100개+ 달성' : '21+ reps → Achieve 100+';
    }
  }

  /// UserLevel을 int 값으로 변환 (동기부여 메시지 레벨용)
  int get levelValue {
    switch (this) {
      case UserLevel.rookie:
        return 1;
      case UserLevel.rising:
        return 25;
      case UserLevel.alpha:
        return 50;
      case UserLevel.giga:
        return 75;
    }
  }

  static UserLevel fromMaxReps(int maxReps) {
    if (maxReps <= 5) return UserLevel.rookie;
    if (maxReps <= 10) return UserLevel.rising;
    if (maxReps <= 20) return UserLevel.alpha;
    return UserLevel.giga;
  }
}
