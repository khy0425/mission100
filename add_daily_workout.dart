import 'dart:io';

void main() {
  final file = File('lib/utils/workout_data.dart');
  var content = file.readAsStringSync();

  // DailyWorkout 클래스 추가
  final dailyWorkoutClass = '''

/// 일일 워크아웃 정보
class DailyWorkout {
  final int burpees;
  final int pushups;

  const DailyWorkout({required this.burpees, required this.pushups});

  int get totalReps => burpees + pushups;

  @override
  String toString() => 'DailyWorkout(burpees: \$burpees, pushups: \$pushups)';
}
''';

  // ExerciseSet 클래스 다음에 DailyWorkout 추가
  if (!content.contains('class DailyWorkout')) {
    content = content.replaceFirst(
      'class WorkoutData {',
      '$dailyWorkoutClass\nclass WorkoutData {',
    );
  }

  file.writeAsStringSync(content);
  print('✅ DailyWorkout 클래스 추가 완료');
}
