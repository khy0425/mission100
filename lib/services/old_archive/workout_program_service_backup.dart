import '../models/user_profile.dart';
import '../models/workout_session.dart';
import '../models/exercise_type.dart';
import '../utils/workout_data.dart';
import 'database_service.dart';
import 'rpe_adaptation_service.dart';
import 'package:flutter/foundation.dart';

/// 사용자 레벨에 따른 6주 워크아웃 프로그램 생성 및 관리 서비스
class WorkoutProgramService {
  final DatabaseService _databaseService = DatabaseService();
  final RPEAdaptationService _rpeService = RPEAdaptationService();

  /// 사용자 레벨에 따른 완전한 6주 워크아웃 프로그램 생성
  ///
  /// [level] - 사용자의 현재 레벨 (Rookie, Rising, Alpha, Giga)
  /// Returns: 주차 -> 일차 -> 세트별 횟수 맵
  Map<int, Map<int, List<int>>> generateProgram(UserLevel level) {
    final programs = WorkoutData.workoutPrograms;
    final program = programs[level];
    if (program == null) {
      throw ArgumentError('Invalid user level: $level');
    }
    return Map<int, Map<int, List<int>>>.from(
      program.map((key, value) => MapEntry(
        key,
        Map<int, List<int>>.from(value),
      )),
    );
  }

  /// 특정 주차, 일차의 워크아웃 가져오기
  ///
  /// [level] - 사용자 레벨
  /// [week] - 주차 (1-6)
  /// [day] - 일차 (1-3)
  /// Returns: 세트별 횟수 리스트 또는 null
  List<ExerciseSet>? getWorkoutForDay(UserLevel level, int week, int day) {
    if (week < 1 || week > 6 || day < 1 || day > 3) {
      throw ArgumentError('Invalid week ($week) or day ($day)');
    }
    final dailyWorkout = WorkoutData.getWorkout(level, week, day);
    return dailyWorkout?.toSets();
  }

  /// 특정 워크아웃의 총 횟수 계산
  int getTotalRepsForWorkout(List<int> workout) {
    // List<int> workout is reps, so sum directly
    return workout.fold<int>(0, (sum, reps) => sum + reps);
  }

  /// 주차별 총 운동량 계산
  int getTotalRepsForWeek(UserLevel level, int week) {
    if (week < 1 || week > 6) {
      throw ArgumentError('Invalid week: $week');
    }
    return WorkoutData.getWeeklyTotal(level, week);
  }

  /// 전체 6주 프로그램의 총 운동량 계산
  int getTotalRepsForProgram(UserLevel level) {
    return WorkoutData.getProgramTotal(level);
  }

  /// 현재 날짜를 기준으로 오늘의 워크아웃 가져오기 (RPE 적응 포함)
  ///
  /// [userProfile] - 사용자 프로필 (시작 날짜 포함)
  /// Returns: 오늘의 워크아웃 정보 또는 null (프로그램 완료/휴식일)
  Future<TodayWorkout?> getTodayWorkout(UserProfile userProfile) async {
    final startDate = userProfile.startDate;
    final today = DateTime.now();
    final daysSinceStart = today.difference(startDate).inDays;

    debugPrint('🏃 getTodayWorkout 시작');
    debugPrint('📅 시작일: $startDate');
    debugPrint('📅 오늘: $today');
    debugPrint('📅 시작한지 $daysSinceStart일 경과');

    // 프로그램 완료 확인 (18일 = 6주 * 3일)
    if (daysSinceStart >= 18) {
      debugPrint('✅ 프로그램 완료 (18일 초과)');
      return null; // 프로그램 완료
    }

    // 주차와 일차 계산
    final weekIndex = daysSinceStart ~/ 7; // 0-based week index
    final dayInWeek = daysSinceStart % 7;

    debugPrint('📊 주차 인덱스: $weekIndex (${weekIndex + 1}주차)');
    debugPrint('📊 주 내 일차: $dayInWeek');

    // 운동일 확인 (월, 수, 금 = 0, 2, 4일차)
    final workoutDayMapping = {0: 1, 2: 2, 4: 3}; // 주 내 일차 -> 운동 일차
    final workoutDay = workoutDayMapping[dayInWeek];

    debugPrint('📊 운동일 매핑: $dayInWeek -> $workoutDay');

    if (workoutDay == null) {
      debugPrint('🛌 오늘은 휴식일 (화, 목, 토, 일)');
      return null; // 휴식일 (화, 목, 토, 일)
    }

    final week = weekIndex + 1; // 1-based week
    debugPrint('📊 최종 주차: $week, 운동일: $workoutDay');

    // RPE 기반 난이도 조정 계산
    await _rpeService.initialize();
    double intensityMultiplier = 1.0;

    if (_rpeService.recentRPE.isNotEmpty) {
      final lastRPE = _rpeService.recentRPE.last.value;
      intensityMultiplier = WorkoutData.calculateIntensityFromRPE(lastRPE);
      debugPrint(
          '📈 RPE 조정: 최근 RPE=$lastRPE → 강도=${(intensityMultiplier * 100).toStringAsFixed(0)}%');
    }

    // 버피 + 푸시업 세트 가져오기 (RPE 조정 적용)
    final dailyWorkout = WorkoutData.getWorkout(
      userProfile.level,
      week,
      workoutDay,
    );

    if (dailyWorkout == null) {
      debugPrint(
        '❌ 워크아웃 데이터가 없음 (레벨: ${userProfile.level}, 주차: $week, 일차: $workoutDay)',
      );
      return null;
    }

    // Note: RPE adjustment is now informational only
    // The new workout structure handles progression through week/day advancement
    final workoutSets = dailyWorkout.toSets();

    final totalReps = dailyWorkout.totalReps;
    debugPrint('✅ 오늘의 워크아웃 찾음: $week주차 $workoutDay일차 - 총 $totalReps회');
    debugPrint(
        '   세트 구성: ${workoutSets.map((ExerciseSet s) => '${s.type.name}:${s.reps}').join(", ")}');

    return TodayWorkout(
      week: week,
      day: workoutDay,
      workoutSets: workoutSets,
      totalReps: totalReps,
      restTimeSeconds: dailyWorkout.restTimeSeconds,
      intensityMultiplier: intensityMultiplier,
    );
  }

