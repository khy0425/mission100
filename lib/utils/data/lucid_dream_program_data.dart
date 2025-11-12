import '../../models/lucid_dream_task.dart';
import '../../models/user_profile.dart';

/// 30일 자각몽 프로그램 데이터
///
/// 과학적 근거:
/// - ILDIS 2020 연구: MILD 기법 46% 성공률
/// - Stumbrys et al. (2012): WBTB + MILD 조합이 가장 효과적
/// - Reality Check: 하루 5회 권장
/// - Dream Journal: 자각몽 성공의 #1 예측 변수
class LucidDreamProgramData {
  /// 기본 매일 수행 태스크
  static const List<LucidDreamTask> _dailyTasks = [
    LucidDreamTask(
      type: LucidDreamTaskType.dreamJournal,
      titleKey: 'taskDreamJournalTitle',
      descriptionKey: 'taskDreamJournalDesc',
      isRequired: true,
      isDaily: true,
    ),
    LucidDreamTask(
      type: LucidDreamTaskType.realityCheck,
      titleKey: 'taskRealityCheckTitle',
      descriptionKey: 'taskRealityCheckDesc',
      isRequired: true,
      isDaily: true,
      targetCount: 5,
    ),
    LucidDreamTask(
      type: LucidDreamTaskType.mildAffirmation,
      titleKey: 'taskMildTitle',
      descriptionKey: 'taskMildDesc',
      isRequired: true,
      isDaily: true,
    ),
    LucidDreamTask(
      type: LucidDreamTaskType.sleepHygiene,
      titleKey: 'taskSleepHygieneTitle',
      descriptionKey: 'taskSleepHygieneDesc',
      isRequired: true,
      isDaily: true,
    ),
  ];

  /// WBTB 태스크 (특정 날짜에만)
  static const LucidDreamTask _wbtbTask = LucidDreamTask(
    type: LucidDreamTaskType.wbtb,
    titleKey: 'taskWbtbTitle',
    descriptionKey: 'taskWbtbDesc',
    isRequired: false, // 선택 사항 (주말 또는 휴일 권장)
    isDaily: false,
  );

  /// 명상 태스크 (선택 사항)
  static const LucidDreamTask _meditationTask = LucidDreamTask(
    type: LucidDreamTaskType.meditation,
    titleKey: 'taskMeditationTitle',
    descriptionKey: 'taskMeditationDesc',
    isRequired: false,
    isDaily: false,
  );

  /// WBTB 권장 요일 (토요일, 일요일)
  /// 사용자가 설정에서 변경 가능
  static const Set<int> defaultWbtbDays = {6, 7}; // 토, 일

  /// 특정 날짜의 체크리스트 생성
  ///
  /// [day]: 1-30 (프로그램 시작 후 경과일)
  /// [level]: 사용자 레벨 (현재는 사용하지 않지만 향후 확장 가능)
  /// [wbtbDaysOfWeek]: WBTB 수행 요일 (1=월, 7=일)
  static DailyLucidDreamChecklist getChecklistForDay(
    int day, {
    UserLevel? level,
    Set<int>? wbtbDaysOfWeek,
  }) {
    if (day < 1 || day > 30) {
      throw ArgumentError('Day must be between 1 and 30, got: $day');
    }

    // 요일 계산 (1=월요일, 7=일요일)
    final dayOfWeek = ((day - 1) % 7) + 1;

    // WBTB 수행일인지 확인
    final wbtbDays = wbtbDaysOfWeek ?? defaultWbtbDays;
    final isWbtbDay = wbtbDays.contains(dayOfWeek);

    // 태스크 리스트 생성
    final tasks = List<LucidDreamTask>.from(_dailyTasks);

    // WBTB 날짜면 WBTB 태스크 추가
    if (isWbtbDay) {
      tasks.add(_wbtbTask);
    }

    // 선택적으로 명상 태스크 추가 (모든 날)
    tasks.add(_meditationTask);

    return DailyLucidDreamChecklist(
      day: day,
      tasks: tasks,
      isWbtbDay: isWbtbDay,
    );
  }

  /// 전체 30일 프로그램 생성
  ///
  /// [level]: 사용자 레벨
  /// [wbtbDaysOfWeek]: WBTB 수행 요일
  /// Returns: 일차별 체크리스트 맵 (1-30)
  static Map<int, DailyLucidDreamChecklist> generateFullProgram({
    UserLevel level = UserLevel.rookie,
    Set<int>? wbtbDaysOfWeek,
  }) {
    final program = <int, DailyLucidDreamChecklist>{};

    for (int day = 1; day <= 30; day++) {
      program[day] = getChecklistForDay(
        day,
        level: level,
        wbtbDaysOfWeek: wbtbDaysOfWeek,
      );
    }

    return program;
  }

  /// 레벨별 초기 설정 (향후 확장 가능)
  ///
  /// Rookie: 기본 체크리스트
  /// Rising: 기본 + WBTB 권장
  /// Alpha: 기본 + WBTB + 명상 권장
  /// Giga: 모든 기법 마스터
  static Map<UserLevel, Set<int>> getLevelSpecificWbtbDays() {
    return {
      UserLevel.rookie: {7}, // 일요일만
      UserLevel.rising: {6, 7}, // 토, 일
      UserLevel.alpha: {5, 6, 7}, // 금, 토, 일
      UserLevel.giga: {1, 2, 3, 4, 5, 6, 7}, // 매일 (고급 사용자)
    };
  }
}
