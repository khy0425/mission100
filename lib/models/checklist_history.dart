class ChecklistHistory {
  final String id;
  final DateTime date;
  final int dayNumber;
  final List<String> completedTasks; // LucidDreamTaskType enum values as strings
  final int totalTasksCompleted;
  final int totalRequiredTasks;
  final double completionRate;
  final Duration duration;
  final bool isWbtbDay;

  ChecklistHistory({
    required this.id,
    required this.date,
    required this.dayNumber,
    required this.completedTasks,
    required this.totalTasksCompleted,
    required this.totalRequiredTasks,
    required this.completionRate,
    required this.duration,
    required this.isWbtbDay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'dayNumber': dayNumber,
      'completedTasks': completedTasks.join(','),
      'totalTasksCompleted': totalTasksCompleted,
      'totalRequiredTasks': totalRequiredTasks,
      'completionRate': completionRate,
      'duration': duration.inMinutes,
      'isWbtbDay': isWbtbDay ? 1 : 0,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'dayNumber': dayNumber,
      'completedTasks': completedTasks,
      'totalTasksCompleted': totalTasksCompleted,
      'totalRequiredTasks': totalRequiredTasks,
      'completionRate': completionRate,
      'duration': duration.inSeconds,
      'isWbtbDay': isWbtbDay,
    };
  }

  factory ChecklistHistory.fromMap(Map<String, dynamic> map) {
    return ChecklistHistory(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      dayNumber: map['dayNumber'] as int,
      completedTasks: (map['completedTasks'] as String)
          .split(',')
          .where((s) => s.isNotEmpty)
          .toList(),
      totalTasksCompleted: map['totalTasksCompleted'] as int,
      totalRequiredTasks: map['totalRequiredTasks'] as int,
      completionRate: map['completionRate'] as double,
      duration: Duration(minutes: map['duration'] as int? ?? 0),
      isWbtbDay: (map['isWbtbDay'] as int? ?? 0) == 1,
    );
  }

  /// Get performance level based on completion rate
  String getPerformanceLevel() {
    if (completionRate >= 1.0) return 'perfect';
    if (completionRate >= 0.8) return 'good';
    if (completionRate >= 0.6) return 'okay';
    return 'incomplete';
  }

  /// Get display color based on performance
  String getPerformanceColor() {
    final level = getPerformanceLevel();
    switch (level) {
      case 'perfect':
        return '#9C27B0'; // Purple
      case 'good':
        return '#7B1FA2'; // Dark purple
      case 'okay':
        return '#BA68C8'; // Light purple
      default:
        return '#E1BEE7'; // Very light purple
    }
  }
}
