import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/checklist_data.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/auth/auth_service.dart';
import '../models/user_subscription.dart';
import '../widgets/gamification/week_unlock_dialog.dart';
import '../widgets/common/ad_banner_widget.dart';
import '../widgets/checklist/token_reward_dialog.dart';
import '../services/progress/dream_statistics_service.dart';
import '../services/data/dream_journal_service.dart';
import '../services/checklist/checklist_completion_service.dart';
import 'dream_journal/dream_journal_write_screen.dart';
import 'dream_journal/dream_journal_list_screen.dart';
import 'tasks/reality_check_screen.dart';
import 'tasks/mild_affirmation_screen.dart';
import 'tasks/wbtb_screen.dart';
import 'tasks/ssild_screen.dart';
import 'tasks/wild_screen.dart';
import 'tasks/dream_control_screen.dart';
import 'tasks/stabilization_screen.dart';
import 'tasks/bedtime_prep_screen.dart';

/// Daily Checklist Screen
/// Shows all checklist items grouped by priority
class DailyChecklistScreen extends StatefulWidget {
  const DailyChecklistScreen({super.key});

  @override
  State<DailyChecklistScreen> createState() => _DailyChecklistScreenState();
}

class _DailyChecklistScreenState extends State<DailyChecklistScreen> {
  // Track completion state for each item
  Map<String, bool> completionState = {};
  Map<String, int> counterState = {}; // For items with countRequired
  int currentWeek = 1; // Current level (== Week). Level-based, not time-based!
  bool isLoading = true;
  bool _rewardGivenToday = false; // 오늘 보상 받았는지 추적

  @override
  void initState() {
    super.initState();
    _loadCurrentLevel();
    // Initialize all items as incomplete
    for (final item in ChecklistData.dailyChecklist) {
      completionState[item.id] = false;
      if (item.countRequired != null) {
        counterState[item.id] = 0;
      }
    }
  }

  /// 현재 레벨(=Week) 로드
  /// 레벨은 시간이 아니라 행동으로 올라감 (체크리스트 완료 → 레벨업)
  ///
  /// 레벨 제한 (Model B):
  /// - 무료 사용자: Level 1까지만 (Week 1만 영구 무료)
  /// - 프리미엄 사용자: Level 9까지 (Week 1-9 전체)
  Future<void> _loadCurrentLevel() async {
    try {
      // 구독 상태 확인
      final authService = Provider.of<AuthService>(context, listen: false);
      final subscription = authService.currentSubscription;

      // 구독 상태에 따른 최대 레벨 결정
      // 무료: Week 1만, 프리미엄: Week 1-9
      final maxAllowedLevel = subscription?.allowedWeeks ?? 1;

      // 통계 기반 레벨 계산 (행동 기반 + 구독 제한)
      final stats = await DreamStatisticsService.getStatistics();
      final level = DreamStatisticsService.calculateLevel(
        stats,
        maxAllowedLevel: maxAllowedLevel,
      );

      setState(() {
        currentWeek = level; // Level = Week
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        currentWeek = 1;
        isLoading = false;
      });
    }
  }

  double get completionRate {
    int completed = 0;
    int total = 0;

    // Only count unlocked items
    final unlockedItems = ChecklistData.getItemsForWeek(currentWeek);

    for (final item in unlockedItems) {
      if (item.optional) continue; // Skip optional items

      total++;

      if (item.countRequired != null) {
        // Counter items: check if target reached
        if ((counterState[item.id] ?? 0) >= item.countRequired!) {
          completed++;
        }
      } else {
        // Regular checkbox items
        if (completionState[item.id] == true) {
          completed++;
        }
      }
    }

    return total > 0 ? completed / total : 0;
  }

  /// 100% 완료 시 토큰 보상 지급
  Future<void> _checkAndGiveReward() async {
    // 100% 완료가 아니면 스킵
    if (completionRate < 1.0) return;

    // 이미 오늘 보상 받았으면 축하 메시지만 표시
    if (_rewardGivenToday) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.celebration, color: Colors.white),
                const SizedBox(width: 12),
                Text(AppLocalizations.of(context).dailyChecklistAllComplete),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    // 토큰 보상 지급
    final result = await ChecklistCompletionService.rewardTokensForChecklistCompletion(
      authService: authService,
    );

    setState(() {
      _rewardGivenToday = true;
    });

