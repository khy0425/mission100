import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/challenge.dart';
import '../models/user_profile.dart';
import 'achievement_service.dart';
import '../services/notification_service.dart';

/// 챌린지 관리 서비스
class ChallengeService {
  static final ChallengeService _instance = ChallengeService._internal();
  factory ChallengeService() => _instance;
  ChallengeService._internal();

  List<Challenge> _activeChallenges = [];
  List<Challenge> _completedChallenges = [];
  List<Challenge> _allChallenges = [];
  final String _activeChallengesKey = 'active_challenges';
  final String _completedChallengesKey = 'completed_challenges';

  /// 서비스 초기화
  Future<void> initialize() async {
    await _loadChallengesFromStorage();
    _initializeDefaultChallenges();
    debugPrint('ChallengeService 초기화 완료');
  }

  /// 기본 챌린지들 초기화 (단기 미션 중심)
  void _initializeDefaultChallenges() {
    if (_allChallenges.isEmpty) {
      _allChallenges = [
        // 🎯 일일 챌린지 (단기, 즉시 도전)
        Challenge(
          id: 'daily_perfect_form',
          titleKey: 'daily_perfect_form_title',
          descriptionKey: 'daily_perfect_form_desc',
          difficultyKey: 'easy',
          duration: 1,
          targetCount: 1,
          milestones: [],
          rewardKey: 'daily_perfect_form_reward',
          isActive: false,
          currentProgress: 0,
          title: '오늘 완벽한 자세로 운동하기',
          description: '오늘 하루 완벽한 자세로 운동을 완료하세요',
          type: ChallengeType.dailyPerfect,
          targetValue: 1,
          status: ChallengeStatus.available,
          lastUpdatedAt: DateTime.now(),
        ),

        // 🔥 주간 챌린지 - 휴식일 제외한 완벽한 주 (단기, 일주일 도전)
        Challenge(
          id: 'weekly_perfect_schedule',
          titleKey: 'weekly_perfect_schedule_title',
          descriptionKey: 'weekly_perfect_schedule_desc',
          difficultyKey: 'hard',
          duration: 7,
          targetCount: 1,
          milestones: [],
          rewardKey: 'weekly_perfect_schedule_reward',
          isActive: false,
          currentProgress: 0,
          title: '완벽한 주간 운동 스케줄',
          description: '휴식일 제외하고 모든 운동일에 운동하기',
          detailedDescription: '휴식은 CHAD의 필수! 운동일에만 완벽하게 집중하세요!',
          type: ChallengeType.weeklyGoal,
          difficulty: ChallengeDifficulty.hard,
          targetValue: 1, // 주 단위로 1번 달성
          targetUnit: '주',
          estimatedDuration: 7,
          rewards: [
            ChallengeReward(
              type: 'badge',
              value: 'perfect_week_warrior',
              description: '완벽한 주 워리어 배지',
            ),
            ChallengeReward(type: 'xp', value: '350', description: '350 경험치'),
          ],
          status: ChallengeStatus.available,
          lastUpdatedAt: DateTime.now(),
        ),

        // 💪 스킬 챌린지 (특정 기술 도전)
        Challenge(
          id: 'single_session_power',
          titleKey: 'single_session_power_title',
          descriptionKey: 'single_session_power_desc',
          difficultyKey: 'medium',
          duration: 1,
          targetCount: 30,
          milestones: [],
          rewardKey: 'single_session_power_reward',
          isActive: false,
          currentProgress: 0,
          title: '한 번에 30개 도전',
          description: '한 세션에서 30개 푸시업을 달성하세요',
          type: ChallengeType.skillChallenge,
          targetValue: 30,
          status: ChallengeStatus.available,
          lastUpdatedAt: DateTime.now(),
        ),

        Challenge(
          id: 'single_session_beast',
          titleKey: 'single_session_beast_title',
          descriptionKey: 'single_session_beast_desc',
          difficultyKey: 'hard',
          duration: 1,
          targetCount: 50,
          milestones: [],
          rewardKey: 'single_session_beast_reward',
          isActive: false,
          currentProgress: 0,
          title: '한 번에 50개 BEAST 도전',
          description: '한 세션에서 50개 푸시업을 달성하세요',
          type: ChallengeType.skillChallenge,
          targetValue: 50,
          status: ChallengeStatus.locked,
          lastUpdatedAt: DateTime.now(),
          prerequisites: ['single_session_power'],
        ),

        // 🚀 완벽한 휴식 주기 챌린지 (운동→휴식 패턴)
        Challenge(
          id: 'perfect_rest_cycle',
          titleKey: 'perfect_rest_cycle_title',
          descriptionKey: 'perfect_rest_cycle_desc',
          difficultyKey: 'medium',
          duration: 6,
          targetCount: 3,
          milestones: [],
          rewardKey: 'perfect_rest_cycle_reward',
          isActive: false,
          currentProgress: 0,
          title: '완벽한 휴식 주기 챌린지',
          description: '운동→휴식 패턴을 3번 완벽하게 반복하기',
          detailedDescription: '월운동→화휴식→수운동→목휴식→금운동→토휴식! 진정한 CHAD는 휴식도 계획적! 🔄',
          type: ChallengeType.sprintChallenge,
          difficulty: ChallengeDifficulty.medium,
          targetValue: 3,
          targetUnit: '사이클',
          estimatedDuration: 6,
          rewards: [
            ChallengeReward(
              type: 'badge',
              value: 'perfect_cycle_master',
              description: '완벽한 휴식 주기 마스터 배지',
            ),
            ChallengeReward(type: 'xp', value: '500', description: '500 경험치'),
          ],
          status: ChallengeStatus.available,
          lastUpdatedAt: DateTime.now(),
        ),

        // 🎪 이벤트 챌린지 (특별 도전)
        Challenge(
          id: 'monday_motivation',
          titleKey: 'monday_motivation_title',
          descriptionKey: 'monday_motivation_desc',
          difficultyKey: 'easy',
          duration: 1,
          targetCount: 1,
          milestones: [],
          rewardKey: 'monday_motivation_reward',
          isActive: false,
          currentProgress: 0,
          title: 'CHAD 월요일 모티베이션',
          description: '월요일에 운동으로 한 주를 시작하세요!',
          detailedDescription: '월요일 블루는 CHAD에게 통하지 않는다! 💪',
          type: ChallengeType.eventChallenge,
          difficulty: ChallengeDifficulty.easy,
          targetValue: 1,
          targetUnit: '회',
          estimatedDuration: 1,
          rewards: [
            ChallengeReward(
              type: 'badge',
              value: 'monday_crusher',
              description: 'Monday Crusher 배지',
            ),
            ChallengeReward(type: 'xp', value: '100', description: '100 경험치'),
          ],
          status: ChallengeStatus.available,
          lastUpdatedAt: DateTime.now(),
        ),
      ];
    }
  }

