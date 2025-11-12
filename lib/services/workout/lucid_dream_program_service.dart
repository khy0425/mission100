import '../../models/user_profile.dart';
import '../../models/lucid_dream_task.dart';
import '../../utils/data/lucid_dream_program_data.dart';
import 'package:flutter/foundation.dart';

/// 30일 자각몽 프로그램 관리 서비스
///
/// WorkoutProgramService의 체크리스트 버전
/// 푸시업 세트/횟수 대신 매일 수행할 자각몽 훈련 태스크 체크리스트를 제공
class LucidDreamProgramService {
  /// 사용자 레벨에 따른 완전한 30일 프로그램 생성
  ///
  /// [level] - 사용자의 현재 레벨 (Rookie, Rising, Alpha, Giga)
  /// [wbtbDaysOfWeek] - WBTB 수행 요일 설정 (선택적)
  /// Returns: 일차 -> 체크리스트 맵
  Map<int, DailyLucidDreamChecklist> generateProgram({
    UserLevel level = UserLevel.rookie,
    Set<int>? wbtbDaysOfWeek,
  }) {
    return LucidDreamProgramData.generateFullProgram(
      level: level,
      wbtbDaysOfWeek: wbtbDaysOfWeek,
    );
  }

  /// 특정 일차의 체크리스트 가져오기
  ///
  /// [day] - 일차 (1-30)
  /// [level] - 사용자 레벨
  /// [wbtbDaysOfWeek] - WBTB 수행 요일 (선택적)
  /// Returns: 일일 체크리스트 또는 null
  DailyLucidDreamChecklist? getChecklistForDay(
    int day, {
    UserLevel? level,
    Set<int>? wbtbDaysOfWeek,
  }) {
    if (day < 1 || day > 30) {
      debugPrint('❌ Invalid day: $day (must be 1-30)');
      return null;
    }

    try {
      return LucidDreamProgramData.getChecklistForDay(
        day,
        level: level,
        wbtbDaysOfWeek: wbtbDaysOfWeek,
      );
    } catch (e) {
      debugPrint('❌ Error getting checklist for day $day: $e');
      return null;
    }
  }

  /// 현재 날짜를 기준으로 오늘의 체크리스트 가져오기
  ///
  /// [userProfile] - 사용자 프로필 (시작 날짜 포함)
  /// Returns: 오늘의 체크리스트 정보 또는 null (프로그램 완료)
  TodayChecklist? getTodayChecklist(UserProfile userProfile) {
    final startDate = userProfile.startDate;
    final today = DateTime.now();
    final daysSinceStart = today.difference(startDate).inDays + 1; // 1-based

    debugPrint('🌙 getTodayChecklist 시작');
    debugPrint('📅 시작일: $startDate');
    debugPrint('📅 오늘: $today');
    debugPrint('📅 시작한지 $daysSinceStart일 경과');

    // 프로그램 완료 확인 (30일 초과)
    if (daysSinceStart > 30) {
      debugPrint('✅ 프로그램 완료 (30일 초과)');
      return null; // 프로그램 완료
    }

    // 체크리스트 가져오기
    final checklist = getChecklistForDay(
      daysSinceStart,
      level: userProfile.level,
    );

    if (checklist == null) {
      debugPrint('❌ 체크리스트 데이터가 없음 (일차: $daysSinceStart)');
      return null;
    }

    debugPrint('✅ 오늘의 체크리스트 찾음: ${checklist.day}일차');
    debugPrint('   필수 태스크: ${checklist.requiredTaskCount}개');
    debugPrint('   선택 태스크: ${checklist.optionalTaskCount}개');
    debugPrint('   WBTB 날: ${checklist.isWbtbDay}');

    return TodayChecklist(
      day: checklist.day,
      checklist: checklist,
      daysSinceStart: daysSinceStart,
    );
  }

  /// 사용자의 30일 프로그램 진행 상황 계산
  ///
  /// [userProfile] - 사용자 프로필
  /// [completedDays] - 완료된 일수 (외부에서 제공, 추후 DB 연동)
  /// Returns: 프로그램 진행 상황 정보
  LucidDreamProgress getProgress(
    UserProfile userProfile, {
    int completedDays = 0,
  }) {
    final startDate = userProfile.startDate;
    final today = DateTime.now();
    final daysSinceStart = today.difference(startDate).inDays + 1;

    final currentDay = daysSinceStart.clamp(1, 30);
    final progressPercentage = (completedDays / 30).clamp(0.0, 1.0);
    final isCompleted = completedDays >= 30;

    return LucidDreamProgress(
      currentDay: currentDay,
      completedDays: completedDays,
      totalDays: 30,
      progressPercentage: progressPercentage,
      isCompleted: isCompleted,
    );
  }

  /// 프로그램의 총 필수 태스크 수 계산 (30일 전체)
  ///
  /// [level] - 사용자 레벨
  /// Returns: 총 필수 태스크 수
  int getTotalRequiredTasks({UserLevel level = UserLevel.rookie}) {
    final program = generateProgram(level: level);
    return program.values.fold<int>(
      0,
      (sum, checklist) => sum + checklist.requiredTaskCount,
    );
  }

  /// 특정 일차의 필수 태스크 수
  int getRequiredTasksForDay(int day, {UserLevel? level}) {
    final checklist = getChecklistForDay(day, level: level);
    return checklist?.requiredTaskCount ?? 0;
  }
}

/// 오늘의 체크리스트 정보를 담는 클래스
class TodayChecklist {
  final int day; // 1-30
  final DailyLucidDreamChecklist checklist;
  final int daysSinceStart;

  const TodayChecklist({
    required this.day,
    required this.checklist,
    required this.daysSinceStart,
  });

  /// 필수 태스크 수
  int get requiredTaskCount => checklist.requiredTaskCount;

  /// 선택 태스크 수
  int get optionalTaskCount => checklist.optionalTaskCount;

  /// 전체 태스크 수
  int get totalTaskCount => checklist.tasks.length;

  /// WBTB 수행일 여부
  bool get isWbtbDay => checklist.isWbtbDay;

  /// 체크리스트 제목
  String get title => 'Day $day';

  /// 체크리스트 설명
  String get description {
    final required = requiredTaskCount;
    final optional = optionalTaskCount;
    final wbtb = isWbtbDay ? ' (WBTB Day)' : '';
    return '필수 $required개, 선택 $optional개$wbtb';
  }

  @override
  String toString() {
    return 'TodayChecklist(day: $day, required: $requiredTaskCount, optional: $optionalTaskCount, wbtb: $isWbtbDay)';
  }
}

/// 자각몽 프로그램 진행 상황 정보를 담는 클래스
class LucidDreamProgress {
  final int currentDay; // 1-30
  final int completedDays; // 실제로 완료한 일수
  final int totalDays; // 30
  final double progressPercentage; // 0.0 - 1.0
  final bool isCompleted;

  const LucidDreamProgress({
    required this.currentDay,
    required this.completedDays,
    required this.totalDays,
    required this.progressPercentage,
    required this.isCompleted,
  });

  /// 남은 일수
  int get remainingDays => totalDays - completedDays;

  /// 진행 상태 텍스트
  String get statusText {
    if (isCompleted) {
      return '🎉 30일 프로그램 완료!';
    } else {
      return '$completedDays/$totalDays일 완료';
    }
  }

  /// 완료율 퍼센트 (0-100)
  int get completionPercent => (progressPercentage * 100).round();

  @override
  String toString() {
    return 'LucidDreamProgress(day: $currentDay, completed: $completedDays/$totalDays, ${(progressPercentage * 100).toStringAsFixed(1)}%)';
  }
}