    if (result == null) {
      // 이미 오늘 받았지만 처음 100% 달성 - 축하 스낵바 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(AppLocalizations.of(context).dailyChecklistAllComplete),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    // 축하 다이얼로그 표시
    if (!mounted) return;
    await TokenRewardDialog.show(
      context: context,
      baseTokens: result.baseTokens,
      bonusTokens: result.bonusTokens,
      totalTokens: result.totalTokens,
      currentStreak: result.currentStreak,
      isPremium: result.isPremium,
    );
  }

  bool _isItemUnlocked(ChecklistItem item) {
    // Check if item is unlocked based on current week
    if (!ChecklistData.isItemUnlocked(item.id, currentWeek)) {
      return false; // Not reached unlock week yet
    }

    // Week 1 items are always accessible (permanently free)
    if (item.unlockWeek <= 1) {
      return true;
    }

    // Week 2+ requires premium subscription
    final authService = Provider.of<AuthService>(context, listen: false);
    final subscription = authService.currentSubscription;

    // Check if user has premium access to this week
    return subscription?.canAccessWeek(item.unlockWeek) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dailyChecklistAppBar),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '${(completionRate * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: completionRate,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(completionRate * 100).toInt()}% ${l10n.dailyChecklistComplete}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),

                // Priority 1 Section
                if (ChecklistData.priority1Items.isNotEmpty) ...[
                  _buildSectionHeader(l10n.dailyChecklistPriority1, Colors.red[100]!),
                  ...ChecklistData.priority1Items.map((item) =>
                    _buildChecklistItem(item)
                  ),
                  const SizedBox(height: 16),
                ],

                // Priority 2 Section
                if (ChecklistData.priority2Items.isNotEmpty) ...[
                  _buildSectionHeader(l10n.dailyChecklistPriority2, Colors.orange[100]!),
                  ...ChecklistData.priority2Items.map((item) =>
                    _buildChecklistItem(item)
                  ),
                  const SizedBox(height: 16),
                ],

                // Regular Section
                if (ChecklistData.regularItems.isNotEmpty) ...[
                  _buildSectionHeader(l10n.dailyChecklistRegular, Colors.blue[50]!),
                  ...ChecklistData.regularItems.map((item) =>
                    _buildChecklistItem(item)
                  ),
                  const SizedBox(height: 16),
                ],