  /// 저장소에서 챌린지 로드
  Future<void> _loadChallengesFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 활성 챌린지 로드
      final activeData = prefs.getString(_activeChallengesKey);
      if (activeData != null) {
        final activeJson = jsonDecode(activeData) as List<dynamic>;
        _activeChallenges = activeJson
            .map((json) => Challenge.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      // 완료된 챌린지 로드
      final completedData = prefs.getString(_completedChallengesKey);
      if (completedData != null) {
        final completedJson = jsonDecode(completedData) as List<dynamic>;
        _completedChallenges = completedJson
            .map((json) => Challenge.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('챌린지 로드 오류: $e');
    }
  }

  /// 저장소에 챌린지 저장
  Future<void> _saveChallenges() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 활성 챌린지 저장
      final activeJson = _activeChallenges.map((c) => c.toJson()).toList();
      await prefs.setString(_activeChallengesKey, jsonEncode(activeJson));

      // 완료된 챌린지 저장
      final completedJson =
          _completedChallenges.map((c) => c.toJson()).toList();
      await prefs.setString(_completedChallengesKey, jsonEncode(completedJson));
    } catch (e) {
      debugPrint('챌린지 저장 오류: $e');
    }
  }

  /// 사용자에게 사용 가능한 챌린지 목록 반환
  Future<List<Challenge>> getAvailableChallenges(
    UserProfile userProfile,
  ) async {
    _unlockChallenges();
    return _allChallenges
        .where(
          (c) =>
              c.status == ChallengeStatus.available ||
              c.status == ChallengeStatus.active,
        )
        .toList();
  }

  /// 의존성 기반 챌린지 해제
  void _unlockChallenges() {
    for (int i = 0; i < _allChallenges.length; i++) {
      final challenge = _allChallenges[i];
      if (challenge.status == ChallengeStatus.locked &&
          challenge.prerequisites != null) {
        final allDepsCompleted = challenge.prerequisites!.every(
          (depId) => _completedChallenges.any((c) => c.id == depId),
        );
        if (allDepsCompleted) {
          _allChallenges[i] = challenge.copyWith(
            status: ChallengeStatus.available,
          );
        }
      }
    }
  }

