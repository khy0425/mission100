/// Mission100 운동 타입
enum ExerciseType {
  /// 푸시업 (Push-up) - 메인 운동
  pushup,
}

/// 운동 타입별 정보
class ExerciseInfo {
  final ExerciseType type;

  ExerciseInfo(this.type);

  /// 운동 이름 (한글)
  String get nameKo => '푸시업';

  /// 운동 이름 (영어)
  String get nameEn => 'Push-up';

  /// 운동 설명 (한글)
  String get descriptionKo =>
      '상체 근력을 키우는 기본 운동으로 가슴, 어깨, 삼두근을 강화합니다. '
      '14주 프로그램을 통해 연속 100개 달성을 목표로 합니다.';

  /// 운동 아이콘
  String get icon => '💪';
}
