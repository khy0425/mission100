class CompletedWorkout {
  final int week;
  final int day;
  final DateTime completedAt;
  final String recordId;

  const CompletedWorkout({
    required this.week,
    required this.day,
    required this.completedAt,
    required this.recordId,
  });

  Map<String, dynamic> toJson() {
    return {
      'week': week,
      'day': day,
      'completedAt': completedAt.toIso8601String(),
      'recordId': recordId,
    };
  }

  factory CompletedWorkout.fromJson(Map<String, dynamic> json) {
    return CompletedWorkout(
      week: json['week'] as int,
      day: json['day'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
      recordId: json['recordId'] as String,
    );
  }
}

class WeeklyStats {
  final int week;
  final int totalPushups;
  final double averageRpe;
  final double completionRate; // 완료율 (0-1)
  final double improvementRate; // 향상률

  const WeeklyStats({
    required this.week,
    required this.totalPushups,
    required this.averageRpe,
    required this.completionRate,
    required this.improvementRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'week': week,
      'totalPushups': totalPushups,
      'averageRpe': averageRpe,
      'completionRate': completionRate,
      'improvementRate': improvementRate,
    };
  }

  factory WeeklyStats.fromJson(Map<String, dynamic> json) {
    return WeeklyStats(
      week: json['week'] as int,
      totalPushups: json['totalPushups'] as int,
      averageRpe: (json['averageRpe'] as num).toDouble(),
      completionRate: (json['completionRate'] as num).toDouble(),
      improvementRate: (json['improvementRate'] as num).toDouble(),
    );
  }
}

class PersonalBests {
  final int maxPushupsInSet;
  final int maxPushupsInWorkout;
  final int fastestWorkout; // 초
  final double lowestAverageRpe;

  const PersonalBests({
    required this.maxPushupsInSet,
    required this.maxPushupsInWorkout,
    required this.fastestWorkout,
    required this.lowestAverageRpe,
  });

  Map<String, dynamic> toJson() {
    return {
      'maxPushupsInSet': maxPushupsInSet,
      'maxPushupsInWorkout': maxPushupsInWorkout,
      'fastestWorkout': fastestWorkout,
      'lowestAverageRpe': lowestAverageRpe,
    };
  }

  factory PersonalBests.fromJson(Map<String, dynamic> json) {
    return PersonalBests(
      maxPushupsInSet: json['maxPushupsInSet'] as int,
      maxPushupsInWorkout: json['maxPushupsInWorkout'] as int,
      fastestWorkout: json['fastestWorkout'] as int,
      lowestAverageRpe: (json['lowestAverageRpe'] as num).toDouble(),
    );
  }

  PersonalBests copyWith({
    int? maxPushupsInSet,
    int? maxPushupsInWorkout,
    int? fastestWorkout,
    double? lowestAverageRpe,
  }) {
    return PersonalBests(
      maxPushupsInSet: maxPushupsInSet ?? this.maxPushupsInSet,
      maxPushupsInWorkout: maxPushupsInWorkout ?? this.maxPushupsInWorkout,
      fastestWorkout: fastestWorkout ?? this.fastestWorkout,
      lowestAverageRpe: lowestAverageRpe ?? this.lowestAverageRpe,
    );
  }
}

class StreakData {
  final int current;
  final int longest;
  final DateTime lastWorkoutDate;

  const StreakData({
    required this.current,
    required this.longest,
    required this.lastWorkoutDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'current': current,
      'longest': longest,
      'lastWorkoutDate': lastWorkoutDate.toIso8601String(),
    };
  }

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      current: json['current'] as int,
      longest: json['longest'] as int,
      lastWorkoutDate: DateTime.parse(json['lastWorkoutDate'] as String),
    );
  }

  StreakData copyWith({
    int? current,
    int? longest,
    DateTime? lastWorkoutDate,
  }) {
    return StreakData(
      current: current ?? this.current,
      longest: longest ?? this.longest,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
    );
  }
}

class WorkoutProgress {
  final String userId;
  final int currentWeek;
  final int currentDay;
  final List<int> unlockedWeeks;
  final List<CompletedWorkout> completedWorkouts;
  final List<WeeklyStats> weeklyStats;
  final PersonalBests personalBests;
  final StreakData streakData;
  final DateTime? nextWorkoutDate;
  final DateTime lastSyncAt;
  final DateTime updatedAt;

  const WorkoutProgress({
    required this.userId,
    required this.currentWeek,
    required this.currentDay,
    required this.unlockedWeeks,
    required this.completedWorkouts,
    required this.weeklyStats,
    required this.personalBests,
    required this.streakData,
    this.nextWorkoutDate,
    required this.lastSyncAt,
    required this.updatedAt,
  });

  // 초기 진행 상황 생성
  static WorkoutProgress createInitial(String userId) {
    final now = DateTime.now();
    return WorkoutProgress(
      userId: userId,
      currentWeek: 1,
      currentDay: 1,
      unlockedWeeks: [1],
      completedWorkouts: [],
      weeklyStats: [],
      personalBests: const PersonalBests(
        maxPushupsInSet: 0,
        maxPushupsInWorkout: 0,
        fastestWorkout: 0,
        lowestAverageRpe: 10.0,
      ),
      streakData: StreakData(
        current: 0,
        longest: 0,
        lastWorkoutDate: now,
      ),
      lastSyncAt: now,
      updatedAt: now,
    );
  }