  /// 활성 챌린지 목록 반환
  List<Challenge> getActiveChallenges() {
    return List.from(_activeChallenges);
  }

  /// 완료된 챌린지 목록 반환
  List<Challenge> getCompletedChallenges() {
    return List.from(_completedChallenges);
  }

  /// 특정 챌린지 조회
  Challenge? getChallengeById(String challengeId) {
    for (final challenge in _allChallenges) {
      if (challenge.id == challengeId) return challenge;
    }
    for (final challenge in _activeChallenges) {
      if (challenge.id == challengeId) return challenge;
    }
    for (final challenge in _completedChallenges) {
      if (challenge.id == challengeId) return challenge;
    }
    return null;
  }

  /// 챌린지 힌트 반환
  String getChallengeHint(ChallengeType type) {
    switch (type) {
      case ChallengeType.dailyPerfect:
        return '오늘 하루 완벽한 운동을 완료하세요.';
      case ChallengeType.weeklyGoal:
        return '주간 목표를 달성하세요. 휴식일은 제외됩니다.';
      case ChallengeType.skillChallenge:
        return '한 번의 운동으로 목표를 달성해야 하는 챌린지입니다.';
      case ChallengeType.sprintChallenge:
        return '단기간 집중 도전입니다. 연속으로 완료하세요.';
      case ChallengeType.eventChallenge:
        return '특별 이벤트 챌린지입니다. 기간 내에 완료하세요.';
      default:
        return '챌린지를 완료하여 보상을 획득하세요!';
    }
  }

  /// 운동 완료시 챌린지 진행도 업데이트
  Future<void> updateProgressAfterWorkout(
    int repsCompleted,
    DateTime workoutDate,
  ) async {
    await updateChallengesOnWorkoutComplete(repsCompleted, 1);
  }

  /// 모든 챌린지 다시 로드
  Future<void> reloadChallenges() async {
    await _loadChallengesFromStorage();
    _unlockChallenges();
  }

  /// 챌린지 참여 시작
  Future<bool> startChallenge(String challengeId) async {
    final challengeIndex = _allChallenges.indexWhere(
      (c) => c.id == challengeId,
    );
    if (challengeIndex == -1) return false;

    final challenge = _allChallenges[challengeIndex];
    if (challenge.status != ChallengeStatus.available) {
      return false;
    }

    // 이미 활성 목록에 있는지 확인
    if (_activeChallenges.any((c) => c.id == challengeId)) {
      return false;
    }

    // 활성 목록에 추가 - copyWith 사용
    final activeChallenge = challenge.copyWith(
      status: ChallengeStatus.active,
      startDate: DateTime.now(),
      lastUpdatedAt: DateTime.now(),
      currentProgress: 0,
    );

    _activeChallenges.add(activeChallenge);
    _allChallenges[challengeIndex] = challenge.copyWith(
      status: ChallengeStatus.active,
    );

    await _saveChallenges();
    return true;
  }

  /// 챌린지 포기
  Future<bool> quitChallenge(String challengeId) async {
    return await abandonChallenge(challengeId);
  }

  /// 챌린지 진행도 업데이트 (int 버전)
  Future<void> updateChallengeProgress(String challengeId, int progress) async {
    final challengeIndex = _activeChallenges.indexWhere(
      (c) => c.id == challengeId,
    );
    if (challengeIndex != -1) {
      final challenge = _activeChallenges[challengeIndex];
      final updatedChallenge = challenge.copyWith(
        currentProgress: progress,
        lastUpdatedAt: DateTime.now(),
      );
      _activeChallenges[challengeIndex] = updatedChallenge;

      // 완료 체크
      if (updatedChallenge.currentProgress >=
          (updatedChallenge.targetValue ?? updatedChallenge.targetCount)) {
        _completeChallengeAt(challengeIndex);
      }

      await _saveChallenges();
    }
  }

  /// 챌린지 완료 처리
  void _completeChallengeAt(int index) async {
    final challenge = _activeChallenges[index];
    final completedChallenge = challenge.copyWith(
      status: ChallengeStatus.completed,
      completionDate: DateTime.now(),
      endDate: DateTime.now(),
    );

    _completedChallenges.add(completedChallenge);
    _activeChallenges.removeAt(index);

    // 전체 목록에서도 상태 업데이트
    final allChallengeIndex = _allChallenges.indexWhere(
      (c) => c.id == completedChallenge.id,
    );
    if (allChallengeIndex != -1) {
      _allChallenges[allChallengeIndex] = _allChallenges[allChallengeIndex]
          .copyWith(status: ChallengeStatus.completed);
    }

    // 챌린지 완료 정보를 업적 시스템에 저장
    await _saveChallengCompletionForAchievements(completedChallenge);

    debugPrint(
      '🎉 챌린지 완료: ${completedChallenge.title} (${completedChallenge.id})',
    );
  }

