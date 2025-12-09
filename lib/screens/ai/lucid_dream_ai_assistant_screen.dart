import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/workout/daily_task_service.dart';
import '../../services/workout/lucid_dream_program_service.dart';
import '../../services/data/database_service.dart';
import '../../models/lucid_dream_task.dart';
import '../../models/user_profile.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';
import '../../widgets/common/ad_banner_widget.dart';
import '../dream_journal/dream_journal_write_screen.dart';
import '../tasks/reality_check_screen.dart';
import '../tasks/mild_affirmation_screen.dart';
import '../tasks/sleep_hygiene_screen.dart';
import '../tasks/wbtb_screen.dart';
import '../tasks/meditation_screen.dart';

/// 자각몽 태스크 화면 (체크리스트와 동일)
///
/// 오늘의 자각몽 태스크 목록을 표시하고 각 태스크 화면으로 이동
class LucidDreamAIAssistantScreen extends StatefulWidget {
  const LucidDreamAIAssistantScreen({super.key});

  @override
  State<LucidDreamAIAssistantScreen> createState() =>
      _LucidDreamAIAssistantScreenState();
}

class _LucidDreamAIAssistantScreenState
    extends State<LucidDreamAIAssistantScreen> {
  final LucidDreamProgramService _programService = LucidDreamProgramService();
  final DatabaseService _databaseService = DatabaseService();
  TodayChecklist? _todayChecklist;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodayChecklist();
  }

  Future<void> _loadTodayChecklist() async {
    try {
      // 사용자 프로필 로드
      final profile = await _databaseService.getUserProfile();

      // 프로필이 null이면 기본 프로필 생성
      final userProfile = profile ??
          UserProfile(
            id: 1,
            level: UserLevel.rising,
            initialMaxReps: 10,
            startDate: DateTime.now(),
          );

      final checklist = _programService.getTodayChecklist(userProfile);
      setState(() {
        _todayChecklist = checklist;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ 체크리스트 로드 실패: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToTaskScreen(LucidDreamTaskType taskType) {
    Widget screen;

    switch (taskType) {
      case LucidDreamTaskType.dreamJournal:
        screen = DreamJournalWriteScreen();
        break;
      case LucidDreamTaskType.realityCheck:
        screen = RealityCheckScreen();
        break;
      case LucidDreamTaskType.mildAffirmation:
        screen = MildAffirmationScreen();
        break;
      case LucidDreamTaskType.sleepHygiene:
        screen = SleepHygieneScreen();
        break;
      case LucidDreamTaskType.wbtb:
        screen = WBTBScreen();
        break;
      case LucidDreamTaskType.meditation:
        screen = MeditationScreen();
        break;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  String _getTaskTitle(LucidDreamTaskType taskType, AppLocalizations l10n) {
    switch (taskType) {
      case LucidDreamTaskType.dreamJournal:
        return l10n.taskDreamJournal;
      case LucidDreamTaskType.realityCheck:
        return l10n.taskRealityCheck;
      case LucidDreamTaskType.mildAffirmation:
        return l10n.taskMildAffirmation;
      case LucidDreamTaskType.sleepHygiene:
        return l10n.taskSleepHygiene;
      case LucidDreamTaskType.wbtb:
        return l10n.taskWbtb;
      case LucidDreamTaskType.meditation:
        return l10n.taskMeditation;
    }
  }

  String _getTaskDescription(LucidDreamTaskType taskType, AppLocalizations l10n) {
    switch (taskType) {
      case LucidDreamTaskType.dreamJournal:
        return l10n.taskDreamJournalDesc;
      case LucidDreamTaskType.realityCheck:
        return l10n.taskRealityCheckDesc;
      case LucidDreamTaskType.mildAffirmation:
        return l10n.taskMildDesc;
      case LucidDreamTaskType.sleepHygiene:
        return l10n.taskSleepHygieneDesc;
      case LucidDreamTaskType.wbtb:
        return l10n.taskWbtbDesc;
      case LucidDreamTaskType.meditation:
        return l10n.taskMeditationDesc;
    }
  }

  String _getTaskIcon(LucidDreamTaskType taskType) {
    switch (taskType) {
      case LucidDreamTaskType.dreamJournal:
        return '📔';
      case LucidDreamTaskType.realityCheck:
        return '💭';
      case LucidDreamTaskType.mildAffirmation:
        return '🌙';
      case LucidDreamTaskType.sleepHygiene:
        return '😴';
      case LucidDreamTaskType.wbtb:
        return '⏰';
      case LucidDreamTaskType.meditation:
        return '🧘';
    }
  }

  Color _getTaskColor(LucidDreamTaskType taskType) {
    switch (taskType) {
      case LucidDreamTaskType.dreamJournal:
        return const Color(0xFF673AB7);
      case LucidDreamTaskType.realityCheck:
        return const Color(0xFF9C27B0);
      case LucidDreamTaskType.mildAffirmation:
        return const Color(0xFF2196F3);
      case LucidDreamTaskType.sleepHygiene:
        return const Color(0xFF673AB7);
      case LucidDreamTaskType.wbtb:
        return const Color(0xFF00BCD4);
      case LucidDreamTaskType.meditation:
        return const Color(0xFF009688);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '오늘의 자각몽 연습',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF26A69A),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 안내 배너
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4CAF50).withOpacity(0.1),
                        const Color(0xFF2196F3).withOpacity(0.1),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xFF26A69A).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '오늘의 미션',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '아래 태스크를 완료하여 토큰을 획득하세요!',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 태스크 목록
                Expanded(
                  child: _todayChecklist == null
                      ? Center(
                          child: Text(
                            '오늘의 체크리스트가 없습니다',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                        )
                      : Consumer<DailyTaskService>(
                          builder: (context, taskService, child) {
                            return ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount:
                                  _todayChecklist!.checklist.tasks.length,
                              itemBuilder: (context, index) {
                                final task =
                                    _todayChecklist!.checklist.tasks[index];
                                final isCompleted = taskService.completedTasks
                                    .contains(task.type);

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildTaskCard(
                                    task,
                                    isCompleted,
                                    theme,
                                  ),
                                );
                              },
                            );
                          },
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

  Widget _buildTaskCard(
    LucidDreamTask task,
    bool isCompleted,
    ThemeData theme,
  ) {
    final l10n = AppLocalizations.of(context);
    final color = _getTaskColor(task.type);
    final icon = _getTaskIcon(task.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToTaskScreen(task.type),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isCompleted
                  ? [
                      Colors.green.withOpacity(0.1),
                      Colors.green.withOpacity(0.05),
                    ]
                  : [
                      color.withOpacity(0.1),
                      color.withOpacity(0.05),
                    ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isCompleted ? Colors.green : color.withOpacity(0.3),
              width: isCompleted ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // 아이콘
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withOpacity(0.2)
                      : color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 태스크 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _getTaskTitle(task.type, l10n),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isCompleted
                                  ? theme.colorScheme.onSurface
                                      .withOpacity(0.6)
                                  : theme.colorScheme.onSurface,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
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
                              color: const Color(0xFFFF9800),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '필수',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getTaskDescription(task.type, l10n),
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // 완료 표시
              if (isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 32,
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