  /// 사용자의 주간 진행 상황 계산
  ///
  /// [userProfile] - 사용자 프로필
  /// Returns: 주간 진행 상황 정보
  Future<WeeklyProgress> getWeeklyProgress(UserProfile userProfile) async {
    final startDate = userProfile.startDate;
    final today = DateTime.now();
    final daysSinceStart = today.difference(startDate).inDays;

    final currentWeek = (daysSinceStart ~/ 7) + 1;
    final completedWeeks = currentWeek - 1;

    // 현재 주차의 완료된 워크아웃 세션 조회
    final sessions = await _databaseService.getWorkoutSessionsByWeek(
      currentWeek,
    );
    final completedDaysThisWeek = sessions.where((s) => s.isCompleted).length;

    return WeeklyProgress(
      currentWeek: currentWeek.clamp(1, 6),
      completedWeeks: completedWeeks.clamp(0, 6),
      completedDaysThisWeek: completedDaysThisWeek,
      totalDaysThisWeek: 3,
      weeklyTarget: getTotalRepsForWeek(
        userProfile.level,
        currentWeek.clamp(1, 6),
      ),
    );
  }

  /// 전체 프로그램 진행 상황 계산
  ///
  /// [userProfile] - 사용자 프로필
  /// Returns: 전체 프로그램 진행 상황 정보
  Future<ProgramProgress> getProgramProgress(UserProfile userProfile) async {
    final weeklyProgress = await getWeeklyProgress(userProfile);
    final allSessions = await _databaseService.getWorkoutSessionsByUserId(
      1,
    ); // 현재는 단일 사용자

    final completedSessions = allSessions.where((s) => s.isCompleted).length;
    final totalCompletedReps = allSessions
        .where((s) => s.isCompleted)
        .fold<int>(0, (sum, session) => sum + session.totalReps);

    final programTarget = getTotalRepsForProgram(userProfile.level);
    final progressPercentage = (totalCompletedReps / programTarget).clamp(
      0.0,
      1.0,
    );

    return ProgramProgress(
      weeklyProgress: weeklyProgress,
      completedSessions: completedSessions,
      totalSessions: 18,
      totalCompletedReps: totalCompletedReps,
      programTarget: programTarget,
      progressPercentage: progressPercentage,
      isCompleted: completedSessions >= 18,
    );
  }

