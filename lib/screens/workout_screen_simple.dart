import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../generated/app_localizations.dart';
import '../utils/constants.dart';
import '../models/achievement.dart';
import '../widgets/ad_banner_widget.dart';
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
  final int _restTimeSeconds = 60;
  Timer? _restTimer;

  // 워크아웃 데이터
  List<int> _targetReps = [];
  int _totalSets = 0;
  int _currentTargetReps = 0;
  DateTime? _workoutStartTime;

  // 업적 관련
  final List<Achievement> _newlyUnlockedAchievements = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeWorkout();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _restTimer?.cancel();
    super.dispose();
  }

  void _initializeWorkout() {
    _workoutStartTime = DateTime.now();

    // 타겟 횟수 설정
    if (widget.workout.workout != null &&
        (widget.workout.workout as List).isNotEmpty) {
      _targetReps = List<int>.from(widget.workout.workout as List);
    } else {
      _targetReps = [10, 8, 6, 4, 2]; // 기본값
    }

    _totalSets = _targetReps.length;
    _currentTargetReps = _targetReps.isNotEmpty ? _targetReps[0] : 10;
    _completedReps = List.filled(_totalSets, 0);

    debugPrint('워크아웃 초기화: $_targetReps');
  }

  void _onCompleteWorkout() {
    // 즉각적인 시각적 피드백
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).workoutProcessing)),
    );
    // 햅틱 피드백
    HapticFeedback.heavyImpact();
    _completeWorkout();
  }

  void _onMarkSetCompleted() {
    _markSetCompleted();
  }

  void _completeSet() {
    _markSetCompleted();
  }

  void _skipRest() {
    setState(() {
      _restTimeRemaining = 0;
      _isRestTime = false;
    });
  }

  void _completeWorkout() async {
    debugPrint('🔥 _completeWorkout 함수 호출됨');

    try {
      // WorkoutCompletionHandler로 완료 처리 위임
      final handler = WorkoutCompletionHandler(
        completedReps: _completedReps,
        context: context,
        workout: widget.workout,
        targetReps: _targetReps,
        workoutStartTime: _workoutStartTime,
      );

      final result = await handler.completeWorkout();

      if (result.success) {
        // 새로 달성한 업적이 있으면 저장
        if (result.hasNewAchievements) {
          _newlyUnlockedAchievements.addAll(result.newAchievements);
        }

        debugPrint(
          '🔥 운동 완료 처리 성공 - XP 획득: ${result.xpGained}, 업적: ${result.newAchievements.length}개',
        );
        _showWorkoutCompleteDialog();
      } else {
        throw Exception(result.error ?? '알 수 없는 오류');
      }
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

      // 오류 시에도 워크아웃 종료
      _finishWorkout();
    }
  }

  void _markSetCompleted() {
    if (_currentSet < _totalSets) {
      setState(() {
        _completedReps[_currentSet] = _currentReps;
        _isSetCompleted = true;
        _isRestTime = true;
        _restTimeRemaining = 60; // 60초 휴식
      });

      _startRestTimer();

      if (_currentSet == _totalSets - 1) {
        // 마지막 세트 완료
        _completeWorkout();
      } else {
        // 다음 세트로 이동
        Future.delayed(Duration(seconds: _restTimeRemaining), () {
          if (mounted) {
            setState(() {
              _currentSet++;
              _currentTargetReps = _currentSet < _targetReps.length
                  ? _targetReps[_currentSet]
                  : 10;
              _currentReps = 0;
              _isSetCompleted = false;
              _isRestTime = false;
            });
          }
        });
      }
    }
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restTimeRemaining > 0) {
        setState(() {
          _restTimeRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isRestTime = false;
        });
      }
    });
  }

  void _showWorkoutCompleteDialog() {
    try {
      debugPrint('🔥 다이얼로그 표시 시작');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                const SizedBox(width: 8),
                Text(
                  Localizations.localeOf(context).languageCode == 'ko'
                      ? '운동 완료!'
                      : 'Workout Complete!',
                ),
              ],
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
                child: Text(AppLocalizations.of(context).okButton),
              ),
            ],
          );
        },
      );
      debugPrint('🔥 다이얼로그 표시 완료');
    } catch (e) {
      debugPrint('❌ 다이얼로그 표시 실패: $e');
      _finishWorkout();
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

  void _finishWorkout() {
    widget.onWorkoutCompleted?.call();
    Navigator.pop(context);
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
              ? '운동을 종료하시겠습니까? 진행 상황이 저장되지 않습니다.'
              : 'Are you sure you want to exit? Your progress will not be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancelButton),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).exitButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Color(
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      ),
      appBar: AppBar(
        title: Text(
          (widget.workout.title as String?) ??
              AppLocalizations.of(context).workoutTitle,
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
                    overallProgress: _currentSet / _totalSets,
                    workoutTitle: (widget.workout.title as String?) ?? '',
                    currentSet: _currentSet,
                    totalSets: _totalSets,
                    currentTargetReps: _currentTargetReps,
                  ),

                  const SizedBox(height: AppConstants.paddingL),

                  // 현재 세트 상태에 따라 위젯 표시
                  if (_isRestTime)
                    RestTimerWidget(
                      restTimeSeconds: _restTimeSeconds,
                      restTimeRemaining: _restTimeRemaining,
                      onSkipRest: () {
                        setState(() {
                          _currentSet++;
                          _currentTargetReps = _currentSet < _targetReps.length
                              ? _targetReps[_currentSet]
                              : 10;
                          _currentReps = 0;
                          _isSetCompleted = false;
                          _isRestTime = false;
                        });
                      },
                    )
                  else
                    RepCounterWidget(
                      currentReps: _currentReps,
                      isSetCompleted: _isSetCompleted,
                      onSetCompleted: _completeSet,
                      targetReps: _currentTargetReps,
                      onRepsChanged: (reps) {
                        setState(() {
                          _currentReps = reps;
                        });
                      },
                    ),

                  const SizedBox(height: AppConstants.paddingL),

                  // 운동 컨트롤
                  WorkoutControlsWidget(
                    isSetCompleted: _isSetCompleted,
                    isRestTime: _isRestTime,
                    currentSet: _currentSet,
                    totalSets: _totalSets,
                    currentReps: _currentReps,
                    onSkipRest: _skipRest,
                    onStartRest: () {
                      setState(() {
                        _isRestTime = true;
                        _restTimeRemaining = _restTimeSeconds;
                      });
                      _startRestTimer();
                    },
                    onMarkSetCompleted: _onMarkSetCompleted,
                    onCompleteWorkout: _onCompleteWorkout,
                  ),
                ],
              ),
            ),
          ),

          // 하단 광고
          const AdBannerWidget(),
        ],
      ),
    );
  }
}
