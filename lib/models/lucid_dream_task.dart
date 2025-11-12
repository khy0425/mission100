/// 자각몽 훈련 태스크 유형
enum LucidDreamTaskType {
  /// 꿈 일기 작성 (매일 아침)
  dreamJournal,

  /// 현실 확인 (하루 5회)
  realityCheck,

  /// MILD 확언 (취침 전)
  mildAffirmation,

  /// 수면 위생 체크
  sleepHygiene,

  /// WBTB (Wake Back To Bed) - 선택 일
  wbtb,

  /// 명상 (선택 사항)
  meditation,
}

/// 자각몽 훈련 태스크
class LucidDreamTask {
  final LucidDreamTaskType type;
  final String titleKey; // 로컬라이제이션 키
  final String descriptionKey; // 로컬라이제이션 키
  final bool isRequired; // 필수 여부
  final bool isDaily; // 매일 수행 여부
  final int? targetCount; // 목표 횟수 (Reality Check 등)

  const LucidDreamTask({
    required this.type,
    required this.titleKey,
    required this.descriptionKey,
    this.isRequired = true,
    this.isDaily = true,
    this.targetCount,
  });
}

/// 일일 자각몽 체크리스트
class DailyLucidDreamChecklist {
  final int day; // 1-30
  final List<LucidDreamTask> tasks;
  final bool isWbtbDay; // WBTB 수행일 여부

  const DailyLucidDreamChecklist({
    required this.day,
    required this.tasks,
    this.isWbtbDay = false,
  });

  /// 필수 태스크 개수
  int get requiredTaskCount => tasks.where((t) => t.isRequired).length;

  /// 선택 태스크 개수
  int get optionalTaskCount => tasks.where((t) => !t.isRequired).length;
}
