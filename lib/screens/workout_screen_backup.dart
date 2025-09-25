import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../generated/app_localizations.dart';
import '../utils/constants.dart';
import '../models/user_profile.dart';
import '../services/workout_program_service.dart';
import '../services/workout_history_service.dart';
import '../models/workout_history.dart';
import '../services/achievement_service.dart';
import '../models/achievement.dart';
import '../services/social_share_service.dart';
import '../services/motivational_message_service.dart';
import '../services/streak_service.dart';
import '../widgets/ad_banner_widget.dart';
import '../services/notification_service.dart';
import '../models/workout_session.dart';
import '../widgets/multiple_achievements_dialog.dart';
// 분리된 위젯들 import
import 'workout/widgets/workout_header_widget.dart';
import 'workout/widgets/rep_counter_widget.dart';
import 'workout/widgets/rest_timer_widget.dart';
import 'workout/widgets/workout_controls_widget.dart';
import 'workout/handlers/workout_completion_handler.dart';

class WorkoutScreen extends StatefulWidget {
  final dynamic workout; // 서비스에서 가져오는 타입
  final VoidCallback? onWorkoutCompleted;

  const WorkoutScreen({
    super.key,
    required this.workout,
    this.onWorkoutCompleted,
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // 워크아웃 상태
  int _currentSet = 0;
  int _currentReps = 0;
  List<int> _completedReps = [];
  bool _isSetCompleted = false;
  bool _isRestTime = false;
  int _restTimeRemaining = 0;
  Timer? _restTimer;

  // 세션 관리
  int? _sessionId;
  DateTime? _workoutStartTime;

  // 워크아웃 데이터
  late List<int> _targetReps;
  late int _restTimeSeconds;

  // 서비스들
  final MotivationalMessageService _messageService = MotivationalMessageService();
  final StreakService _streakService = StreakService();
  final WorkoutProgramService _workoutProgramService = WorkoutProgramService();

  // 업적 관리
  List<Achievement> _newlyUnlockedAchievements = [];

  // 계산된 값들
  int get _totalSets => _targetReps.length;
  int get _currentTargetReps => _currentSet < _totalSets ? _targetReps[_currentSet] : 0;
  double get _overallProgress => (_currentSet + (_isSetCompleted ? 1 : 0)) / _totalSets;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeWorkout();
    _initializeSession();
    _showWorkoutStartMessage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _restTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _handleAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      _handleAppResumed();
    }
  }

  void _initializeWorkout() {
    _targetReps = List<int>.from(widget.workout.workout ?? []);
    _restTimeSeconds = widget.workout.restTimeSeconds ?? 60;
    _completedReps = List.filled(_targetReps.length, 0);
    _workoutStartTime = DateTime.now();
  }

  void _initializeSession() async {
    try {
      _sessionId = DateTime.now().millisecondsSinceEpoch;
      await _startNewSession();
    } catch (e) {
      debugPrint('세션 초기화 실패: $e');
    }
  }

  Future<void> _startNewSession() async {
    try {
      final session = WorkoutSession(
        id: _sessionId,
        date: DateTime.now(),
        week: widget.workout.week ?? 1,
        day: widget.workout.day ?? 1,
        targetReps: _targetReps,
        completedReps: _completedReps,
        isCompleted: false,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_workout_session', jsonEncode(session.toMap()));
    } catch (e) {
      debugPrint('새 세션 시작 실패: $e');
    }
  }

  void _showWorkoutStartMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Localizations.localeOf(context).languageCode == 'ko'
                ? '💪 운동을 시작합니다! 화이팅!'
                : '💪 Let\'s start the workout! You got this!',
            ),
            backgroundColor: Color(AppColors.primaryColor),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _handleAppPaused() async {
    await _saveCurrentProgress();
  }

  void _handleAppResumed() async {
    // 앱이 포그라운드로 돌아왔을 때 상태 복구
  }

