import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/character_evolution.dart';
import '../models/user_subscription.dart';
import '../utils/checklist_data.dart';
import '../services/auth/auth_service.dart';
import '../services/progress/stage_change_notifier.dart';
import '../services/progress/experience_service.dart';
import '../services/workout/daily_task_service.dart';
import '../widgets/reward/reward_animation_overlay.dart';
import '../widgets/common/ad_banner_widget.dart';
import 'daily_checklist_screen.dart';
import 'ai/lucid_dream_ai_assistant_screen.dart';
import 'settings/simple_settings_screen.dart';
import 'progress/progress_screen.dart';
import 'home/widgets/appbar_token_widget.dart';
import 'techniques/technique_list_screen.dart';
import 'evolution/character_evolution_screen.dart';
import '../widgets/streak/streak_banner_widget.dart';
import 'dream_journal/dream_journal_list_screen.dart';

/// DreamFlow Home Screen
/// Lucid dreaming companion app with Lumi character
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentWeek = 1;
  double _checklistProgress = 0.0;
  int _totalXP = 0;
  bool _isPremium = false;
  final _authService = AuthService();
  final _stageNotifier = StageChangeNotifier();

  // 보상 애니메이션 스코프 키
  final _rewardAnimationKey = GlobalKey<RewardAnimationScopeState>();

  @override
  void initState() {
    super.initState();
    _stageNotifier.addListener(_onStageChanged);
    _loadUserProgress();
    _setupRewardCallback();
  }

  /// 보상 콜백 설정
  void _setupRewardCallback() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dailyTaskService = context.read<DailyTaskService>();
      dailyTaskService.setRewardCallback(({
        required int xpEarned,
        required int tokensEarned,
      }) {
        // 보상 애니메이션 표시
        _rewardAnimationKey.currentState?.showChecklistReward(
          xp: xpEarned,
          tokens: tokensEarned,
        );
        debugPrint('Reward animation displayed: +$xpEarned XP, +$tokensEarned tokens');
      });
    });
  }

  @override
  void dispose() {
    // 콜백 해제
    final dailyTaskService = context.read<DailyTaskService>();
    dailyTaskService.setRewardCallback(null);
    _stageNotifier.removeListener(_onStageChanged);
    super.dispose();
  }

  /// 스테이지/XP 변경 시 UI 업데이트
  void _onStageChanged() {
    if (mounted) {
      setState(() {
        _totalXP = _stageNotifier.currentXP;
      });
    }
  }

  Future<void> _loadUserProgress() async {
    // Load premium status
    final isPremium = _authService.currentSubscription?.type == SubscriptionType.premium;

    // ExperienceService에서 실제 XP 로드
    final experienceService = ExperienceService();
    await experienceService.initialize();
    final totalXP = experienceService.totalExp;

    // 주차 계산 (100 XP/일 기준)
    final currentWeek = (totalXP ~/ 700) + 1;

    setState(() {
      _currentWeek = currentWeek.clamp(1, 14);
      _checklistProgress = 0.0;
      _totalXP = totalXP;
      _isPremium = isPremium;
    });

    // 스테이지 변경 감지 초기화
    await _stageNotifier.initialize(
      totalXP: _totalXP,
      isPremium: _isPremium,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final characterName = CharacterEvolution.characterName;
    final currentStage = CharacterEvolution.getStageForWeek(_currentWeek);

    return RewardAnimationScope(
      key: _rewardAnimationKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          actions: [
            const AppBarTokenWidget(),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SimpleSettingsScreen()),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadUserProgress,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Character Card
                      _buildCharacterCard(theme, currentStage, characterName),
                      const SizedBox(height: 16),

                      // Streak Banner (연속 출석 강조)
                      StreakBannerWidget(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DailyChecklistScreen()),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // AI Dream Analysis Card
                      _buildAiCard(theme),
                      const SizedBox(height: 16),

                      // Dream Journal Card
                      _buildDreamJournalCard(theme),
                      const SizedBox(height: 16),

                      // Today Checklist Card with Preview
                      _buildChecklistCardWithPreview(theme, l10n),
                      const SizedBox(height: 16),

                      // Technique Guide Card
                      _buildTechniqueCard(theme),
                      const SizedBox(height: 16),

                      // Progress Card
                      _buildProgressCard(theme),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            // 하단 광고 배너
            SafeArea(top: false, child: AdBannerWidget(margin: const EdgeInsets.only(top: 8, bottom: 8))),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard(ThemeData theme, CharacterStage stage, String characterName) {
    final stageColor = Color(int.parse(stage.color.replaceFirst('#', '0xFF')));

    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacterEvolutionScreen(currentWeek: _currentWeek),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: stageColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: stageColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    'assets/images/character/${stage.imageFilename}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.nights_stay, size: 50, color: stageColor),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      characterName,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: stageColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        stage.name,
                        style: TextStyle(color: stageColor, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '$_currentWeek주차',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                        ),
                        const Spacer(),
                        Text(
                          '성장 보기',
                          style: TextStyle(color: stageColor, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 12, color: stageColor),
                      ],
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

  Widget _buildChecklistCardWithPreview(ThemeData theme, AppLocalizations l10n) {
    // 현재 주차에 해금된 항목만 표시 (잠금된 항목 제외)
    final checklistItems = ChecklistData.getItemsForWeek(_currentWeek).take(4).toList();

    IconData getIconForItem(String id) {
      switch (id) {
        case 'dream_journal': return Icons.book_outlined;
        case 'reality_check': return Icons.visibility_outlined;
        case 'mild_technique': return Icons.psychology_outlined;
        case 'wbtb_practice': return Icons.alarm_outlined;
        case 'dream_signs': return Icons.search_outlined;
        default: return Icons.check_circle_outline;
      }
    }

    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DailyChecklistScreen()),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.checklist_rounded, color: theme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        l10n.dailyChecklistAppBar,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    '${(_checklistProgress * 100).toInt()}%',
                    style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _checklistProgress,
                minHeight: 8,
                backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
              ),
              const SizedBox(height: 16),
              ...checklistItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(getIconForItem(item.id), size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.nameKo, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                          Text(item.descriptionKo, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                        ],
                      ),
                    ),
                    Icon(Icons.circle_outlined, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                  ],
                ),
              )),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('전체 보기', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 14, color: theme.primaryColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiCard(ThemeData theme) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade100,
              Colors.indigo.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LucidDreamAIAssistantScreen()),
          ),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade500, Colors.indigo.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).homeAIDreamAnalysisTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context).homeAIDreamAnalysisSubtitle,
                        style: TextStyle(color: Colors.purple.shade700, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.arrow_forward_ios, color: Colors.purple.shade600, size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDreamJournalCard(ThemeData theme) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade100,
              Colors.teal.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DreamJournalListScreen()),
          ),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade500, Colors.teal.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.book, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).homeDreamJournalTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context).homeDreamJournalSubtitle,
                        style: TextStyle(color: Colors.blue.shade700, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.arrow_forward_ios, color: Colors.blue.shade600, size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(ThemeData theme) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProgressScreen()),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.trending_up, size: 40, color: theme.primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내 진행 상황',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('상세 통계 보기', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechniqueCard(ThemeData theme) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TechniqueListScreen()),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.menu_book, color: theme.colorScheme.secondary, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '자각몽 기법 가이드',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'MILD, WBTB, Reality Check 등 상세 설명',
                      style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
            ],
          ),
        ),
      ),
    );
  }
}
