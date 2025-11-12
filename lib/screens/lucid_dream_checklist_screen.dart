import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../generated/l10n/app_localizations.dart';
import '../utils/config/constants.dart';
import '../models/lucid_dream_task.dart';
import '../models/checklist_history.dart';
import '../models/rewarded_ad_reward.dart';
import '../services/workout/lucid_dream_program_service.dart';
import '../services/workout/checklist_history_service.dart';
import '../services/payment/rewarded_ad_reward_service.dart';
import '../services/auth/auth_service.dart';
import '../services/ai/dream_analysis_service.dart';
import '../screens/dream_analysis_screen.dart';

/// 자각몽 일일 체크리스트 화면
///
/// 푸시업 세트/횟수 대신 매일 수행할 자각몽 훈련 태스크 체크리스트 표시
class LucidDreamChecklistScreen extends StatefulWidget {
  final TodayChecklist checklist;
  final VoidCallback? onChecklistCompleted;

  const LucidDreamChecklistScreen({
    super.key,
    required this.checklist,
    this.onChecklistCompleted,
  });

  @override
  State<LucidDreamChecklistScreen> createState() =>
      _LucidDreamChecklistScreenState();
}

class _LucidDreamChecklistScreenState
    extends State<LucidDreamChecklistScreen> {
  // 체크리스트 완료 상태 (태스크별)
  late List<bool> _taskCompletionStatus;
  DateTime? _checklistStartTime;

  @override
  void initState() {
    super.initState();
    _checklistStartTime = DateTime.now();
    _taskCompletionStatus =
        List.filled(widget.checklist.checklist.tasks.length, false);
  }

  /// 태스크 체크 토글
  void _toggleTask(int index) {
    setState(() {
      _taskCompletionStatus[index] = !_taskCompletionStatus[index];
    });

    // 햅틱 피드백
    if (_taskCompletionStatus[index]) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  /// 모든 필수 태스크가 완료되었는지 확인
  bool get _allRequiredTasksCompleted {
    final checklist = widget.checklist.checklist;
    for (int i = 0; i < checklist.tasks.length; i++) {
      final task = checklist.tasks[i];
      if (task.isRequired && !_taskCompletionStatus[i]) {
        return false;
      }
    }
    return true;
  }

  /// 완료된 태스크 수
  int get _completedTaskCount {
    return _taskCompletionStatus.where((completed) => completed).length;
  }

  /// 체크리스트 완료 처리
  void _completeChecklist() {
    final l10n = AppLocalizations.of(context);

    if (!_allRequiredTasksCompleted) {
      // 필수 태스크가 완료되지 않았으면 경고
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.checklistCompleteRequired),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 햅틱 피드백
    HapticFeedback.heavyImpact();

    // 완료 다이얼로그 표시
    _showCompletionDialog();
  }

  /// 체크리스트 완료 데이터 저장
  Future<void> _saveChecklistHistory(Duration timeElapsed) async {
    final checklist = widget.checklist.checklist;

    // 완료된 태스크 타입들 수집
    final completedTaskTypes = <String>[];
    for (int i = 0; i < checklist.tasks.length; i++) {
      if (_taskCompletionStatus[i]) {
        completedTaskTypes.add(checklist.tasks[i].type.name);
      }
    }

    // ChecklistHistory 객체 생성
    final history = ChecklistHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      dayNumber: widget.checklist.day,
      completedTasks: completedTaskTypes,
      totalTasksCompleted: _completedTaskCount,
      totalRequiredTasks: checklist.requiredTaskCount,
      completionRate: _completedTaskCount / checklist.tasks.length,
      duration: timeElapsed,
      isWbtbDay: checklist.isWbtbDay,
    );

    // 데이터베이스에 저장
    try {
      await ChecklistHistoryService.saveChecklistHistory(history);
      debugPrint('✅ 체크리스트 데이터 저장 완료: Day ${widget.checklist.day}');
    } catch (e) {
      debugPrint('❌ 체크리스트 데이터 저장 실패: $e');
    }
  }

  /// 완료 다이얼로그 표시
  void _showCompletionDialog() {
    final l10n = AppLocalizations.of(context);
    final timeElapsed = DateTime.now().difference(_checklistStartTime!);
    final checklist = widget.checklist.checklist;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(AppColors.successColor)),
            const SizedBox(width: 8),
            Text(l10n.checklistDayComplete(widget.checklist.day)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.checklistCompleteMessage,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildStatRow(l10n.checklistCompletedTasks, l10n.checklistCompletedTasksValue(_completedTaskCount, checklist.tasks.length)),
            _buildStatRow(l10n.checklistRequiredTasks, l10n.checklistRequiredTasksValue(checklist.requiredTaskCount, checklist.requiredTaskCount)),
            if (checklist.isWbtbDay)
              _buildStatRow('WBTB', l10n.checklistWbtbDayBadge),
            _buildStatRow(l10n.checklistTimeSpent, l10n.checklistTimeSpentValue(timeElapsed.inMinutes)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // 체크리스트 완료 데이터 저장
              await _saveChecklistHistory(timeElapsed);

              if (!mounted) return;

              // 꿈 일기 태스크 완료 여부 확인
              bool hasDreamJournal = false;
              for (int i = 0; i < checklist.tasks.length; i++) {
                if (checklist.tasks[i].type == LucidDreamTaskType.dreamJournal) {
                  hasDreamJournal = _taskCompletionStatus[i];
                  break;
                }
              }

              Navigator.of(context).pop();

              // 꿈 일기 완료 시 Lumi AI 분석 제안
              if (hasDreamJournal) {
                await _showDreamAnalysisOffer();
              }

              if (!mounted) return;
              Navigator.of(context).pop(); // 체크리스트 화면도 닫기
              widget.onChecklistCompleted?.call();
            },
            child: Text(l10n.checklistConfirm),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// Lumi AI 꿈 분석 제안 다이얼로그
  Future<void> _showDreamAnalysisOffer() async {
    final l10n = AppLocalizations.of(context);
    final authService = context.read<AuthService>();
    final rewardService = context.read<RewardedAdRewardService>();
    final isPremium = !authService.hasAds; // 프리미엄 = 광고 없음
    final canUseFree = isPremium || rewardService.canUseReward(RewardedAdType.dreamAnalysis);

    final TextEditingController dreamController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 핸들 바
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppConstants.paddingL),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 헤더
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(AppColors.lucidGradient[0]),
                          Color(AppColors.lucidGradient[1]),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🧠', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.checklistDreamAnalysisTitle,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isPremium
                              ? l10n.checklistDreamAnalysisPremiumUnlimited
                              : canUseFree
                                  ? l10n.checklistDreamAnalysisAvailable
                                  : l10n.checklistDreamAnalysisWatchAd,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isPremium ? const Color(AppColors.successColor) : Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingL),

              // 꿈 내용 입력
              TextField(
                controller: dreamController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: l10n.checklistDreamInputHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),

              const SizedBox(height: AppConstants.paddingL),

              // 사용 가능 횟수 안내
              if (isPremium)
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(AppColors.successGradient[0]),
                        Color(AppColors.successGradient[1]),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.diamond, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.checklistPremiumUnlimited,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else if (canUseFree)
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.checklistFreeAnalysisAvailable,
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.checklistWatchAdForAnalysis,
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: AppConstants.paddingL),

              // 버튼
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.checklistLater),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        final dreamText = dreamController.text.trim();
                        if (dreamText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.checklistEnterDream),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        Navigator.of(context).pop();

                        if (isPremium) {
                          // 프리미엄 사용자: 무제한 분석 (쿨다운 없음)
                          await _performDreamAnalysis(dreamText, true);
                        } else if (canUseFree) {
                          // 무료 사용자: 무료 분석 (쿨다운 적용)
                          await _performDreamAnalysis(dreamText, false);
                        } else {
                          // 쿨다운 중: 리워드 광고 시청 후 분석
                          await _performRewardedDreamAnalysis(dreamText);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPremium
                            ? const Color(AppColors.successColor)
                            : canUseFree
                                ? const Color(AppColors.primaryColor)
                                : Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingM),
                      ),
                      child: Text(
                        isPremium
                            ? l10n.checklistPremiumAnalysisStart
                            : canUseFree
                                ? l10n.checklistFreeAnalysisStart
                                : l10n.checklistWatchAdAnalysis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 무료 꿈 분석 실행
  Future<void> _performDreamAnalysis(String dreamContent, bool isPremium) async {
    final l10n = AppLocalizations.of(context);

    // 로딩 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(AppConstants.paddingXL),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(AppColors.primaryColor),
                ),
              ),
              const SizedBox(height: AppConstants.paddingL),
              Text(
                l10n.checklistAnalyzing,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // AI 분석 실행
      final result = await DreamAnalysisService().analyzeDream(
        dreamContent: dreamContent,
        isPremium: isPremium,
      );

      if (!mounted) return;

      // 무료 분석 사용 기록 (쿨다운 적용)
      if (!isPremium) {
        await context
            .read<RewardedAdRewardService>()
            .forceGrantReward(RewardedAdType.dreamAnalysis);
      }

      // 로딩 닫기
      Navigator.of(context).pop();

      // 분석 결과 화면으로 이동
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DreamAnalysisScreen(result: result),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.checklistAnalysisError(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// 리워드 광고 시청 후 꿈 분석
  Future<void> _performRewardedDreamAnalysis(String dreamContent) async {
    final rewardService = context.read<RewardedAdRewardService>();

    await rewardService.watchAdAndReward(
      RewardedAdType.dreamAnalysis,
      onRewardGranted: () async {
        // 광고 시청 성공 - 분석 실행
        await _performDreamAnalysis(dreamContent, false);
      },
      onError: (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  /// 종료 확인 다이얼로그
  void _showExitConfirmation() {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.checklistExitTitle),
        content: Text(l10n.checklistExitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.checklistCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(l10n.checklistExit),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final checklist = widget.checklist.checklist;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Color(
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      ),
      appBar: AppBar(
        title: Text(l10n.checklistDayTitle(widget.checklist.day)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _showExitConfirmation,
        ),
        actions: [
          // 진행 상황 표시
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '$_completedTaskCount/${checklist.tasks.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 헤더 - Day 정보 및 진행률
          _buildHeader(isDark),

          // 태스크 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              itemCount: checklist.tasks.length,
              itemBuilder: (context, index) {
                final task = checklist.tasks[index];
                final isCompleted = _taskCompletionStatus[index];
                return _buildTaskCard(task, index, isCompleted, isDark, l10n);
              },
            ),
          ),

          // 완료 버튼
          _buildCompleteButton(isDark),
        ],
      ),
    );
  }

  /// 헤더 위젯 (Day 정보, 진행률)
  Widget _buildHeader(bool isDark) {
    final l10n = AppLocalizations.of(context);
    final checklist = widget.checklist.checklist;
    final progress = _completedTaskCount / checklist.tasks.length;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: Color(isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Day 제목
          Text(
            '🌙 Day ${widget.checklist.day}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: 8),

          // 부제목
          Text(
            widget.checklist.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),

          // WBTB Day 배지 + 스킵 옵션
          if (checklist.isWbtbDay) ...[
            _buildWbtbSkipCard(isDark),
            const SizedBox(height: 16),
          ],

          // 진행률 바
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(AppColors.successColor),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 진행률 텍스트
          Text(
            l10n.checklistProgressPercent((_completedTaskCount / checklist.tasks.length * 100).toInt()),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.successColor),
            ),
          ),
        ],
      ),
    );
  }

  /// WBTB 스킵 카드
  Widget _buildWbtbSkipCard(bool isDark) {
    final l10n = AppLocalizations.of(context);
    final rewardService = context.watch<RewardedAdRewardService>();
    final canUse = rewardService.canUseReward(RewardedAdType.wbtbSkip);
    final remaining = rewardService.getRemainingUsage(RewardedAdType.wbtbSkip);

    // WBTB 태스크가 이미 완료되었는지 확인
    bool wbtbCompleted = false;
    int wbtbIndex = -1;
    final checklist = widget.checklist.checklist;
    for (int i = 0; i < checklist.tasks.length; i++) {
      if (checklist.tasks[i].type == LucidDreamTaskType.wbtb) {
        wbtbIndex = i;
        wbtbCompleted = _taskCompletionStatus[i];
        break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(AppColors.wbtbGradient[0]),
            Color(AppColors.wbtbGradient[1]),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Text('⏰', style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.checklistWbtbDayBadge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      wbtbCompleted
                          ? l10n.checklistWbtbCompleted
                          : l10n.checklistWbtbBusy,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!wbtbCompleted) ...[
            const SizedBox(height: AppConstants.paddingM),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.checklistWbtbRemainingSkips(remaining),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed:
                      canUse && wbtbIndex != -1 ? () => _useWbtbSkip(wbtbIndex) : null,
                  icon: const Icon(Icons.play_circle_outline, size: 18),
                  label: Text(l10n.checklistWbtbSkipWithAd),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(AppColors.primaryColor),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM,
                      vertical: 8,
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// WBTB 스킵권 사용
  Future<void> _useWbtbSkip(int wbtbTaskIndex) async {
    final l10n = AppLocalizations.of(context);
    final rewardService = context.read<RewardedAdRewardService>();

    await rewardService.watchAdAndReward(
      RewardedAdType.wbtbSkip,
      onRewardGranted: () {
        // 광고 시청 성공 - WBTB 태스크 자동 완료
        if (mounted) {
          setState(() {
            _taskCompletionStatus[wbtbTaskIndex] = true;
          });

          HapticFeedback.heavyImpact();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.checklistWbtbSkipped),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      onError: (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  /// 태스크 카드 위젯
  Widget _buildTaskCard(
    LucidDreamTask task,
    int index,
    bool isCompleted,
    bool isDark,
    AppLocalizations l10n,
  ) {
    // 로컬라이제이션에서 title과 description 가져오기
    final title = _getLocalizedTaskTitle(task.titleKey, l10n);
    final description = _getLocalizedTaskDescription(task.descriptionKey, l10n);

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        side: isCompleted
            ? const BorderSide(color: Color(AppColors.successColor), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _toggleTask(index),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 체크박스
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? const Color(AppColors.successColor)
                      : Colors.grey[300],
                  border: Border.all(
                    color: isCompleted
                        ? const Color(AppColors.successColor)
                        : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
              const SizedBox(width: AppConstants.paddingM),

              // 태스크 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목 + 필수/선택 표시
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isCompleted ? Colors.grey : null,
                            ),
                          ),
                        ),
                        if (task.isRequired)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(AppColors.errorColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              l10n.checklistTaskRequired,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (!task.isRequired)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              l10n.checklistTaskOptional,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 설명
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),

                    // Reality Check 목표 횟수 표시
                    if (task.targetCount != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          l10n.checklistTaskGoal(task.targetCount!),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(AppColors.primaryColor),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 완료 버튼
  Widget _buildCompleteButton(bool isDark) {
    final l10n = AppLocalizations.of(context);
    final canComplete = _allRequiredTasksCompleted;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: Color(isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canComplete ? _completeChecklist : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(AppColors.successColor),
            padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingL),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            disabledBackgroundColor: Colors.grey[400],
          ),
          child: Text(
            canComplete ? l10n.checklistCompleteTraining : l10n.checklistCompleteRequiredFirst,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// 로컬라이제이션에서 태스크 제목 가져오기
  String _getLocalizedTaskTitle(String key, AppLocalizations l10n) {
    switch (key) {
      case 'taskDreamJournalTitle':
        return l10n.taskDreamJournalTitle;
      case 'taskRealityCheckTitle':
        return l10n.taskRealityCheckTitle;
      case 'taskMildTitle':
        return l10n.taskMildTitle;
      case 'taskSleepHygieneTitle':
        return l10n.taskSleepHygieneTitle;
      case 'taskWbtbTitle':
        return l10n.taskWbtbTitle;
      case 'taskMeditationTitle':
        return l10n.taskMeditationTitle;
      default:
        return key;
    }
  }

  /// 로컬라이제이션에서 태스크 설명 가져오기
  String _getLocalizedTaskDescription(String key, AppLocalizations l10n) {
    switch (key) {
      case 'taskDreamJournalDesc':
        return l10n.taskDreamJournalDesc;
      case 'taskRealityCheckDesc':
        return l10n.taskRealityCheckDesc;
      case 'taskMildDesc':
        return l10n.taskMildDesc;
      case 'taskSleepHygieneDesc':
        return l10n.taskSleepHygieneDesc;
      case 'taskWbtbDesc':
        return l10n.taskWbtbDesc;
      case 'taskMeditationDesc':
        return l10n.taskMeditationDesc;
      default:
        return key;
    }
  }
}