  Future<void> _saveCurrentProgress() async {
    try {
      final session = WorkoutSession(
        id: _sessionId,
        date: _workoutStartTime ?? DateTime.now(),
        week: widget.workout.week ?? 1,
        day: widget.workout.day ?? 1,
        targetReps: _targetReps,
        completedReps: _completedReps,
        isCompleted: false,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_workout_session', jsonEncode(session.toMap()));
    } catch (e) {
      debugPrint('진행률 저장 실패: $e');
    }
  }

  void _onRepsChanged(int newReps) {
    setState(() {
      _currentReps = newReps;
    });
    _checkAchievementsDuringWorkout();
  }

  void _onSetCompleted() {
    setState(() {
      _completedReps[_currentSet] = _currentReps;
      _isSetCompleted = true;
    });
    _saveCurrentProgress();
  }

  void _onStartRest() {
    _startRestTimer();
  }

  void _onSkipRest() {
    _restTimer?.cancel();
    _moveToNextSet();
  }

  void _onCompleteWorkout() {
    debugPrint('🔥 _onCompleteWorkout 버튼 클릭됨');

    // 즉각적인 시각적 피드백
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          Localizations.localeOf(context).languageCode == 'ko'
            ? '운동 완료 처리 중...'
            : 'Processing workout completion...',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.blue,
      ),
    );

    // 햅틱 피드백
    HapticFeedback.heavyImpact();

