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

  // 워크아웃 데이터
  List<int> _targetReps = [];
  int _totalSets = 0;
  int _currentTargetReps = 0;
  DateTime? _workoutStartTime;

  // 업적 관련
  List<Achievement> _newlyUnlockedAchievements = [];

  // 챌린지 관련
  List<dynamic> _completedChallenges = [];

  // 워크아웃 완료 결과
  int _xpGained = 0;

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
    if (widget.workout.workout != null && widget.workout.workout.isNotEmpty) {
      _targetReps = List<int>.from(widget.workout.workout);
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
      SnackBar(content: Text(AppLocalizations.of(context)!.workoutProcessing)),
    );
    // 햅틱 피드백
    HapticFeedback.heavyImpact();
    _completeWorkout();
  }

  void _onMarkSetCompleted() {
    _markSetCompleted();
  }

  void _completeWorkout() async {
    debugPrint('🔥 _completeWorkout 함수 호출됨');

    try {
      // WorkoutCompletionHandler로 완료 처리 위임
      final handler = WorkoutCompletionHandler(
        context: context,
        workout: widget.workout,
        completedReps: _completedReps,
        targetReps: _targetReps,
        workoutStartTime: _workoutStartTime,
      );

      final result = await handler.completeWorkout();

      if (result.success) {
        // 새로 달성한 업적이 있으면 저장
        if (result.hasNewAchievements) {
          _newlyUnlockedAchievements.addAll(result.newAchievements);
        }

        // 완료된 챌린지가 있으면 저장
        if (result.hasCompletedChallenges) {
          _completedChallenges.addAll(result.completedChallenges);
        }

        // XP 정보 저장
        _xpGained = result.xpGained;

        debugPrint('🔥 운동 완료 처리 성공 - XP 획득: ${result.xpGained}, 업적: ${result.newAchievements.length}개');
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

  void _showWorkoutCompleteDialog() async {
    try {
      debugPrint('🔥 다이얼로그 표시 시작');

      // 프로그램 진행률 및 내일 휴식일 정보 가져오기
      final prefs = await SharedPreferences.getInstance();
      final completedWorkouts = prefs.getStringList('completed_workouts') ?? [];
      final totalDays = 84; // 12주 * 7일
      final progressPercentage = (completedWorkouts.length / totalDays * 100).round();

      // 내일 휴식일 여부 확인 (사용자 설정 고려)
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      bool isTomorrowRestDay = false;

      // 사용자 설정된 운동 리마인더 확인
      final settingsJson = prefs.getString('workout_reminder_settings');
      if (settingsJson != null) {
        try {
          final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
          final activeDays = (settingsMap['activeDays'] as List?)?.cast<int>() ?? [];
          isTomorrowRestDay = !activeDays.contains(tomorrow.weekday);
        } catch (e) {
          // 설정 로드 실패 시 기본 주말 체크
          isTomorrowRestDay = tomorrow.weekday == 6 || tomorrow.weekday == 7;
        }
      } else {
        // 설정이 없으면 기본 주말 체크
        isTomorrowRestDay = tomorrow.weekday == 6 || tomorrow.weekday == 7;
      }

      // 운동 시간 계산
      final workoutDuration = _workoutStartTime != null
        ? DateTime.now().difference(_workoutStartTime!)
        : const Duration(minutes: 10);
      final minutes = workoutDuration.inMinutes;
      final seconds = workoutDuration.inSeconds % 60;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.red, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '💀 WORKOUT DESTROYED! 💀',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🔥 FXXK YEAH! 오늘의 운동 완전 파괴! 만삣삐! 💪',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // 운동 통계
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '💀 파괴된 횟수',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${_completedReps.fold(0, (sum, reps) => sum + reps)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '💰 획득 XP',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '+${_xpGained} XP',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '⏱️ 소멸 시간',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${minutes}분 ${seconds}초',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 프로그램 진행률
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '🚀 CHAD 진화 진행률',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progressPercentage / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$progressPercentage% (${completedWorkouts.length}/$totalDays일)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 완료된 챌린지 (있을 때만 표시)
                  if (_completedChallenges.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.purple, width: 2),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.emoji_events, color: Colors.purple, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '🏆 챌린지 완료! 🏆',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...(_completedChallenges.take(2).map((challenge) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                '🎯 ${challenge.title ?? challenge.titleKey}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.purple[600],
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )),
                          if (_completedChallenges.length > 2)
                            Text(
                              '외 ${_completedChallenges.length - 2}개 더!',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.purple[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // 새로 달성한 업적 (있을 때만 표시)
                  if (_newlyUnlockedAchievements.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber, width: 2),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '🏆 새로운 업적 달성! 🏆',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...(_newlyUnlockedAchievements.take(2).map((achievement) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                '🌟 ${achievement.titleKey}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.amber[600],
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )),
                          if (_newlyUnlockedAchievements.length > 2) ...[
                            Text(
                              '외 ${_newlyUnlockedAchievements.length - 2}개 더!',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.amber[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                _showAchievementsDialog();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '✨ 모든 업적 보기',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // 내일 휴식일 안내
                  if (isTomorrowRestDay)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.purple, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '😴 내일은 CHAD 휴식일! 😴',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[700],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '🌴 완전한 회복으로 더 강한 CHAD가 되자! 💪',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.purple[600],
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '🔥 내일도 BEAST MODE! 🔥',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[700],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '💀 LEGENDARY 경지로의 여정은 계속된다! 💀',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[600],
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _finishWorkout();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '🔥 FXXK YEAH! 🔥',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
            child: Text(
              AppLocalizations.of(context)!.cancelButton,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.exitButton,
            ),
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
          widget.workout.title ??
          AppLocalizations.of(context)!.workoutTitle,
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
                    overallProgress: _currentSet / _totalSets,
                  ),

                  const SizedBox(height: AppConstants.paddingL),

                  // 현재 세트 상태에 따라 위젯 표시
                  if (_isRestTime)
                    RestTimerWidget(
                      restTimeRemaining: _restTimeRemaining,
                      restTimeSeconds: 60,
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
                      targetReps: _currentTargetReps,
                      isSetCompleted: _isSetCompleted,
                      onRepsChanged: (reps) {
                        setState(() {
                          _currentReps = reps;
                        });
                      },
                      onSetCompleted: _onMarkSetCompleted,
                    ),

                  const SizedBox(height: AppConstants.paddingL),

                  // 운동 컨트롤
                  WorkoutControlsWidget(
                    isRestTime: _isRestTime,
                    isSetCompleted: _isSetCompleted,
                    currentSet: _currentSet,
                    totalSets: _totalSets,
                    currentReps: _currentReps,
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
                    onStartRest: _onMarkSetCompleted,
                    onCompleteWorkout: _onCompleteWorkout,
                    onMarkSetCompleted: _onMarkSetCompleted,
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