  /// 다음 워크아웃 세션 예약
  ///
  /// [userProfile] - 사용자 프로필
  /// Returns: 다음 워크아웃 정보 또는 null (프로그램 완료)
  Future<TodayWorkout?> getNextWorkout(UserProfile userProfile) async {
    final allSessions = await _databaseService.getWorkoutSessionsByUserId(1);
    final completedSessions = allSessions.where((s) => s.isCompleted).length;

    if (completedSessions >= 18) {
      return null; // 프로그램 완료
    }

    // 다음 세션 계산
    final nextSessionIndex = completedSessions; // 0-based
    final week = (nextSessionIndex ~/ 3) + 1; // 1-based week
    final day = (nextSessionIndex % 3) + 1; // 1-based day

    // 버피 + 푸시업 세트 가져오기
    final dailyWorkout = WorkoutData.getWorkout(
      userProfile.level,
      week,
      day,
    );

    if (dailyWorkout == null) {
      return null;
    }

    final workoutSets = dailyWorkout.toSets();
    final totalReps = dailyWorkout.totalReps;

    return TodayWorkout(
      week: week,
      day: day,
      workoutSets: workoutSets,
      totalReps: totalReps,
      restTimeSeconds: dailyWorkout.restTimeSeconds,
    );
  }

  /// 사용자의 진행 상황 가져오기 (호환성 메소드)
  ///
  /// [userProfile] - 사용자 프로필 (선택적, null이면 기본 사용자)
  /// Returns: 전체 프로그램 진행 상황 정보
  Future<ProgramProgress> getProgress([UserProfile? userProfile]) async {
    if (userProfile != null) {
      return await getProgramProgress(userProfile);
    }

    // userProfile이 null이면 기본 프로필 생성하여 사용
    final defaultProfile = UserProfile(
      id: 1,
      level: UserLevel.rising,
      initialMaxReps: 10,
      startDate: DateTime.now().subtract(const Duration(days: 0)),
    );

    return await getProgramProgress(defaultProfile);
  }

  /// 새 사용자를 위한 완전한 워크아웃 프로그램을 데이터베이스에 초기화
  ///
  /// [userProfile] - 사용자 프로필 (레벨과 시작 날짜 포함)
  /// Returns: 생성된 워크아웃 세션 수
  Future<int> initializeUserProgram(UserProfile userProfile) async {
    final program = generateProgram(userProfile.level);
    int createdSessions = 0;

    for (int week = 1; week <= 6; week++) {
      final weekData = program[week];
      if (weekData == null) continue;

      for (int day = 1; day <= 3; day++) {
        final workout = weekData[day];
        if (workout == null) continue;

        // 워크아웃 날짜 계산 (월, 수, 금)
        final dayMapping = {1: 0, 2: 2, 3: 4}; // 운동 일차 -> 주 내 일차
        final weekOffset = (week - 1) * 7;
        final dayOffset = dayMapping[day] ?? 0;
        final workoutDate = userProfile.startDate.add(
          Duration(days: weekOffset + dayOffset),
        );

        // WorkoutSession 생성
        final session = WorkoutSession(
          id: null, // 자동 생성됨
          week: week,
          day: day,
          date: workoutDate,
          targetReps: workout,
          completedReps: const [],
          isCompleted: false,
          totalReps: getTotalRepsForWorkout(workout),
          totalTime: Duration.zero,
        );

        // 데이터베이스에 저장
        await _databaseService.insertWorkoutSession(session);
        createdSessions++;
      }
    }

    return createdSessions;
  }

  /// 사용자의 워크아웃 프로그램이 이미 초기화되었는지 확인
  ///
  /// [userId] - 사용자 ID
  /// Returns: 초기화 여부
  Future<bool> isProgramInitialized(int userId) async {
    final sessions = await _databaseService.getWorkoutSessionsByUserId(userId);
    return sessions.length >= 18; // 6주 * 3일 = 18세션
  }

  /// 사용자 프로그램 재초기화 (레벨 변경 시 사용)
  ///
  /// [userProfile] - 업데이트된 사용자 프로필
  /// [clearExisting] - 기존 세션 삭제 여부
  /// Returns: 생성된 워크아웃 세션 수
  Future<int> reinitializeUserProgram(
    UserProfile userProfile, {
    bool clearExisting = true,
  }) async {
    if (clearExisting) {
      // 기존 세션들 삭제
      final existingSessions = await _databaseService
          .getWorkoutSessionsByUserId(userProfile.id ?? 1);
      for (final session in existingSessions) {
        if (session.id != null) {
          await _databaseService.deleteWorkoutSession(session.id!);
        }
      }
    }

    // 새 프로그램 초기화
    return await initializeUserProgram(userProfile);
  }
}

