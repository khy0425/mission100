/// Mission100 운동 타입
enum ExerciseType {
  /// 버피 (Burpee)
  burpee,

  /// 푸시업 (Push-up)
  pushup,
}

/// 운동 타입별 정보
class ExerciseInfo {
  final ExerciseType type;

  ExerciseInfo(this.type);

  /// 운동 이름 (한글)
  String get nameKo {
    switch (type) {
      case ExerciseType.burpee:
        return '버피';
      case ExerciseType.pushup:
        return '푸시업';
    }
  }

  /// 운동 이름 (영어)
  String get nameEn {
    switch (type) {
      case ExerciseType.burpee:
        return 'Burpee';
      case ExerciseType.pushup:
        return 'Push-up';
    }
  }

  /// 운동 설명 (한글)
  String get descriptionKo {
    switch (type) {
      case ExerciseType.burpee:
        return '전신 유산소 운동으로 심폐지구력과 근력을 동시에 향상시킵니다.';
      case ExerciseType.pushup:
        return '상체 근력을 키우는 기본 운동으로 가슴, 어깨, 삼두근을 강화합니다.';
    }
  }

  /// 운동 아이콘
  String get icon {
    switch (type) {
      case ExerciseType.burpee:
        return '🏃';
      case ExerciseType.pushup:
        return '💪';
    }
  }
}