  /// 업적 시스템을 위한 챌린지 완료 정보 저장
  Future<void> _saveChallengCompletionForAchievements(
    Challenge challenge,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 완료된 챌린지 ID 목록에 추가
      final completedIds = prefs.getStringList('completed_challenge_ids') ?? [];
      if (!completedIds.contains(challenge.id)) {
        completedIds.add(challenge.id);
        await prefs.setStringList('completed_challenge_ids', completedIds);
      }

      // 완료 시간 기록
      final completionTimes =
          prefs.getStringList('challenge_completion_times') ?? [];
      final completionTime = DateTime.now().toIso8601String();
      completionTimes.add('${challenge.id}:$completionTime');
      await prefs.setStringList('challenge_completion_times', completionTimes);

      // 24시간 내 완료 체크 (빠른 완료 업적용)
      final startTime = challenge.startDate;
      if (startTime != null) {
        final completionDuration = DateTime.now().difference(startTime);
        if (completionDuration.inHours <= 24) {
          await prefs.setBool('has_24h_challenge_completion', true);
          debugPrint('⚡ 24시간 내 챌린지 완료! 스피드 챌린저 업적 조건 달성!');
        }
      }

      // 현재 활성 챌린지 목록 업데이트 (멀티 챌린저 업적용)
      final activeIds = _activeChallenges.map((c) => c.id).toList();
      await prefs.setStringList('active_challenge_ids', activeIds);

      debugPrint('💾 업적용 챌린지 완료 데이터 저장: ${challenge.id}');
    } catch (e) {
      debugPrint('❌ 업적용 챌린지 데이터 저장 실패: $e');
    }
  }

  /// 운동 완료 시 챌린지 업데이트 (수정된 서명)
  Future<List<Challenge>> updateChallengesOnWorkoutComplete(
    int repsCompleted,
    int sessionsCompleted,
  ) async {
    final updatedChallenges = <Challenge>[];

    for (int i = _activeChallenges.length - 1; i >= 0; i--) {
      final challenge = _activeChallenges[i];
      bool updated = false;
      int newProgress = challenge.currentProgress;

      switch (challenge.type) {
        case ChallengeType.dailyPerfect:
          // 오늘 운동 완료 시 성공
          final today = DateTime.now();
          final lastUpdate = challenge.lastUpdatedAt;

          if (lastUpdate == null || !_isSameDay(today, lastUpdate)) {
            newProgress = 1;
            updated = true;
          }
          break;

        case ChallengeType.weeklyGoal:
          // 주간 완벽 스케줄 - 휴식일 제외한 모든 운동일 완료 체크
          final today = DateTime.now();
          final lastUpdate = challenge.lastUpdatedAt;

          if (lastUpdate == null || !_isSameDay(today, lastUpdate)) {
            // 이번 주에 해당하는지 확인
            if (_isSameWeek(today, challenge.startDate ?? today)) {
              // 이번 주의 운동 완료 날짜들을 확인
              final weekComplete = await _checkWeeklyPerfectSchedule(challenge);
              if (weekComplete) {
                newProgress = 1; // 주간 챌린지 완료
                updated = true;
              }
            }
          }
          break;

        case ChallengeType.skillChallenge:
          // 한 세션에서 목표 달성 시 성공
          final targetValue = challenge.targetValue ?? challenge.targetCount;
          if (repsCompleted >= targetValue) {
            newProgress = repsCompleted;
            updated = true;
          }
          break;

        case ChallengeType.sprintChallenge:
          // 완벽한 휴식 주기 챌린지 (운동→휴식 패턴)
          final today = DateTime.now();
          final lastUpdate = challenge.lastUpdatedAt;

          if (lastUpdate == null) {
            // 첫 운동 - 휴식 주기 시작
            newProgress = 0; // 아직 완성된 사이클 없음
            updated = true;
            debugPrint('🔄 완벽한 휴식 주기 시작: 첫 운동 완료');

            // 챌린지 상태에 첫 운동 날짜 저장
            await _saveCycleState(challenge.id, 'first_workout', today);
          } else if (!_isSameDay(today, lastUpdate)) {
            // 완벽한 휴식 주기 패턴 확인
            final cycleResult = await _checkPerfectRestCycle(challenge, today);

            if (cycleResult['failed'] == true) {
              // 휴식 주기 실패 (연속으로 운동했거나, 패턴을 어김)
              debugPrint('🚀 완벽한 휴식 주기 챌린지 실패: ${challenge.title}');
              await failChallenge(challenge.id);
              continue;
            } else if (cycleResult['completed_cycle'] == true) {
              // 하나의 운동→휴식 사이클 완료
              newProgress += 1;
              updated = true;
              debugPrint(
                '🔄 완벽한 휴식 주기 사이클 완료: ${newProgress}/${challenge.targetValue}',
              );
            }
          }
          break;

        case ChallengeType.eventChallenge:
          // 이벤트별 커스텀 로직 (추후 확장)
          break;

        default:
          break;
      }

      if (updated) {
        final updatedChallenge = challenge.copyWith(
          currentProgress: newProgress,
          lastUpdatedAt: DateTime.now(),
        );
        _activeChallenges[i] = updatedChallenge;
        updatedChallenges.add(updatedChallenge);

        // 완료 체크
        final targetValue =
            updatedChallenge.targetValue ?? updatedChallenge.targetCount;
        if (updatedChallenge.currentProgress >= targetValue) {
          _completeChallengeAt(i);
        }
      }
    }

    await _saveChallenges();
    return updatedChallenges;
  }

  /// 같은 날인지 확인
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// 같은 주인지 확인 (월요일 기준)
  bool _isSameWeek(DateTime a, DateTime b) {
    // 월요일을 주의 시작으로 계산
    final startOfWeekA = a.subtract(Duration(days: a.weekday - 1));
    final startOfWeekB = b.subtract(Duration(days: b.weekday - 1));
    return _isSameDay(startOfWeekA, startOfWeekB);
  }

  /// 주간 완벽 스케줄 체크 (휴식일 제외한 운동일 모두 완료)
  Future<bool> _checkWeeklyPerfectSchedule(Challenge challenge) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now();
      final startOfWeek = today.subtract(
        Duration(days: today.weekday - 1),
      ); // 이번 주 월요일

      // 사용자의 운동 설정 가져오기 (기본: 월-금 운동, 토-일 휴식)
      final settingsJson = prefs.getString('workout_reminder_settings');
      List<int> workoutDays = [1, 2, 3, 4, 5]; // 기본값: 월-금

      if (settingsJson != null) {
        try {
          final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
          final activeDays = List<int>.from(
            (settingsMap['activeDays'] as List?) ?? [1, 2, 3, 4, 5],
          );
          workoutDays = activeDays;
        } catch (e) {
          debugPrint('⚠️ 운동 설정 파싱 실패, 기본값 사용: $e');
        }
      }

      // 이번 주의 운동일들 체크
      int completedWorkoutDays = 0;
      final workoutHistory = prefs.getStringList('completed_workouts') ?? [];

      for (int i = 1; i <= 7; i++) {
        final dayOfWeek = startOfWeek.add(Duration(days: i - 1));

        // 운동일인지 확인
        if (workoutDays.contains(i)) {
          // 해당 날짜에 운동했는지 확인
          final dayKey =
              'workout_${dayOfWeek.year}_${dayOfWeek.month}_${dayOfWeek.day}';
          if (workoutHistory.contains(dayKey) || _isSameDay(dayOfWeek, today)) {
            // 오늘이면서 현재 운동을 완료한 경우도 포함
            completedWorkoutDays++;
          }
        }
      }

      // 모든 운동일 완료했는지 확인
      final totalWorkoutDays = workoutDays.length;
      final isWeekComplete = completedWorkoutDays >= totalWorkoutDays;

      debugPrint(
        '📅 주간 스케줄 체크: $completedWorkoutDays/$totalWorkoutDays 완료, 완벽한 주: $isWeekComplete',
      );

      if (isWeekComplete && challenge.currentProgress == 0) {
        // 주간 챌린지 완료!
        debugPrint('🎉 주간 완벽 스케줄 달성!');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ 주간 스케줄 체크 실패: $e');
      return false;
    }
  }

  /// 완벽한 휴식 주기 상태 저장
  Future<void> _saveCycleState(
    String challengeId,
    String state,
    DateTime date,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateKey = 'cycle_state_$challengeId';
      final stateData = {
        'state': state,
        'date': date.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
      };
      await prefs.setString(stateKey, jsonEncode(stateData));
      debugPrint('💾 휴식 주기 상태 저장: $state at ${date.toString().split(' ')[0]}');
    } catch (e) {
      debugPrint('❌ 휴식 주기 상태 저장 실패: $e');
    }
  }

  /// 완벽한 휴식 주기 패턴 확인
  Future<Map<String, bool>> _checkPerfectRestCycle(
    Challenge challenge,
    DateTime today,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateKey = 'cycle_state_${challenge.id}';
      final stateJson = prefs.getString(stateKey);

      if (stateJson == null) {
        // 상태 정보가 없으면 첫 운동으로 간주
        await _saveCycleState(challenge.id, 'first_workout', today);
        return {'failed': false, 'completed_cycle': false};
      }

      final stateData = jsonDecode(stateJson) as Map<String, dynamic>;
      final lastState = stateData['state'] as String;
      final lastDate = DateTime.parse(stateData['date'] as String);
      final daysDiff = today.difference(lastDate).inDays;

      debugPrint('🔄 휴식 주기 체크: $lastState → 오늘 운동 (${daysDiff}일 차이)');

      if (lastState == 'first_workout' || lastState == 'rest_completed') {
        // 마지막이 운동이었거나 휴식 완료였으면
        if (daysDiff == 1) {
          // 하루 차이 = 연속 운동 = 실패!
          debugPrint('❌ 연속 운동 감지! 휴식 주기 실패');
          return {'failed': true, 'completed_cycle': false};
        } else if (daysDiff == 2) {
          // 이틀 차이 = 운동→휴식→운동 = 완벽한 사이클!
          await _saveCycleState(challenge.id, 'cycle_completed', today);
          debugPrint('✅ 완벽한 휴식 주기 사이클 완료!');
          return {'failed': false, 'completed_cycle': true};
        } else {
          // 3일 이상 차이 = 너무 오래 쉼
          debugPrint('⚠️ 너무 오래 쉼 (${daysDiff}일), 새로운 사이클 시작');
          await _saveCycleState(challenge.id, 'first_workout', today);
          return {'failed': false, 'completed_cycle': false};
        }
      } else if (lastState == 'cycle_completed') {
        // 사이클 완료 후 다음 운동
        if (daysDiff == 1) {
          // 하루 차이 = 연속 운동 = 실패!
          debugPrint('❌ 사이클 완료 후 연속 운동! 휴식 주기 실패');
          return {'failed': true, 'completed_cycle': false};
        } else if (daysDiff >= 2) {
          // 이틀 이상 차이 = 새로운 사이클 시작
          await _saveCycleState(challenge.id, 'first_workout', today);
          debugPrint('🔄 새로운 휴식 주기 사이클 시작');
          return {'failed': false, 'completed_cycle': false};
        }
      }

      return {'failed': false, 'completed_cycle': false};
    } catch (e) {
      debugPrint('❌ 휴식 주기 패턴 확인 실패: $e');
      return {'failed': true, 'completed_cycle': false};
    }
  }

  /// 챌린지 포기 (abandon)
  Future<bool> abandonChallenge(String challengeId) async {
    final challengeIndex = _activeChallenges.indexWhere(
      (c) => c.id == challengeId,
    );
    if (challengeIndex == -1) return false;

    _activeChallenges.removeAt(challengeIndex);

    // 전체 목록에서 상태를 다시 available로 변경
    final allChallengeIndex = _allChallenges.indexWhere(
      (c) => c.id == challengeId,
    );
    if (allChallengeIndex != -1) {
      _allChallenges[allChallengeIndex] =
          _allChallenges[allChallengeIndex].copyWith(
        status: ChallengeStatus.available,
        currentProgress: 0,
        startDate: null,
      );
    }

    await _saveChallenges();
    return true;
  }

  /// 챌린지 실패 처리
  Future<void> failChallenge(String challengeId) async {
    await abandonChallenge(challengeId);
  }

  /// 오늘의 챌린지 요약
  Future<Map<String, dynamic>> getTodayChallengesSummary() async {
    return {
      'activeCount': _activeChallenges.length,
      'completedToday': _completedChallenges
          .where(
            (c) =>
                c.completionDate != null &&
                _isSameDay(c.completionDate!, DateTime.now()),
          )
          .length,
      'totalCompleted': _completedChallenges.length,
    };
  }

  /// 서비스 정리
  void dispose() {
    _activeChallenges.clear();
    _completedChallenges.clear();
    _allChallenges.clear();
  }
}
