/// Mission Push-Up 100 운동 타입
enum ExerciseType {
  /// 푸시업 (Push-Up) - 메인 운동
  pushup,
}

/// 운동 정보
class ExerciseInfo {
  final ExerciseType type;

  ExerciseInfo(this.type);

  /// 운동 이름 (한글)
  String get nameKo => '푸시업';

  /// 운동 이름 (영어)
  String get nameEn => 'Push-Up';

  /// 운동 설명 (한글)
  String get descriptionKo =>
      '가슴과 삼두근을 강화하는 상체 운동 '
      '60일 프로그램을 통해 자각몽 마스터를 목표로 합니다.';

  /// 운동 아이콘
  String get icon => '💪';
}
