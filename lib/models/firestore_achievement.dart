enum AchievementType {
  firstWorkout,        // 첫 운동 완료
  weeklyComplete,      // 주차 완료
  streakMilestone,     // 연속 운동 달성
  pushupMilestone,     // 푸시업 개수 달성
  speedRecord,         // 빠른 운동 완료
  perfectionStreak,    // 완벽한 RPE 연속 달성
  totalWorkouts,       // 총 운동 횟수 달성
  timeRecord,          // 시간 기록 달성
  specialEvent,        // 특별 이벤트
}

enum RequirementType {
  count,    // 횟수
  streak,   // 연속
  time,     // 시간
  rpe,      // 체감 강도
}

enum AchievementRarity {
  common,
  rare,
  epic,
  legendary,
}

class AchievementRequirement {
  final RequirementType type;
  final int target;
  final String unit;

  const AchievementRequirement({
    required this.type,
    required this.target,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'target': target,
      'unit': unit,
    };
  }

  factory AchievementRequirement.fromJson(Map<String, dynamic> json) {
    return AchievementRequirement(
      type: RequirementType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => RequirementType.count,
      ),
      target: json['target'] as int,
      unit: json['unit'] as String,
    );
  }
}

class FirestoreAchievement {
  final String id;
  final String userId;
  final AchievementType achievementType;
  final String title;
  final String description;
  final AchievementRequirement requirement;
  final int progress;
  final bool completed;
  final DateTime? completedAt;
  final AchievementRarity rarity;
  final int xpReward;
  final String? badgeUrl;
  final DateTime createdAt;

  const FirestoreAchievement({
    required this.id,
    required this.userId,
    required this.achievementType,
    required this.title,
    required this.description,
    required this.requirement,
    required this.progress,
    required this.completed,
    this.completedAt,
    required this.rarity,
    required this.xpReward,
    this.badgeUrl,
    required this.createdAt,
  });

  // 기본 업적들 생성
  static List<FirestoreAchievement> createDefaultAchievements(String userId) {
    final now = DateTime.now();
    return [
      // 첫 운동 완료
      FirestoreAchievement(
        id: 'first_workout_$userId',
        userId: userId,
        achievementType: AchievementType.firstWorkout,
        title: '🔥 첫 번째 운동 완료!',
        description: '차드의 여정이 시작되었다! 첫 운동을 완료했어!',
        requirement: const AchievementRequirement(
          type: RequirementType.count,
          target: 1,
          unit: 'workout',
        ),
        progress: 0,
        completed: false,
        rarity: AchievementRarity.common,
        xpReward: 100,
        createdAt: now,
      ),

      // 일주일 완료
      FirestoreAchievement(
        id: 'week_complete_$userId',
        userId: userId,
        achievementType: AchievementType.weeklyComplete,
        title: '💪 첫 번째 주 완료!',
        description: '첫 번째 주차를 완벽하게 완주했어! 차드로의 진화가 시작됐다!',
        requirement: const AchievementRequirement(
          type: RequirementType.count,
          target: 1,
          unit: 'week',
        ),
        progress: 0,
        completed: false,
        rarity: AchievementRarity.common,
        xpReward: 300,
        createdAt: now,
      ),

      // 3일 연속 운동
      FirestoreAchievement(
        id: 'streak_3_$userId',
        userId: userId,
        achievementType: AchievementType.streakMilestone,
        title: '⚡ 3일 연속 차드!',
        description: '3일 연속으로 운동했어! 습관이 만들어지고 있다!',
        requirement: const AchievementRequirement(
          type: RequirementType.streak,
          target: 3,
          unit: 'days',
        ),
        progress: 0,
        completed: false,
        rarity: AchievementRarity.common,
        xpReward: 200,
        createdAt: now,
      ),

      // 푸시업 100개 달성
      FirestoreAchievement(
        id: 'pushup_100_$userId',
        userId: userId,
        achievementType: AchievementType.pushupMilestone,
        title: '🚀 푸시업 100개 달성!',
        description: '한 번의 운동에서 총 100개의 푸시업을 완료했다! 진짜 차드다!',
        requirement: const AchievementRequirement(
          type: RequirementType.count,
          target: 100,
          unit: 'pushups',
        ),
        progress: 0,
        completed: false,
        rarity: AchievementRarity.epic,
        xpReward: 1000,
        createdAt: now,
      ),

      // 7일 연속 운동
      FirestoreAchievement(
        id: 'streak_7_$userId',
        userId: userId,
        achievementType: AchievementType.streakMilestone,
        title: '👑 일주일 차드 왕!',
        description: '7일 연속 운동! 이제 진짜 차드의 길로 들어섰어!',
        requirement: const AchievementRequirement(
          type: RequirementType.streak,
          target: 7,
          unit: 'days',
        ),
        progress: 0,
        completed: false,
        rarity: AchievementRarity.rare,
        xpReward: 500,
        createdAt: now,
      ),

      // 빠른 운동 완료 (5분 이내)
      FirestoreAchievement(
        id: 'speed_5min_$userId',
        userId: userId,
        achievementType: AchievementType.speedRecord,
        title: '💨 스피드 차드!',
        description: '5분 이내에 운동을 완료했어! 효율성의 극치다!',
        requirement: const AchievementRequirement(
          type: RequirementType.time,
          target: 300, // 5분 = 300초
          unit: 'seconds',
        ),
        progress: 0,
        completed: false,
        rarity: AchievementRarity.rare,
        xpReward: 400,
        createdAt: now,
      ),

      // 총 운동 20회 달성
      FirestoreAchievement(
        id: 'total_20_$userId',
        userId: userId,
        achievementType: AchievementType.totalWorkouts,
        title: '🏆 20회 운동 마스터!',
        description: '총 20회의 운동을 완료했어! 이제 베테랑이야!',
        requirement: const AchievementRequirement(
          type: RequirementType.count,
          target: 20,
          unit: 'workouts',
        ),
        progress: 0,
        completed: false,
        rarity: AchievementRarity.epic,
        xpReward: 800,
        createdAt: now,
      ),

      // 완벽한 RPE (RPE 8 이상으로 5회 연속)
      FirestoreAchievement(
        id: 'perfect_rpe_$userId',
        userId: userId,
        achievementType: AchievementType.perfectionStreak,
        title: '⭐ 완벽주의자!',
        description: '5회 연속으로 RPE 8 이상을 기록했어! 완벽한 강도 조절이야!',
        requirement: const AchievementRequirement(
          type: RequirementType.streak,
          target: 5,
          unit: 'high_rpe_workouts',
        ),
        progress: 0,
        completed: false,
        rarity: AchievementRarity.legendary,
        xpReward: 1500,
        createdAt: now,
      ),
    ];
  }

