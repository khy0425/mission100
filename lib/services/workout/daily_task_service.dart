import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/lucid_dream_task.dart';
import '../../models/user_subscription.dart';
import '../../utils/xp_calculator.dart';
import '../ai/conversation_token_service.dart';
import '../checklist/checklist_completion_service.dart';
import '../auth/auth_service.dart';
import '../progress/experience_service.dart';
import '../progress/stage_change_notifier.dart';

/// 보상 획득 콜백 타입
typedef RewardEarnedCallback = void Function({
  required int xpEarned,
  required int tokensEarned,
});

/// 일일 태스크 완료 상태 관리 서비스
///
/// - 각 태스크의 완료 상태를 메모리에서 관리
/// - 날짜가 바뀌면 자동으로 초기화
/// - 태스크 화면에서 완료 시 체크리스트에 반영
/// - 필수 3가지 태스크 완료 시 자동으로 토큰 보상
class DailyTaskService extends ChangeNotifier {
  // 오늘 날짜
  DateTime _today = DateTime.now();

  // 각 태스크 타입별 완료 상태
  final Map<LucidDreamTaskType, bool> _taskStatus = {};

  // 토큰 서비스 (나중에 주입)
  ConversationTokenService? _tokenService;

  // Auth 서비스 (나중에 주입)
  AuthService? _authService;

  // 보상 획득 콜백 (애니메이션 표시용)
  RewardEarnedCallback? _onRewardEarned;

  // SharedPreferences 키
  static const String _taskRewardDateKey = 'task_completion_reward_date';

  /// 보상 획득 콜백 설정 (UI에서 애니메이션 표시용)
  void setRewardCallback(RewardEarnedCallback? callback) {
    _onRewardEarned = callback;
  }

  /// 토큰 서비스 설정 (외부에서 주입)
  void setTokenService(ConversationTokenService tokenService) {
    _tokenService = tokenService;
  }

  /// Auth 서비스 설정 (외부에서 주입)
  void setAuthService(AuthService authService) {
    _authService = authService;
  }

  /// 특정 태스크 완료 상태 확인
  bool isTaskCompleted(LucidDreamTaskType taskType) {
    _checkAndResetIfNewDay();
    return _taskStatus[taskType] ?? false;
  }

  /// 태스크 완료 상태 토글
  Future<void> toggleTask(LucidDreamTaskType taskType, bool isCompleted) async {
    _checkAndResetIfNewDay();

    _taskStatus[taskType] = isCompleted;
    debugPrint('✅ Task ${taskType.name} marked as ${isCompleted ? "completed" : "incomplete"}');

    notifyListeners();

    // 모든 필수 태스크가 완료되었는지 확인
    if (isCompleted) {
      await _checkAndAwardTokensIfAllRequiredTasksComplete();
    }
  }

  /// 모든 완료된 태스크 타입 목록
  Set<LucidDreamTaskType> get completedTasks {
    _checkAndResetIfNewDay();
    return _taskStatus.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toSet();
  }