/// 오늘의 워크아웃 정보를 담는 클래스
class TodayWorkout {
  final int week;
  final int day;
  final List<ExerciseSet> workoutSets;
  final int totalReps;
  final int restTimeSeconds;
  final double intensityMultiplier; // RPE 기반 조정값

  const TodayWorkout({
    required this.week,
    required this.day,
    required this.workoutSets,
    required this.totalReps,
    required this.restTimeSeconds,
    this.intensityMultiplier = 1.0,
  });

  /// 워크아웃 세트 수
  int get setCount => workoutSets.length;

  /// 평균 세트당 횟수
  double get averageRepsPerSet => setCount > 0 ? totalReps / setCount : 0;

  /// 총 버피 횟수
  int get totalBurpees => workoutSets
      .where((set) => set.type == ExerciseType.pushup)
      .fold<int>(0, (sum, set) => sum + set.reps);

  /// 총 푸시업 횟수
  int get totalPushups => workoutSets
      .where((set) => set.type == ExerciseType.pushup)
      .fold<int>(0, (sum, set) => sum + set.reps);

  /// 워크아웃 제목
  String get title => '$week주차 - $day일차';

  /// 워크아웃 설명
  String get description {
    if (intensityMultiplier > 1.05) {
      return '$setCount세트, 총 $totalReps회 (난이도 ⬆)';
    } else if (intensityMultiplier < 0.95) {
      return '$setCount세트, 총 $totalReps회 (난이도 ⬇)';
    }
    return '$setCount세트, 총 $totalReps회';
  }

  /// RPE 조정 상태 텍스트
  String get adjustmentText {
    if (intensityMultiplier > 1.05) {
      return '지난 운동이 쉬웠다고 하셨죠? 오늘은 조금 더 도전해봅시다! 💪';
    } else if (intensityMultiplier < 0.95) {
      return '지난번이 힘들었다면 오늘은 조금 여유롭게 가봐요! 😊';
    }
    return '오늘도 화이팅! 🔥';
  }

  @override
  String toString() {
    return 'TodayWorkout(week: $week, day: $day, sets: $setCount, burpees: $totalBurpees, pushups: $totalPushups, intensity: ${(intensityMultiplier * 100).toStringAsFixed(0)}%)';
  }
}

/// 주간 진행 상황 정보를 담는 클래스
class WeeklyProgress {
  final int currentWeek;
  final int completedWeeks;
  final int completedDaysThisWeek;
  final int totalDaysThisWeek;
  final int weeklyTarget;

  const WeeklyProgress({
    required this.currentWeek,
    required this.completedWeeks,
    required this.completedDaysThisWeek,
    required this.totalDaysThisWeek,
    required this.weeklyTarget,
  });

  /// 이번 주 완료율 (0.0 - 1.0)
  double get weeklyCompletionRate => completedDaysThisWeek / totalDaysThisWeek;

  /// 이번 주 남은 운동일
  int get remainingDaysThisWeek => totalDaysThisWeek - completedDaysThisWeek;

  @override
  String toString() {
    return 'WeeklyProgress(week: $currentWeek, completed: $completedDaysThisWeek/$totalDaysThisWeek)';
  }
}

/// 전체 프로그램 진행 상황 정보를 담는 클래스
class ProgramProgress {
  final WeeklyProgress weeklyProgress;
  final int completedSessions;
  final int totalSessions;
  final int totalCompletedReps;
  final int programTarget;
  final double progressPercentage;
  final bool isCompleted;

  const ProgramProgress({
    required this.weeklyProgress,
    required this.completedSessions,
    required this.totalSessions,
    required this.totalCompletedReps,
    required this.programTarget,
    required this.progressPercentage,
    required this.isCompleted,
  });

  /// 남은 세션 수
  int get remainingSessions => totalSessions - completedSessions;

  /// 남은 횟수
  int get remainingReps => programTarget - totalCompletedReps;

  /// 완료된 주차 수 (weeklyProgress에서 가져옴)
  int get completedWeeks => weeklyProgress.completedWeeks;

  /// 전체 주차 수 (고정값 6주)
  int get totalWeeks => 6;

  /// 이번 주 완료된 운동일 수
  int get completedDaysThisWeek => weeklyProgress.completedDaysThisWeek;

  /// 이번 주 총 운동일 수
  int get totalDaysThisWeek => weeklyProgress.totalDaysThisWeek;

  @override
  String toString() {
    return 'ProgramProgress(sessions: $completedSessions/$totalSessions, reps: $totalCompletedReps/$programTarget, ${(progressPercentage * 100).toStringAsFixed(1)}%)';
  }
}