                // Optional Section
                if (ChecklistData.optionalItems.isNotEmpty) ...[
                  _buildSectionHeader(l10n.dailyChecklistOptional, Colors.grey[200]!),
                  ...ChecklistData.optionalItems.map((item) =>
                    _buildChecklistItem(item, isOptional: true)
                  ),
                ],
              ],
            ),
          ),
          // 하단 배너 광고
          const SafeArea(
            top: false,
            child: AdBannerWidget(margin: EdgeInsets.symmetric(vertical: 8)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87, // 명시적 텍스트 색상 (가독성 개선)
        ),
      ),
    );
  }

  Widget _buildChecklistItem(ChecklistItem item, {bool isOptional = false}) {
    if (item.countRequired != null) {
      // Counter item (e.g., Reality Check)
      return _buildCounterItem(item, isOptional);
    } else {
      // Regular checkbox item
      return _buildCheckboxItem(item, isOptional);
    }
  }

  Widget _buildCheckboxItem(ChecklistItem item, bool isOptional) {
    final bool isLocked = !_isItemUnlocked(item);

    return Opacity(
      opacity: isLocked ? 0.5 : (isOptional ? 0.7 : 1.0),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        color: isLocked ? Colors.grey[200] : null,
        child: InkWell(
          onTap: isLocked
              ? () => _showLockedDialog(item)
              : () => _handleChecklistItemTap(item),
          child: CheckboxListTile(
            value: isLocked ? false : (completionState[item.id] ?? false),
            onChanged: isLocked
                ? null
                : (value) async {
                    // 꿈일기 항목은 체크박스 클릭 시에도 작성 화면으로 이동
                    if (item.id == 'dream_journal' && value == true) {
                      _handleChecklistItemTap(item);
                    } else {
                      setState(() {
                        completionState[item.id] = value ?? false;
                      });
                      // 100% 완료 체크 및 보상 지급
                      await _checkAndGiveReward();
                    }
                  },
            title: Row(
              children: [
                if (isLocked)
                  const Icon(Icons.lock, size: 20, color: Colors.grey)
                else
                  Text(item.icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.nameKo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isLocked ? Colors.grey[600] : null,
                    ),
                  ),
                ),
                if (isLocked)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Week ${item.unlockWeek}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[900],
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  isLocked
                      ? 'Week ${item.unlockWeek}에 해금되는 고급 기법입니다'
                      : item.descriptionKo,
                  style: TextStyle(
                    color: isLocked ? Colors.grey[600] : null,
                  ),
                ),
                if (!isLocked && item.researchNote != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '📊 ${item.researchNote}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (!isLocked && item.defaultTime != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '⏰ ${item.defaultTime}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }

  Widget _buildCounterItem(ChecklistItem item, bool isOptional) {
    final l10n = AppLocalizations.of(context);
    final bool isLocked = !_isItemUnlocked(item);
    final int currentCount = counterState[item.id] ?? 0;
    final int targetCount = item.countRequired ?? 0;
    final double progress = targetCount > 0 ? currentCount / targetCount : 0;

    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        color: isLocked ? Colors.grey[200] : null,
        child: InkWell(
          onTap: isLocked
              ? () => _showLockedDialog(item)
              : () => _handleCounterItemTap(item),
          child: ListTile(
            leading: isLocked
                ? const Icon(Icons.lock, size: 32, color: Colors.grey)
                : Text(item.icon, style: const TextStyle(fontSize: 32)),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    item.nameKo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isLocked ? Colors.grey[600] : null,
                    ),
                  ),
                ),
                if (isLocked)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Week ${item.unlockWeek}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[900],
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  isLocked
                      ? 'Week ${item.unlockWeek}에 해금되는 고급 기법입니다'
                      : item.descriptionKo,
                  style: TextStyle(
                    color: isLocked ? Colors.grey[600] : null,
                  ),
                ),
                if (!isLocked) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.dailyChecklistCounterProgress(currentCount, targetCount),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.add_circle, size: 40),
                        color: currentCount < targetCount
                            ? Colors.blue
                            : Colors.grey,
                        onPressed: currentCount < targetCount
                            ? () async {
                                setState(() {
                                  counterState[item.id] = currentCount + 1;
                                });

                                // Show completion dialog when target reached
                                if (currentCount + 1 == targetCount) {
                                  _showCompletionDialog(item);
                                }

                                // 100% 완료 체크 및 보상 지급
                                await _checkAndGiveReward();
                              }
                            : null,
                      ),
                    ],
                  ),
                  if (item.intervalMinutes != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.dailyChecklistPracticeInterval(item.intervalMinutes!),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ],
            ),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }

  /// 체크리스트 항목 클릭 처리 (스마트 체크)
  Future<void> _handleChecklistItemTap(ChecklistItem item) async {
    // 꿈일기 작성 항목인 경우
    if (item.id == 'dream_journal') {
      await _handleDreamJournalTap();
      await _checkAndGiveReward();
      return;
    }

    // 상세 화면이 있는 항목은 해당 화면으로 이동
    final screen = _getDetailScreen(item.id);
    if (screen != null) {
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (context) => screen),
      );
      // 상세 화면에서 완료했으면 체크 표시
      if (result == true) {
        setState(() {
          // counter 항목인 경우 counterState 설정
          if (item.countRequired != null) {
            counterState[item.id] = item.countRequired!;
          } else {
            completionState[item.id] = true;
          }
        });
        await _checkAndGiveReward();
      }
      return;
    }

    // 상세 화면 없는 항목은 바로 체크/언체크 토글
    setState(() {
      completionState[item.id] = !(completionState[item.id] ?? false);
    });
    await _checkAndGiveReward();
  }

  /// 항목 ID에 따른 상세 화면 반환
  Widget? _getDetailScreen(String itemId) {
    switch (itemId) {
      case 'reality_check_2hr':
        return const RealityCheckScreen();
      case 'bedtime_preparation':
        return const BedtimePrepScreen();
      case 'wbtb_alarm':
        return const WBTBScreen();
      case 'mild_wbtb':
        return const MildAffirmationScreen();
      case 'ssild_technique':
        return const SSILDScreen();
      case 'wild_technique':
        return const WILDScreen();
      case 'dream_control_practice':
        return const DreamControlScreen();
      case 'reality_stabilization':
        return const StabilizationScreen();
      default:
        return null;
    }
  }

  /// Counter 항목 클릭 처리 (카운트 증가)
  Future<void> _handleCounterItemTap(ChecklistItem item) async {
    setState(() {
      final currentCount = counterState[item.id] ?? 0;
      counterState[item.id] = currentCount + 1;
    });

    // 100% 완료 체크 및 보상 지급
    await _checkAndGiveReward();
  }

  /// 꿈일기 작성 처리
  Future<void> _handleDreamJournalTap() async {
    // 오늘 작성된 꿈일기가 있는지 확인
    final dreamJournalService = DreamJournalService();
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final todayDreams = await dreamJournalService.getDreamsByDateRange(
      startDate: todayStart,
      endDate: todayEnd,
    );

    // 오늘 꿈일기가 있으면 옵션 메뉴 표시
    if (todayDreams.isNotEmpty && mounted) {
      // 자동 체크
      setState(() {
        completionState['dream_journal'] = true;
      });

      // 옵션 다이얼로그 표시
      final action = await showModalBottomSheet<String>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                '오늘 ${todayDreams.length}개의 꿈 일기가 있습니다',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.add_circle, color: Colors.blue),
                title: const Text('새 꿈 일기 추가'),
                subtitle: const Text('오늘 꾼 다른 꿈을 기록합니다'),
                onTap: () => Navigator.pop(context, 'new'),
              ),
              ListTile(
                leading: const Icon(Icons.list_alt, color: Colors.purple),
                title: const Text('내 꿈 일기 보기'),
                subtitle: const Text('작성한 꿈 일기를 확인합니다'),
                onTap: () => Navigator.pop(context, 'list'),
              ),
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('완료'),
                subtitle: const Text('체크리스트로 돌아갑니다'),
                onTap: () => Navigator.pop(context, 'done'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );

      if (!mounted) return;

      if (action == 'new') {
        await _navigateToDreamJournalWrite();
      } else if (action == 'list') {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DreamJournalListScreen()),
        );
      }
      return;
    }

    // 꿈일기가 없으면 작성 페이지로 이동
    await _navigateToDreamJournalWrite();
  }

  /// 꿈 일기 작성 화면으로 이동
  Future<void> _navigateToDreamJournalWrite() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DreamJournalWriteScreen(),
      ),
    );

    // 꿈일기 작성 후 돌아온 경우 자동 체크
    if (result == true && mounted) {
      setState(() {
        completionState['dream_journal'] = true;
      });
    }
  }

  void _showCompletionDialog(ChecklistItem item) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dailyChecklistCompletionDialogTitle(item.icon)),
        content: Text(l10n.dailyChecklistCompletionDialogContent(item.nameKo)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.dailyChecklistConfirmButton),
          ),
        ],
      ),
    );
  }

  void _showLockedDialog(ChecklistItem item) {
    final l10n = AppLocalizations.of(context);

    // Get subscription status
    final authService = Provider.of<AuthService>(context, listen: false);
    final subscription = authService.currentSubscription;
    final bool hasReachedWeek = currentWeek >= item.unlockWeek;
    final bool needsPremium = item.unlockWeek >= 2;

    // If user has reached Week 2+ but doesn't have premium, show premium paywall
    if (hasReachedWeek && needsPremium && subscription?.type != SubscriptionType.premium) {
      // Show premium upgrade dialog based on unlock week
      if (item.unlockWeek >= 7) {
        WeekUnlockDialog.showWeek7Dialog(context);
      } else if (item.unlockWeek >= 5) {
        WeekUnlockDialog.showWeek5Dialog(context);
      } else if (item.unlockWeek >= 3) {
        WeekUnlockDialog.showWeek3Dialog(context);
      } else {
        // Week 2 paywall
        WeekUnlockDialog.showWeek2Dialog(context);
      }
      return;
    }

    // Otherwise, show basic info dialog (not reached week yet)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.lock, color: Colors.orange, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.nameKo,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unlock week info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule, size: 18, color: Colors.orange),
                  const SizedBox(width: 6),
                  Text(
                    'Week ${item.unlockWeek}에 해금',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[900],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              item.descriptionKo,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),

            // Research note if available
            if (item.researchNote != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5), // 연한 회색 배경으로 변경 (가독성 개선)
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!), // 테두리도 회색으로 변경
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📊', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.researchNote!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87, // 텍스트 색상도 검은색으로 변경
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Motivational message
            Text(
              currentWeek < 2
                  ? '🆓 Week 1 영구 무료! Week ${item.unlockWeek}까지 계속 훈련하면 해금됩니다!'
                  : '💎 프리미엄으로 업그레이드하여 고급 기법을 해금하세요!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.dailyChecklistConfirmButton),
          ),
        ],
      ),
    );
  }
}
