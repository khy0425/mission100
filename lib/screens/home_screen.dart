import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../services/workout_program_service.dart';
import '../services/notification_service.dart';
import '../services/workout_history_service.dart';
import '../services/chad_evolution_service.dart';
import '../services/achievement_service.dart';
import '../screens/workout_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/pushup_tutorial_screen.dart';
import '../screens/pushup_form_guide_screen.dart';
import '../screens/progress_tracking_screen.dart';
import '../models/user_profile.dart';
import '../models/chad_evolution.dart';
import '../models/workout_history.dart';
import '../utils/constants.dart';
import '../widgets/ad_banner_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/chad_translation_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 분리된 위젯들 import
import 'home/widgets/chad_section_widget.dart';
import 'home/widgets/today_mission_card_widget.dart';
import 'home/widgets/progress_card_widget.dart';
import 'home/widgets/achievement_stats_widget.dart';
import 'home/widgets/action_buttons_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final DatabaseService _databaseService = DatabaseService();
  final WorkoutProgramService _workoutProgramService = WorkoutProgramService();

  UserProfile? _userProfile;
  dynamic _todayWorkout; // 서비스에서 가져오는 타입 사용
  dynamic _programProgress; // 서비스에서 가져오는 타입 사용
  WorkoutHistory? _todayCompletedWorkout; // 실제 모델 사용
  bool _isLoading = true;
  String? _errorMessage;

  // 업적 통계
  int _totalXP = 0;
  int _unlockedCount = 0;
  int _totalCount = 0;

  // 반응형 디자인을 위한 변수들
  bool get _isTablet => MediaQuery.of(context).size.width > 600;
  bool get _isLargeTablet => MediaQuery.of(context).size.width > 900;

  double get _chadImageSize {
    if (_isLargeTablet) return 200.0;
    if (_isTablet) return 160.0;
    return 120.0;
  }

  double get _titleFontSize {
    if (_isLargeTablet) return 32.0;
    if (_isTablet) return 28.0;
    return 24.0;
  }

  double get _subtitleFontSize {
    if (_isLargeTablet) return 20.0;
    if (_isTablet) return 18.0;
    return 16.0;
  }

  double get _cardPadding {
    if (_isLargeTablet) return 32.0;
    if (_isTablet) return 24.0;
    return 16.0;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshAllServiceData();
  }

  @override
  void dispose() {
    // 콜백 제거하여 메모리 누수 방지
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 홈 화면이 다시 active 될 때마다 새로고침
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _refreshAllServiceData();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 앱이 포그라운드로 돌아왔을 때 데이터 새로고침
      _refreshAllServiceData();
      // 보류 중인 알림 체크
      NotificationService.checkPendingNotifications();
    }
  }

  // 운동 저장 시 호출될 콜백 메서드
  void _onWorkoutSaved() {
    if (mounted) {
      debugPrint('🏠 홈 화면: 운동 기록 저장 감지, 데이터 새로고침 시작');
      _refreshAllServiceData();
    } else {
      debugPrint('⚠️ 홈 화면: mounted가 false이므로 콜백 무시');
    }
  }

  // 업적 통계 로드
  Future<void> _loadAchievementStats() async {
    try {
      debugPrint('🏆 업적 통계 로드 시작');

      _totalXP = await AchievementService.getTotalXP();
      _unlockedCount = await AchievementService.getUnlockedCount();
      _totalCount = await AchievementService.getTotalCount();

      debugPrint('🏆 업적 통계: XP=$_totalXP, 달성=$_unlockedCount/$_totalCount');
    } catch (e) {
      debugPrint('❌ 업적 통계 로드 실패: $e');
      // 기본값 유지
      _totalXP = 0;
      _unlockedCount = 0;
      _totalCount = 0;
    }
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint('🏠 홈 화면: 사용자 데이터 로드 시작');

      // 업적 통계 먼저 로드
      await _loadAchievementStats();

      // 사용자 프로필 로드
      final profile = await _databaseService.getUserProfile();
      debugPrint('👤 사용자 프로필: $profile');

      // 프로필이 null이면 기본 프로필 생성
      final userProfile = profile ?? UserProfile(
        id: 1,
        level: UserLevel.rising,
        initialMaxReps: 10,
        startDate: DateTime.now(),
      );

      // 오늘의 운동 로드
      final workout = await _workoutProgramService.getTodayWorkout(userProfile);
      debugPrint('🏋️ 오늘의 운동: $workout');

      // 프로그램 진행률 로드
      final progress = await _workoutProgramService.getProgress(userProfile);
      debugPrint('📈 프로그램 진행률: $progress');

      // 오늘 완료된 운동 기록 확인
      final today = DateTime.now();
      final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final completedWorkout = await WorkoutHistoryService.getTodayCompletedWorkout(todayString);
      debugPrint('✅ 오늘 완료된 운동: $completedWorkout');

      if (mounted) {
        setState(() {
          _userProfile = userProfile;
          _todayWorkout = workout;
          _programProgress = progress;
          _todayCompletedWorkout = completedWorkout;
          _isLoading = false;
        });
      }

      debugPrint('✅ 홈 화면: 사용자 데이터 로드 완료');
    } catch (e) {
      debugPrint('❌ 홈 화면: 사용자 데이터 로드 실패: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  /// 모든 서비스 데이터 새로고침 (Chad 진화 상태 포함)
  Future<void> _refreshAllServiceData() async {
    if (!mounted) return;

    try {
      debugPrint('🔄 홈 화면: 모든 서비스 데이터 새로고침 시작');

      // Chad Evolution Service 상태 업데이트
      final chadService = Provider.of<ChadEvolutionService>(context, listen: false);
      await chadService.refreshEvolutionState();
      debugPrint('🦾 Chad 진화 상태 새로고침 완료');

      // 나머지 데이터 새로고침
      await _refreshData();

      debugPrint('✅ 홈 화면: 모든 서비스 데이터 새로고침 완료');
    } catch (e) {
      debugPrint('❌ 홈 화면: 서비스 데이터 새로고침 실패: $e');
    }
  }

  Future<void> _refreshData() async {
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                ? [
                    Color(AppColors.chadGradient[0]),
                    Color(AppColors.chadGradient[1]),
                  ]
                : [
                    Colors.white,
                    const Color(0xFFF5F5F5),
                  ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 50,
                  color: Color(AppColors.primaryColor),
                ),
              ),
              const SizedBox(height: AppConstants.paddingL),
              Text(
                AppLocalizations.of(context)!.loadingText,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: _subtitleFontSize,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homeTitle),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: _refreshData,
            onLongPress: _refreshAllServiceData,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.refresh,
                color: theme.appBarTheme.iconTheme?.color ?? theme.iconTheme.color,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 메인 콘텐츠 영역
          Expanded(
            child: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppConstants.paddingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_isLoading)
                        _buildLoadingWidget()
                      else if (_errorMessage != null)
                        _buildErrorWidget()
                      else if (_userProfile == null)
                        _buildNoUserWidget() // 프로필 생성 필요
                      else ...[
                        // Chad 이미지 및 환영 메시지
                        ChadSectionWidget(chadImageSize: _chadImageSize),

                        const SizedBox(height: AppConstants.paddingXL),

                        // 오늘의 미션 카드
                        TodayMissionCardWidget(
                          todayWorkout: _todayWorkout,
                          todayCompletedWorkout: _todayCompletedWorkout,
                          onStartWorkout: () => _startTodayWorkout(context),
                        ),

                        const SizedBox(height: AppConstants.paddingL),

                        // 진행 상황 카드
                        ProgressCardWidget(programProgress: _programProgress),

                        const SizedBox(height: AppConstants.paddingL),

                        // 업적 통계 카드
                        AchievementStatsWidget(
                          totalXP: _totalXP,
                          unlockedCount: _unlockedCount,
                          totalCount: _totalCount,
                        ),

                        const SizedBox(height: AppConstants.paddingL),

                        // 추가 기능 버튼들
                        ActionButtonsWidget(
                          onTutorialPressed: () => _openTutorial(context),
                          onFormGuidePressed: () => _openFormGuide(context),
                          onProgressTrackingPressed: () => _openProgressTracking(context),
                        ),

                        const SizedBox(height: AppConstants.paddingL),

                        // 하단 정보
                        _buildBottomInfo(context, theme),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 하단 배너 광고
          const AdBannerWidget(),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: 400,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: 400,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            AppLocalizations.of(context)!.errorOccurred,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            _errorMessage ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingL),
          ElevatedButton(
            onPressed: _refreshData,
            child: Text(
              AppLocalizations.of(context)!.retryButton,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoUserWidget() {
    return Container(
      height: 400,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_add,
            size: 64,
            color: Colors.blue[400],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            AppLocalizations.of(context)!.pleaseCreateProfile,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            AppLocalizations.of(context)!.userProfileRequired,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingL),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
            child: Text(
              AppLocalizations.of(context)!.goToSettings,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: AppConstants.paddingS),
              Text(
                AppLocalizations.of(context)!.workoutTips,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            AppLocalizations.of(context)!.workoutTipsContent,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _startTodayWorkout(BuildContext context) async {
    if (_todayWorkout != null) {
      // 연속 운동 차단 로직 확인
      final canWorkoutToday = await _checkIfCanWorkoutToday();

      if (!canWorkoutToday) {
        // 연속 운동 차단 다이얼로그 표시
        _showConsecutiveWorkoutBlockDialog(context);
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutScreen(
            workout: _todayWorkout!,
            onWorkoutCompleted: _onWorkoutSaved,
          ),
        ),
      ).then((_) {
        // 운동 화면에서 돌아온 후 데이터 새로고침
        _refreshAllServiceData();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.todayWorkoutNotAvailable,
          ),
        ),
      );
    }
  }

  /// 오늘 운동할 수 있는지 확인 (연속 운동 차단)
  Future<bool> _checkIfCanWorkoutToday() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      // 어제 운동 기록이 있는지 확인
      final yesterdayKey = 'workout_${yesterday.year}_${yesterday.month}_${yesterday.day}';
      final dailyCompletedWorkouts = prefs.getStringList('daily_completed_workouts') ?? [];

      // 어제 운동했으면 오늘은 운동 불가
      if (dailyCompletedWorkouts.contains(yesterdayKey)) {
        debugPrint('🚫 연속 운동 차단: 어제 ${yesterday.toString().split(' ')[0]}에 운동함');
        return false;
      }

      debugPrint('✅ 운동 가능: 어제 운동하지 않음 (${dailyCompletedWorkouts.length}개 기록 확인함)');
      return true;
    } catch (e) {
      debugPrint('❌ 연속 운동 확인 실패: $e');
      // 오류 시에는 안전하게 운동 허용
      return true;
    }
  }

  /// 연속 운동 차단 다이얼로그 표시
  void _showConsecutiveWorkoutBlockDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange, size: 28),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.consecutiveWorkoutBlocked,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.consecutiveWorkoutMessage.replaceAll('\\n', '\n'),
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.chadRestModeToday,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _openTutorial(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PushupTutorialScreen()),
    );
  }

  void _openFormGuide(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PushupFormGuideScreen()),
    );
  }

  void _openProgressTracking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProgressTrackingScreen(userProfile: _userProfile!)),
    );
  }
}