  /// 필수 태스크가 모두 완료되었는지 확인하고 토큰 보상
  Future<void> _checkAndAwardTokensIfAllRequiredTasksComplete() async {
    // 필수 3가지 태스크: 꿈 일기, 현실 확인, MILD 확언
    final requiredTasks = [
      LucidDreamTaskType.dreamJournal,
      LucidDreamTaskType.realityCheck,
      LucidDreamTaskType.mildAffirmation,
    ];

    // 모든 필수 태스크가 완료되었는지 확인
    final allRequiredCompleted = requiredTasks.every(
      (task) => _taskStatus[task] == true,
    );

    if (!allRequiredCompleted) {
      final completed = requiredTasks.where((task) => _taskStatus[task] == true).length;
      debugPrint('⏳ Required tasks: $completed/3 completed');
      return;
    }

    // 오늘 이미 보상을 받았는지 확인
    final prefs = await SharedPreferences.getInstance();
    final lastRewardDate = prefs.getString(_taskRewardDateKey);
    final today = _getTodayDateString();

    if (lastRewardDate == today) {
      debugPrint('✅ Task completion tokens already awarded today');
      return;
    }

    // 토큰 서비스가 없으면 건너뛰기
    if (_tokenService == null) {
      debugPrint('⚠️ Token service not available for task completion reward');
      return;
    }

    debugPrint('🎁🎁🎁 All 3 required tasks completed! Awarding tokens and XP...');

    // ══════════════════════════════════════════════════════════════
    // Optimistic UI: 먼저 로컬 업데이트 → UI 즉시 반영 → 서버 동기화는 백그라운드
    // ══════════════════════════════════════════════════════════════

    // 보상 상수
    const xpEarned = 100; // 체크리스트 100% 완료 = 100 XP
    const tokensEarned = 1; // 일일 체크리스트 완료 = 1 토큰

    // 0️⃣ 보상 애니메이션 콜백 호출 (UI에서 애니메이션 표시)
    _onRewardEarned?.call(xpEarned: xpEarned, tokensEarned: tokensEarned);
    debugPrint('🎬 Reward animation triggered!');

    // 1️⃣ 토큰 지급 (Optimistic UI - 즉시 반영)
    await _tokenService!.earnFromDailyChecklist();
    debugPrint('✨ Token: UI immediately updated!');

    final experienceService = ExperienceService();
    await experienceService.initialize();
    await experienceService.addAchievementExp(xpEarned, '일일 체크리스트 완료');
    debugPrint('✨ XP: +$xpEarned XP saved locally!');

    // 3️⃣ 스테이지 변경 감지 + UI 업데이트 (즉시 반영)
    final newTotalXP = experienceService.totalExp;
    final isPremium = _authService?.currentSubscription?.type == SubscriptionType.premium;
    final stageChange = await StageChangeNotifier().updateXP(
      newTotalXP,
      isPremium: isPremium,
    );
    if (stageChange != null) {
      debugPrint('🎉 Stage Up! ${stageChange.oldStage} → ${stageChange.newStage}');
    }

    // 오늘 날짜 저장 (중복 방지)
    await prefs.setString(_taskRewardDateKey, today);

    debugPrint('✅✅✅ Optimistic UI Complete! 토큰과 XP가 즉시 반영되었습니다!');

    // 4️⃣ 서버 동기화 (백그라운드 - 사용자는 기다리지 않음)
    _syncToServerAsync(
      xpEarned: xpEarned,
      totalXP: newTotalXP,
      requiredTaskCount: requiredTasks.length,
    );
  }

  /// 날짜가 바뀌었는지 확인하고, 바뀌었으면 초기화
  void _checkAndResetIfNewDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final savedDay = DateTime(_today.year, _today.month, _today.day);

    if (!today.isAtSameMomentAs(savedDay)) {
      debugPrint('🔄 New day detected - resetting task status');
      _taskStatus.clear();
      _today = now;
      notifyListeners();
    }
  }

  /// 오늘 날짜를 YYYY-MM-DD 형식으로 반환
  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// 서버 동기화 (백그라운드)
  ///
  /// UI는 이미 업데이트되었고, 서버 동기화만 백그라운드에서 진행합니다.
  /// 실패해도 사용자 경험에 영향 없음 (다음 동기화 시 자동 조정)
  void _syncToServerAsync({
    required int xpEarned,
    required int totalXP,
    required int requiredTaskCount,
  }) {
    Future.microtask(() async {
      try {
        debugPrint('📞 [Background] Starting server sync...');

        if (_authService == null) {
          debugPrint('⚠️ [Background] Auth service not available - skipping server sync');
          return;
        }

        // XP 기반으로 주차/일차 계산
        final currentWeek = XPCalculator.getWeekFromXP(totalXP) + 1;
        final currentWeekXP = XPCalculator.getCurrentWeekXP(totalXP);
        final currentDay = (currentWeekXP ~/ 100) + 1;

        // Firebase Functions 호출 (레벨업 체크 + 서버 동기화)
        final xpResult = await ChecklistCompletionService.checkXPAndLevelUp(
          completedTaskCount: requiredTaskCount,
          totalTaskCount: requiredTaskCount,
          authService: _authService!,
          weekNumber: currentWeek,
          dayNumber: currentDay,
        );

        if (xpResult != null && xpResult.levelUpResult?.leveledUp == true) {
          debugPrint('🎉 [Background] Level up confirmed by server!');
        }

        debugPrint('✅ [Background] Server sync complete');
      } catch (e) {
        debugPrint('⚠️ [Background] Server sync failed: $e');
        // 실패해도 로컬 데이터는 유지됨
      }
    });
  }

  /// 수동으로 모든 태스크 초기화 (테스트용)
  void resetAll() {
    _taskStatus.clear();
    notifyListeners();
  }
}