  // 진행도 업데이트
  FirestoreAchievement updateProgress(int newProgress) {
    final isNowCompleted = newProgress >= requirement.target;
    return copyWith(
      progress: newProgress,
      completed: isNowCompleted,
      completedAt: isNowCompleted && !completed ? DateTime.now() : completedAt,
    );
  }

  // 완료율 계산
  double get completionRate {
    return progress / requirement.target;
  }

  // 완료 여부 확인
  bool get isCompleted => completed;

  // 희귀도에 따른 색상
  String get rarityColor {
    switch (rarity) {
      case AchievementRarity.common:
        return '#9E9E9E'; // Gray
      case AchievementRarity.rare:
        return '#2196F3'; // Blue
      case AchievementRarity.epic:
        return '#9C27B0'; // Purple
      case AchievementRarity.legendary:
        return '#FF9800'; // Orange
    }
  }

  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'achievementType': achievementType.name,
      'title': title,
      'description': description,
      'requirement': requirement.toJson(),
      'progress': progress,
      'completed': completed,
      'completedAt': completedAt?.toIso8601String(),
      'rarity': rarity.name,
      'xpReward': xpReward,
      'badgeUrl': badgeUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FirestoreAchievement.fromJson(Map<String, dynamic> json) {
    return FirestoreAchievement(
      id: json['id'] as String,
      userId: json['userId'] as String,
      achievementType: AchievementType.values.firstWhere(
        (e) => e.name == json['achievementType'],
        orElse: () => AchievementType.firstWorkout,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      requirement: AchievementRequirement.fromJson(
        json['requirement'] as Map<String, dynamic>,
      ),
      progress: json['progress'] as int,
      completed: json['completed'] as bool,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      rarity: AchievementRarity.values.firstWhere(
        (e) => e.name == json['rarity'],
        orElse: () => AchievementRarity.common,
      ),
      xpReward: json['xpReward'] as int,
      badgeUrl: json['badgeUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  FirestoreAchievement copyWith({
    String? id,
    String? userId,
    AchievementType? achievementType,
    String? title,
    String? description,
    AchievementRequirement? requirement,
    int? progress,
    bool? completed,
    DateTime? completedAt,
    AchievementRarity? rarity,
    int? xpReward,
    String? badgeUrl,
    DateTime? createdAt,
  }) {
    return FirestoreAchievement(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      achievementType: achievementType ?? this.achievementType,
      title: title ?? this.title,
      description: description ?? this.description,
      requirement: requirement ?? this.requirement,
      progress: progress ?? this.progress,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      rarity: rarity ?? this.rarity,
      xpReward: xpReward ?? this.xpReward,
      badgeUrl: badgeUrl ?? this.badgeUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'FirestoreAchievement(id: $id, title: $title, progress: $progress/${requirement.target}, completed: $completed)';
  }
}