  // 운동 완료 처리
  WorkoutProgress completeWorkout({
    required String recordId,
    required int totalReps,
    required int workoutTime,
    required double averageRpe,
    required int maxRepsInSet,
  }) {
    final now = DateTime.now();
    final newCompletedWorkout = CompletedWorkout(
      week: currentWeek,
      day: currentDay,
      completedAt: now,
      recordId: recordId,
    );

    // 개인 기록 업데이트
    final updatedPersonalBests = personalBests.copyWith(
      maxPushupsInSet: maxRepsInSet > personalBests.maxPushupsInSet
          ? maxRepsInSet
          : personalBests.maxPushupsInSet,
      maxPushupsInWorkout: totalReps > personalBests.maxPushupsInWorkout
          ? totalReps
          : personalBests.maxPushupsInWorkout,
      fastestWorkout: personalBests.fastestWorkout == 0 ||
              workoutTime < personalBests.fastestWorkout
          ? workoutTime
          : personalBests.fastestWorkout,
      lowestAverageRpe: averageRpe < personalBests.lowestAverageRpe
          ? averageRpe
          : personalBests.lowestAverageRpe,
    );

    // 연속 기록 업데이트
    final daysSinceLastWorkout =
        now.difference(streakData.lastWorkoutDate).inDays;
    final newCurrent = daysSinceLastWorkout <= 1 ? streakData.current + 1 : 1;
    final updatedStreakData = streakData.copyWith(
      current: newCurrent,
      longest:
          newCurrent > streakData.longest ? newCurrent : streakData.longest,
      lastWorkoutDate: now,
    );

    // 다음 운동일/주차 계산
    int nextWeek = currentWeek;
    int nextDay = currentDay;
    final List<int> newUnlockedWeeks = List.from(unlockedWeeks);

    if (currentDay == 3) {
      // 한 주 완료 시 다음 주로
      nextWeek = currentWeek + 1;
      nextDay = 1;
      if (!newUnlockedWeeks.contains(nextWeek)) {
        newUnlockedWeeks.add(nextWeek);
      }
    } else {
      nextDay = currentDay + 1;
    }

    return copyWith(
      currentWeek: nextWeek,
      currentDay: nextDay,
      unlockedWeeks: newUnlockedWeeks,
      completedWorkouts: [...completedWorkouts, newCompletedWorkout],
      personalBests: updatedPersonalBests,
      streakData: updatedStreakData,
      updatedAt: now,
    );
  }

  // 특정 주차가 해금되었는지 확인
  bool isWeekUnlocked(int week) {
    return unlockedWeeks.contains(week);
  }

  // 특정 운동일이 완료되었는지 확인
  bool isWorkoutCompleted(int week, int day) {
    return completedWorkouts.any((w) => w.week == week && w.day == day);
  }

  // 전체 완료율 계산
  double get overallCompletionRate {
    if (completedWorkouts.isEmpty) return 0.0;
    final totalExpectedWorkouts = (currentWeek - 1) * 3 + currentDay - 1;
    return totalExpectedWorkouts > 0
        ? completedWorkouts.length / totalExpectedWorkouts
        : 0.0;
  }

  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentWeek': currentWeek,
      'currentDay': currentDay,
      'unlockedWeeks': unlockedWeeks,
      'completedWorkouts': completedWorkouts.map((w) => w.toJson()).toList(),
      'weeklyStats': weeklyStats.map((s) => s.toJson()).toList(),
      'personalBests': personalBests.toJson(),
      'streakData': streakData.toJson(),
      'nextWorkoutDate': nextWorkoutDate?.toIso8601String(),
      'lastSyncAt': lastSyncAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory WorkoutProgress.fromJson(Map<String, dynamic> json) {
    return WorkoutProgress(
      userId: json['userId'] as String,
      currentWeek: json['currentWeek'] as int,
      currentDay: json['currentDay'] as int,
      unlockedWeeks: List<int>.from(json['unlockedWeeks'] as List),
      completedWorkouts: (json['completedWorkouts'] as List)
          .map((w) => CompletedWorkout.fromJson(w as Map<String, dynamic>))
          .toList(),
      weeklyStats: (json['weeklyStats'] as List)
          .map((s) => WeeklyStats.fromJson(s as Map<String, dynamic>))
          .toList(),
      personalBests:
          PersonalBests.fromJson(json['personalBests'] as Map<String, dynamic>),
      streakData:
          StreakData.fromJson(json['streakData'] as Map<String, dynamic>),
      nextWorkoutDate: json['nextWorkoutDate'] != null
          ? DateTime.parse(json['nextWorkoutDate'] as String)
          : null,
      lastSyncAt: DateTime.parse(json['lastSyncAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  WorkoutProgress copyWith({
    String? userId,
    int? currentWeek,
    int? currentDay,
    List<int>? unlockedWeeks,
    List<CompletedWorkout>? completedWorkouts,
    List<WeeklyStats>? weeklyStats,
    PersonalBests? personalBests,
    StreakData? streakData,
    DateTime? nextWorkoutDate,
    DateTime? lastSyncAt,
    DateTime? updatedAt,
  }) {
    return WorkoutProgress(
      userId: userId ?? this.userId,
      currentWeek: currentWeek ?? this.currentWeek,
      currentDay: currentDay ?? this.currentDay,
      unlockedWeeks: unlockedWeeks ?? this.unlockedWeeks,
      completedWorkouts: completedWorkouts ?? this.completedWorkouts,
      weeklyStats: weeklyStats ?? this.weeklyStats,
      personalBests: personalBests ?? this.personalBests,
      streakData: streakData ?? this.streakData,
      nextWorkoutDate: nextWorkoutDate ?? this.nextWorkoutDate,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'WorkoutProgress(userId: $userId, currentWeek: $currentWeek, currentDay: $currentDay, completed: ${completedWorkouts.length})';
  }
}
