enum SyncStatus {
  pending,
  synced,
  conflict,
}

class WorkoutSet {
  final int setNumber;
  final int targetReps;
  final int actualReps;
  final int rpe; // Rate of Perceived Exertion (1-10)
  final int restTime; // 휴식 시간 (초)
  final int? formQuality; // 폼 품질 (1-10)
  final DateTime completedAt;

  const WorkoutSet({
    required this.setNumber,
    required this.targetReps,
    required this.actualReps,
    required this.rpe,
    required this.restTime,
    this.formQuality,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'setNumber': setNumber,
      'targetReps': targetReps,
      'actualReps': actualReps,
      'rpe': rpe,
      'restTime': restTime,
      'formQuality': formQuality,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      setNumber: json['setNumber'] as int,
      targetReps: json['targetReps'] as int,
      actualReps: json['actualReps'] as int,
      rpe: json['rpe'] as int,
      restTime: json['restTime'] as int,
      formQuality: json['formQuality'] as int?,
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }
}

class DeviceInfo {
  final String platform;
  final String version;
  final String model;

  const DeviceInfo({
    required this.platform,
    required this.version,
    required this.model,
  });

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'version': version,
      'model': model,
    };
  }

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      platform: json['platform'] as String,
      version: json['version'] as String,
      model: json['model'] as String,
    );
  }
}

class WorkoutRecord {
  final String id;
  final String userId;
  final DateTime date;
  final int week;
  final int day;
  final String exerciseType;
  final List<WorkoutSet> sets;
  final int totalReps;
  final int totalTime; // 총 소요 시간 (초)
  final double averageRpe;
  final bool workoutCompleted;
  final List<String> chadMessages;
  final DeviceInfo? deviceInfo;
  final SyncStatus syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkoutRecord({
    required this.id,
    required this.userId,
    required this.date,
    required this.week,
    required this.day,
    required this.exerciseType,
    required this.sets,
    required this.totalReps,
    required this.totalTime,
    required this.averageRpe,
    required this.workoutCompleted,
    required this.chadMessages,
    this.deviceInfo,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  // 새 운동 기록 생성
  static WorkoutRecord create({
    required String userId,
    required int week,
    required int day,
    String exerciseType = 'pushup',
  }) {
    final now = DateTime.now();
    return WorkoutRecord(
      id: 'workout_${userId}_${week}_${day}_${now.millisecondsSinceEpoch}',
      userId: userId,
      date: now,
      week: week,
      day: day,
      exerciseType: exerciseType,
      sets: [],
      totalReps: 0,
      totalTime: 0,
      averageRpe: 0,
      workoutCompleted: false,
      chadMessages: [],
      syncStatus: SyncStatus.pending,
      createdAt: now,
      updatedAt: now,
    );
  }

  // 세트 추가
  WorkoutRecord addSet(WorkoutSet workoutSet) {
    final newSets = [...sets, workoutSet];
    final newTotalReps = totalReps + workoutSet.actualReps;
    final newAverageRpe = newSets.map((s) => s.rpe).reduce((a, b) => a + b) / newSets.length;

    return copyWith(
      sets: newSets,
      totalReps: newTotalReps,
      averageRpe: newAverageRpe,
      updatedAt: DateTime.now(),
    );
  }

  // Chad 메시지 추가
  WorkoutRecord addChadMessage(String message) {
    return copyWith(
      chadMessages: [...chadMessages, message],
      updatedAt: DateTime.now(),
    );
  }

  // 운동 완료 처리
  WorkoutRecord complete(int totalWorkoutTime) {
    return copyWith(
      workoutCompleted: true,
      totalTime: totalWorkoutTime,
      updatedAt: DateTime.now(),
    );
  }

  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'week': week,
      'day': day,
      'exerciseType': exerciseType,
      'sets': sets.map((s) => s.toJson()).toList(),
      'totalReps': totalReps,
      'totalTime': totalTime,
      'averageRpe': averageRpe,
      'workoutCompleted': workoutCompleted,
      'chadMessages': chadMessages,
      'deviceInfo': deviceInfo?.toJson(),
      'syncStatus': syncStatus.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory WorkoutRecord.fromJson(Map<String, dynamic> json) {
    return WorkoutRecord(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      week: json['week'] as int,
      day: json['day'] as int,
      exerciseType: json['exerciseType'] as String,
      sets: (json['sets'] as List)
          .map((s) => WorkoutSet.fromJson(s as Map<String, dynamic>))
          .toList(),
      totalReps: json['totalReps'] as int,
      totalTime: json['totalTime'] as int,
      averageRpe: (json['averageRpe'] as num).toDouble(),
      workoutCompleted: json['workoutCompleted'] as bool,
      chadMessages: List<String>.from(json['chadMessages'] as List),
      deviceInfo: json['deviceInfo'] != null
          ? DeviceInfo.fromJson(json['deviceInfo'] as Map<String, dynamic>)
          : null,
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == json['syncStatus'],
        orElse: () => SyncStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  WorkoutRecord copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? week,
    int? day,
    String? exerciseType,
    List<WorkoutSet>? sets,
    int? totalReps,
    int? totalTime,
    double? averageRpe,
    bool? workoutCompleted,
    List<String>? chadMessages,
    DeviceInfo? deviceInfo,
    SyncStatus? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      week: week ?? this.week,
      day: day ?? this.day,
      exerciseType: exerciseType ?? this.exerciseType,
      sets: sets ?? this.sets,
      totalReps: totalReps ?? this.totalReps,
      totalTime: totalTime ?? this.totalTime,
      averageRpe: averageRpe ?? this.averageRpe,
      workoutCompleted: workoutCompleted ?? this.workoutCompleted,
      chadMessages: chadMessages ?? this.chadMessages,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'WorkoutRecord(id: $id, week: $week, day: $day, totalReps: $totalReps, completed: $workoutCompleted)';
  }
}