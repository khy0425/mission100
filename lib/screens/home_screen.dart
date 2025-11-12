import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import '../generated/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/data/database_service.dart';
import '../services/workout/workout_program_service.dart';
import '../services/workout/lucid_dream_program_service.dart'; // 자각몽 프로그램 서비스
import '../services/notification/notification_service.dart';
import '../services/workout/workout_history_service.dart';
import '../services/workout/checklist_history_service.dart'; // 체크리스트 히스토리 서비스
import '../services/chad/chad_evolution_service.dart';
import '../services/achievements/achievement_service.dart';
import '../screens/lucid_dream_checklist_screen.dart'; // 자각몽 체크리스트 화면
import '../screens/settings/simple_settings_screen.dart';
// Tutorial screens removed for MVP - not needed for lucid dream app
// import '../screens/exercise/pushup_tutorial_screen.dart';
// import '../screens/exercise/pushup_form_guide_screen.dart';
import '../screens/progress/progress_tracking_screen.dart';
import '../models/user_profile.dart';

import '../models/workout_history.dart';
import '../utils/config/constants.dart';
import '../widgets/common/ad_banner_widget.dart';

// 분리된 위젯들 import
import 'home/widgets/today_mission_card_widget.dart';
import 'home/widgets/progress_card_widget.dart';
import 'home/widgets/achievement_stats_widget.dart';
import 'home/widgets/action_buttons_widget.dart';
// Chad removed for DreamFlow - lucid dreaming app
// import '../widgets/chad/chad_stats_card.dart';
// import '../models/chad_evolution.dart';
import '../widgets/common/vip_badge_widget.dart';
import '../models/user_subscription.dart';
import '../services/auth/auth_service.dart';
import '../services/ai/conversation_token_service.dart';
import '../widgets/ai/token_balance_widget.dart';
import 'ai/analysis_mode_selection_screen.dart';
import 'ai/lucid_dream_ai_assistant_screen.dart'; // AI 어시스턴트

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final DatabaseService _databaseService = DatabaseService();
  final WorkoutProgramService _workoutProgramService = WorkoutProgramService();
  final LucidDreamProgramService _lucidDreamProgramService = LucidDreamProgramService(); // 자각몽 프로그램 서비스

  UserProfile? _userProfile;
  dynamic _todayWorkout; // 서비스에서 가져오는 타입 사용 (또는 TodayChecklist)
  dynamic _programProgress; // 서비스에서 가져오는 타입 사용
  WorkoutHistory? _todayCompletedWorkout; // 실제 모델 사용
  TodayChecklist? _todayChecklist; // 자각몽 체크리스트
  bool _isLoading = true;
  String? _errorMessage;

  // 업적 통계
  int _totalXP = 0;
  int _unlockedCount = 0;
  int _totalCount = 0;

  // Chad 통계 - DreamFlow에서는 사용 안 함
  // ChadStats? _chadStats;

  // 반응형 디자인을 위한 변수들
  bool get _isTablet => MediaQuery.of(context).size.width > 600;
  bool get _isLargeTablet => MediaQuery.of(context).size.width > 900;

  double get _subtitleFontSize {
    if (_isLargeTablet) return 20.0;
    if (_isTablet) return 18.0;
    return 16.0;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 체크리스트 완료 시 홈 화면 새로고침을 위한 콜백 등록
    ChecklistHistoryService.addOnChecklistSavedCallback(_onWorkoutSaved);
    debugPrint('🏠 홈 화면: 체크리스트 완료 콜백 등록');

    _refreshAllServiceData();

    // 일일 보상 확인 (약간의 지연 후 실행)
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _checkDailyReward();
      }
    });
  }

  @override
  void dispose() {
    // 콜백 제거하여 메모리 누수 방지
    ChecklistHistoryService.removeOnChecklistSavedCallback(_onWorkoutSaved);
    debugPrint('🏠 홈 화면: 체크리스트 완료 콜백 제거');

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

  // Chad 통계 로드 - DreamFlow에서는 사용 안 함
  // Future<void> _loadChadStats() async {
  //   try {
  //     debugPrint('💪 Chad 통계 로드 시작');
  //     final chadService = Provider.of<ChadEvolutionService>(
  //       context,
  //       listen: false,
  //     );
  //     final stats = await chadService.getCurrentChadStats();
  //     setState(() {
  //       _chadStats = stats;
  //     });
  //     debugPrint('✅ Chad 통계 로드 완료: Level ${stats.chadLevel}, 뇌절 ${stats.brainjoltDegree}도');
  //   } catch (e) {
  //     debugPrint('❌ Chad 통계 로드 실패: $e');
  //   }
  // }

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

      // Chad 통계 로드 - DreamFlow에서는 사용 안 함
      // await _loadChadStats();

      // 사용자 프로필 로드
      final profile = await _databaseService.getUserProfile();
      debugPrint('👤 사용자 프로필: $profile');

      // 프로필이 null이면 기본 프로필 생성
      final userProfile = profile ??
          UserProfile(
            id: 1,
            level: UserLevel.rising,
            initialMaxReps: 10,
            startDate: DateTime.now(),
          );

      // 다음 운동 로드 (완료 기반)
      final workout = await _workoutProgramService.getNextWorkout(userProfile);
      debugPrint('🏋️ 다음 운동: $workout');

      // 자각몽 체크리스트 로드 (MVP용)
      final checklist = _lucidDreamProgramService.getTodayChecklist(userProfile);
      debugPrint('🌙 오늘의 체크리스트: $checklist');

      // 프로그램 진행률 로드
      final progress = await _workoutProgramService.getProgress(userProfile);
      debugPrint('📈 프로그램 진행률: $progress');

      // 오늘 완료된 운동 기록 확인
      final today = DateTime.now();
      final todayString =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final completedWorkout =
          await WorkoutHistoryService.getTodayCompletedWorkout(todayString);
      debugPrint('✅ 오늘 완료된 운동: $completedWorkout');

      if (mounted) {
        setState(() {
          _userProfile = userProfile;
          _todayWorkout = workout;
          _todayChecklist = checklist; // 체크리스트 저장
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
      final chadService = Provider.of<ChadEvolutionService>(
        context,
        listen: false,
      );
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
                      Color(AppColors.lucidGradient[0]),
                      Color(AppColors.lucidGradient[1]),
                    ]
                  : [Colors.white, const Color(0xFFF5F5F5)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(
                    AppColors.primaryColor,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  size: 50,
                  color: Color(AppColors.primaryColor),
                ),
              ),
              const SizedBox(height: AppConstants.paddingL),
              Text(
                AppLocalizations.of(context).loadingText,
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                AppLocalizations.of(context).homeTitle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // VIP 배지 표시
            Consumer<AuthService>(
              builder: (context, authService, child) {
                final subscription = authService.currentSubscription;
                if (subscription != null) {
                  return VIPBadgeWidget(
                    subscription: subscription,
                    size: VIPBadgeSize.small,
                    showLabel: false,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
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
                color:
                    theme.appBarTheme.iconTheme?.color ?? theme.iconTheme.color,
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
                        // DreamFlow - 자각몽 앱
                        // Chad 제거됨 - 운동 캐릭터는 자각몽 앱에 불필요

                        // AI 꿈 분석 카드
                        _buildAIAnalysisCard(context, theme, isDark),

                        const SizedBox(height: AppConstants.paddingL),

                        // AI 어시스턴트 카드
                        _buildAIAssistantCard(context, theme, isDark),

                        const SizedBox(height: AppConstants.paddingL),

                        // 토큰 잔액 위젯
                        const TokenBalanceWidget(
                          showDailyReward: true,
                          showAdButton: true,
                        ),

                        const SizedBox(height: AppConstants.paddingL),

                        // 2. 오늘의 자각몽 체크리스트 (Hero Section)
                        TodayMissionCardWidget(
                          todayWorkout: _todayWorkout,
                          todayCompletedWorkout: _todayCompletedWorkout,
                          onStartWorkout: () => _startTodayChecklist(context),
                        ),

                        const SizedBox(height: AppConstants.paddingL),

                        // 3. 2열 그리드: 진행률 + 업적
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 진행 상황 카드
                            Expanded(
                              child: ProgressCardWidget(
                                programProgress: _programProgress,
                              ),
                            ),
                            // 업적 통계 카드
                            Expanded(
                              child: AchievementStatsWidget(
                                totalXP: _totalXP,
                                unlockedCount: _unlockedCount,
                                totalCount: _totalCount,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppConstants.paddingL),

                        // 추가 기능 버튼들
                        ActionButtonsWidget(
                          // Tutorial removed for MVP - not needed for lucid dream app
                          // onTutorialPressed: () => _openTutorial(context),
                          // onFormGuidePressed: () => _openFormGuide(context),
                          onProgressTrackingPressed: () =>
                              _openProgressTracking(context),
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
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            AppLocalizations.of(context).errorOccurred,
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
            child: Text(AppLocalizations.of(context).retryButton),
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
          Icon(Icons.person_add, size: 64, color: Colors.blue[400]),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            AppLocalizations.of(context).pleaseCreateProfile,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            AppLocalizations.of(context).userProfileRequired,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingL),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (context) => const SimpleSettingsScreen()),
            ),
            child: Text(AppLocalizations.of(context).goToSettings),
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
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
              const SizedBox(width: AppConstants.paddingS),
              Text(
                AppLocalizations.of(context).workoutTips,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            AppLocalizations.of(context).workoutTipsContent,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _startTodayChecklist(BuildContext context) async {
    if (_todayWorkout != null) {
      // DreamFlow - 자각몽 체크리스트 시작
      // 연속 운동 경고, 휴식일 경고 제거 (자각몽은 매일 가능)
      if (_todayChecklist != null) {
        // 자각몽 체크리스트 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => LucidDreamChecklistScreen(
              checklist: _todayChecklist!,
              onChecklistCompleted: _onWorkoutSaved,
            ),
          ),
        ).then((_) {
          // 체크리스트 화면에서 돌아온 후 데이터 새로고침
          _refreshAllServiceData();
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).homeChecklistLoadError),
        ),
      );
    }
  }

  // ========== DreamFlow - 아래 메서드들은 운동 앱 전용 (사용 안 함) ==========
  // 연속 운동 경고, 휴식일 경고는 자각몽 앱에서 불필요
  // 자각몽은 매일 체크리스트 수행 가능

  // Tutorial methods removed for MVP - not needed for lucid dream app
  // void _openTutorial(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute<void>(
  //         builder: (context) => const PushupTutorialScreen()),
  //   );
  // }

  // void _openFormGuide(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute<void>(
  //         builder: (context) => const PushupFormGuideScreen()),
  //   );
  // }

  void _openProgressTracking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            ProgressTrackingScreen(userProfile: _userProfile!),
      ),
    );
  }

  /// AI 꿈 분석 카드
  Widget _buildAIAnalysisCard(BuildContext context, ThemeData theme, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.8),
              theme.primaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openAIAnalysis(context),
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: Row(
                children: [
                  // 아이콘
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '✨',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingL),
                  // 텍스트
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.homeAIDreamAnalysisTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.homeAIDreamAnalysisSubtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 화살표
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// AI 어시스턴트 카드
  Widget _buildAIAssistantCard(BuildContext context, ThemeData theme, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF26A69A), // Teal 400
              Color(0xFF00796B), // Teal 600
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openAIAssistant(context),
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: Row(
                children: [
                  // 아이콘
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '🤖',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingL),
                  // 텍스트
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.aiAssistantTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.aiAssistantSubtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 화살표
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// AI 분석 화면 열기
  void _openAIAnalysis(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AnalysisModeSelectionScreen(),
      ),
    );
  }

  /// AI 어시스턴트 화면 열기
  void _openAIAssistant(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LucidDreamAIAssistantScreen(),
      ),
    );
  }

  /// 일일 보상 체크 및 프롬프트 표시
  Future<void> _checkDailyReward() async {
    try {
      final tokenService = context.read<ConversationTokenService>();
      final authService = context.read<AuthService>();

      // 이미 오늘 보상을 받았는지 확인
      if (!tokenService.canClaimDailyReward) {
        debugPrint('🎁 오늘 이미 보상을 받았습니다');
        return;
      }

      // 프리미엄 여부 확인
      final isPremium = authService.currentSubscription?.type == SubscriptionType.premium;
      final rewardAmount = isPremium ? 5 : 1;

      // 일일 보상 다이얼로그 표시
      final l10n = AppLocalizations.of(context);
      final shouldClaim = await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Text('🎁', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.homeDailyRewardTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeDailyRewardMessage,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🎫', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Text(
                      l10n.tokenBalanceRewardAmount(rewardAmount),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
              ),
              if (isPremium) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.homePremiumBonusApplied,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                l10n.homeChatWithLumiMessage(rewardAmount),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.homeLaterButton),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                l10n.homeClaimButton,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

      // 사용자가 보상 받기를 선택한 경우
      if (shouldClaim == true && mounted) {
        await tokenService.claimDailyReward(isPremium: isPremium);

        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.homeDailyRewardReceived(rewardAmount),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ 일일 보상 체크 실패: $e');
    }
  }
}