    _completeWorkout();
  }

  void _onMarkSetCompleted() {
    _markSetCompleted();
  }

  Future<void> _checkAchievementsDuringWorkout() async {
    try {
      final currentTotalReps = _completedReps.fold(0, (sum, reps) => sum + reps) + _currentReps;
      if (currentTotalReps >= 50 || currentTotalReps >= 100 || currentTotalReps >= 150) {
        final achievements = await AchievementService.checkAchievements();
        _newlyUnlockedAchievements.addAll(achievements);
      }
    } catch (e) {
      debugPrint('업적 확인 실패: $e');
    }
  }

  void _markSetCompleted() {
    setState(() {
      _completedReps[_currentSet] = _currentReps;
      _isSetCompleted = true;
    });
    HapticFeedback.mediumImpact();
    _saveCurrentProgress();
  }

  void _startRestTimer() {
    setState(() {
      _isRestTime = true;
      _restTimeRemaining = _restTimeSeconds;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _restTimeRemaining--;
      });

      if (_restTimeRemaining <= 0) {
        timer.cancel();
        _moveToNextSet();
      }
    });
  }

  void _moveToNextSet() {
    setState(() {
      _currentSet++;
      _currentReps = 0;
      _isSetCompleted = false;
      _isRestTime = false;
    });
  }

  void _completeWorkout() async {
    debugPrint('🔥 _completeWorkout 함수 호출됨');
    try {
      // 워크아웃 기록 저장
      final totalCompletedReps = _completedReps.fold(0, (sum, reps) => sum + reps);
      debugPrint('🔥 총 완료된 횟수: $totalCompletedReps');
      final history = WorkoutHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        workoutTitle: widget.workout.title ?? '${widget.workout.week ?? 1}주차 - ${widget.workout.day ?? 1}일차',
        targetReps: _targetReps,
        completedReps: _completedReps,
        totalReps: totalCompletedReps,
        completionRate: _targetReps.fold(0, (sum, reps) => sum + reps) > 0
            ? totalCompletedReps / _targetReps.fold(0, (sum, reps) => sum + reps)
            : 0.0,
        level: 'Rising', // 임시값
        duration: _workoutStartTime != null
          ? DateTime.now().difference(_workoutStartTime!)
          : const Duration(minutes: 10),
      );

      // 운동 기록 저장
      try {
        await WorkoutHistoryService.saveWorkoutHistory(history);
        debugPrint('🔥 운동 기록 저장 완료');
      } catch (e) {
        debugPrint('❌ 운동 기록 저장 중 오류: $e');
        // 저장 실패 시 간단한 버전으로 대체
        try {
          final prefs = await SharedPreferences.getInstance();
          final historyJson = jsonEncode({
            'id': history.id,
            'date': history.date.toIso8601String(),
            'workoutTitle': history.workoutTitle,
            'totalReps': history.totalReps,
            'completionRate': history.completionRate,
          });

          final historyList = prefs.getStringList('workout_history') ?? [];
          historyList.add(historyJson);
          await prefs.setStringList('workout_history', historyList);
          debugPrint('🔥 운동 기록 저장 완료 (대체 버전)');
        } catch (e2) {
          debugPrint('❌ 대체 저장도 실패: $e2');
        }
      }

      // 세션 정리
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('current_workout_session');
      } catch (e) {
        debugPrint('❌ 세션 정리 중 오류: $e');
      }

      // 업적 확인 (완료된 운동 기록으로)
      try {
        debugPrint('🎯 업적 확인 시작 - 총 횟수: $totalCompletedReps');

        // AchievementService에 운동 완료 알림
        await AchievementService.onWorkoutCompleted(
          totalReps: totalCompletedReps,
          workoutType: 'pushup', // 기본값
          completionRate: history.completionRate,
        );

        final achievements = await AchievementService.checkAchievements();
        _newlyUnlockedAchievements.addAll(achievements);
        debugPrint('🔥 업적 확인 완료: ${achievements.length}개 새로 달성');

        // 즉시 업적 이벤트 저장 (MainNavigationScreen에서 표시용)
        if (achievements.isNotEmpty) {
          await AchievementService.addPendingAchievementEvents(achievements);
          debugPrint('✅ 업적 이벤트 저장 완료');
        }

      } catch (e) {
        debugPrint('❌ 업적 확인 중 오류 발생: $e');
        // 업적 확인 오류는 무시하고 계속 진행
      }

      // 완료 다이얼로그 표시
      debugPrint('🔥 다이얼로그 표시 시도 중...');
      _showWorkoutCompleteDialog();
    } catch (e) {
      debugPrint('❌ 운동 완료 처리 실패: $e');

      // 오류 발생 시 사용자에게 알림
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Localizations.localeOf(context).languageCode == 'ko'
                ? '오류가 발생했습니다: $e'
                : 'Error occurred: $e',
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showWorkoutCompleteDialog() {
    debugPrint('🔥 _showWorkoutCompleteDialog 함수 호출됨');
    if (!mounted) {
      debugPrint('❌ Widget이 mount되지 않음');
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          debugPrint('🔥 다이얼로그 builder 호출됨');
          return AlertDialog(
        title: Text(
          Localizations.localeOf(context).languageCode == 'ko'
            ? '🎉 운동 완료!'
            : '🎉 Workout Complete!',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Localizations.localeOf(context).languageCode == 'ko'
                ? '훌륭합니다! 오늘의 운동을 완료했습니다.'
                : 'Great job! You completed today\'s workout.',
            ),
            const SizedBox(height: 16),
            Text(
              Localizations.localeOf(context).languageCode == 'ko'
                ? '총 횟수: ${_completedReps.fold(0, (sum, reps) => sum + reps)}개'
                : 'Total reps: ${_completedReps.fold(0, (sum, reps) => sum + reps)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (_newlyUnlockedAchievements.isNotEmpty) {
                _showAchievementsDialog();
              } else {
                _finishWorkout();
              }
            },
            child: Text(
              Localizations.localeOf(context).languageCode == 'ko'
                ? '확인'
                : 'OK',
            ),
          ),
        ],
          );
        },
      );
      debugPrint('🔥 다이얼로그 표시 완료');
    } catch (e) {
      debugPrint('❌ 다이얼로그 표시 실패: $e');

      // 사용자에게 오류 알림
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Localizations.localeOf(context).languageCode == 'ko'
                ? '운동 완료 화면을 표시할 수 없습니다. 홈으로 돌아갑니다.'
                : 'Cannot show completion dialog. Returning to home.',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
      }

      // 다이얼로그 표시 실패 시 직접 완료 처리
      if (_newlyUnlockedAchievements.isNotEmpty) {
        _showAchievementsDialog();
      } else {
        _finishWorkout();
      }
    }
  }

  void _showAchievementsDialog() {
    showDialog(
      context: context,
      builder: (context) => MultipleAchievementsDialog(
        achievements: _newlyUnlockedAchievements,
        onDismiss: _finishWorkout,
      ),
    );
  }

  Future<void> _finishWorkout() async {
    debugPrint('🏁 _finishWorkout 시작 - 진행률 및 경험치 업데이트');

    try {
      // 1. 프로그램 진행률 업데이트
      await _updateProgramProgress();

      // 2. 차드 경험치 업데이트
      await _updateChadExperience();

      // 3. 스트릭 업데이트
      await _updateStreak();

      debugPrint('✅ 모든 업데이트 완료');

    } catch (e) {
      debugPrint('❌ 업데이트 중 오류: $e');
    }

    // 워크아웃 완료 콜백 호출
    widget.onWorkoutCompleted?.call();
    Navigator.pop(context);
  }

  Future<void> _updateProgramProgress() async {
    try {
      debugPrint('📈 프로그램 진행률 업데이트 시작');

      // WorkoutProgramService를 사용하여 현재 운동 완료 처리
      await WorkoutProgramService.markWorkoutCompleted(
        widget.workout.week ?? 1,
        widget.workout.day ?? 1,
      );

      debugPrint('✅ 프로그램 진행률 업데이트 완료');
    } catch (e) {
      debugPrint('❌ 프로그램 진행률 업데이트 실패: $e');
    }
  }

  Future<void> _updateChadExperience() async {
    try {
      debugPrint('💪 차드 경험치 업데이트 시작');

      final chadService = Provider.of<ChadEvolutionService>(context, listen: false);
      final totalReps = _completedReps.fold(0, (sum, reps) => sum + reps);

      // 운동 완료로 경험치 획득 (총 횟수에 비례)
      final baseXP = 50; // 기본 운동 완료 경험치
      final repBonus = (totalReps * 0.5).round(); // 횟수당 0.5 경험치
      final totalXP = baseXP + repBonus;

      await chadService.addExperience(totalXP);

      debugPrint('✅ 차드 경험치 업데이트 완료: +${totalXP}XP (기본 $baseXP + 보너스 $repBonus)');
    } catch (e) {
      debugPrint('❌ 차드 경험치 업데이트 실패: $e');
    }
  }

  Future<void> _updateStreak() async {
    try {
      debugPrint('🔥 스트릭 업데이트 시작');

      await StreakService.updateWorkoutStreak();

      debugPrint('✅ 스트릭 업데이트 완료');
    } catch (e) {
      debugPrint('❌ 스트릭 업데이트 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.width > 600;
    final isLargeTablet = mediaQuery.size.width > 900;

    return Scaffold(
      backgroundColor: Color(
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      ),
      appBar: AppBar(
        title: Text(
          widget.workout.title ??
          (Localizations.localeOf(context).languageCode == 'ko' ? '운동' : 'Workout'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitConfirmation(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: Column(
                children: [
                  // 운동 헤더
                  WorkoutHeaderWidget(
                    workoutTitle: widget.workout.title ?? '',
                    currentSet: _currentSet,
                    totalSets: _totalSets,
                    currentTargetReps: _currentTargetReps,
                    overallProgress: _overallProgress,
                    isTablet: isTablet,
                    isLargeTablet: isLargeTablet,
                  ),

                  const SizedBox(height: AppConstants.paddingXL),

                  // 메인 컨텐츠 - 휴식 타이머 또는 횟수 카운터
                  if (_isRestTime)
                    RestTimerWidget(
                      restTimeRemaining: _restTimeRemaining,
                      restTimeSeconds: _restTimeSeconds,
                      onSkipRest: _onSkipRest,
                    )
                  else
                    RepCounterWidget(
                      currentReps: _currentReps,
                      targetReps: _currentTargetReps,
                      isSetCompleted: _isSetCompleted,
                      onRepsChanged: _onRepsChanged,
                      onSetCompleted: _onSetCompleted,
                      onAchievementCheck: _checkAchievementsDuringWorkout,
                    ),

                  const SizedBox(height: AppConstants.paddingXL),

                  // 컨트롤 버튼들
                  WorkoutControlsWidget(
                    isRestTime: _isRestTime,
                    isSetCompleted: _isSetCompleted,
                    currentSet: _currentSet,
                    totalSets: _totalSets,
                    currentReps: _currentReps,
                    onSkipRest: _onSkipRest,
                    onStartRest: _onStartRest,
                    onCompleteWorkout: _onCompleteWorkout,
                    onMarkSetCompleted: _onMarkSetCompleted,
                  ),
                ],
              ),
            ),
          ),

          // 하단 배너 광고
          const AdBannerWidget(),
        ],
      ),
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          Localizations.localeOf(context).languageCode == 'ko'
            ? '운동 종료'
            : 'Exit Workout',
        ),
        content: Text(
          Localizations.localeOf(context).languageCode == 'ko'
            ? '정말로 운동을 종료하시겠습니까? 진행률이 저장됩니다.'
            : 'Are you sure you want to exit? Your progress will be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              Localizations.localeOf(context).languageCode == 'ko'
                ? '취소'
                : 'Cancel',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _saveCurrentProgress().then((_) => Navigator.pop(context));
            },
            child: Text(
              Localizations.localeOf(context).languageCode == 'ko'
                ? '종료'
                : 'Exit',
            ),
          ),
        ],
      ),
    );
  }
}