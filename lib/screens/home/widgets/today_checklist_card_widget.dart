import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../utils/config/constants.dart';
import '../../../services/workout/lucid_dream_program_service.dart';
import '../../../models/lucid_dream_task.dart';

/// 오늘의 자각몽 체크리스트를 표시하는 카드 위젯
class TodayChecklistCardWidget extends StatelessWidget {
  final TodayChecklist? todayChecklist;
  final Set<LucidDreamTaskType> completedTasks;
  final Function(LucidDreamTaskType, bool) onTaskToggle;
  final VoidCallback? onStartChecklist;

  const TodayChecklistCardWidget({
    super.key,
    required this.todayChecklist,
    required this.completedTasks,
    required this.onTaskToggle,
    this.onStartChecklist,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(AppColors.dreamGradient[0]),
                  Color(AppColors.dreamGradient[1]),
                ],
              )
            : null,
        color: isDark ? null : const Color(AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(l10n, theme),
          const SizedBox(height: AppConstants.paddingM),
          if (todayChecklist != null) ...[
            _buildDayInfo(l10n),
            const SizedBox(height: 16),
            _buildTasksList(l10n, theme),
            const SizedBox(height: 16),
            _buildProgress(l10n, theme),
            if (_isAllCompleted()) ...[
              const SizedBox(height: 16),
              _buildCompletionReward(l10n, theme),
            ],
          ] else ...[
            _buildNoChecklistMessage(l10n, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: [
        Icon(
          isDark ? Icons.nightlight_round : Icons.today,
          color: const Color(AppColors.accentColor),
          size: 24,
        ),
        const SizedBox(width: AppConstants.paddingS),
        Text(
          l10n.todayMissionTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(AppColors.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildDayInfo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(AppColors.primaryColor).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Day ${todayChecklist!.day}',
        style: const TextStyle(
          color: Color(AppColors.primaryColor),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTasksList(AppLocalizations l10n, ThemeData theme) {
    final tasks = todayChecklist!.checklist.tasks;

    return Column(
      children: tasks.map((task) {
        final isCompleted = completedTasks.contains(task.type);
        return _buildTaskItem(task, isCompleted, l10n, theme);
      }).toList(),
    );
  }

  Widget _buildTaskItem(
    LucidDreamTask task,
    bool isCompleted,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTaskToggle(task.type, !isCompleted),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green.withValues(alpha: 0.1)
                  : theme.colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCompleted
                    ? Colors.green
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // 체크박스
                Icon(
                  isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isCompleted ? Colors.green : Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 12),
                // 태스크 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTaskTitle(task, l10n),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? Colors.green[700]
                              : theme.colorScheme.onSurface,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (!task.isRequired) ...[
                        const SizedBox(height: 2),
                        Text(
                          l10n.taskOptional,
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTaskTitle(LucidDreamTask task, AppLocalizations l10n) {
    switch (task.type) {
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

  Widget _buildProgress(AppLocalizations l10n, ThemeData theme) {
    final total = todayChecklist!.totalTaskCount;
    final completed = completedTasks.length;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(AppColors.primaryColor),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.checklistProgressLabel,
                style: TextStyle(
                  color: const Color(AppColors.primaryColor),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$completed/$total',
                style: TextStyle(
                  color: const Color(AppColors.primaryColor),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(AppColors.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionReward(AppLocalizations l10n, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.stars, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              l10n.checklistCompletedReward,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoChecklistMessage(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.programCompleted,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bool _isAllCompleted() {
    if (todayChecklist == null) return false;
    final requiredTasks = todayChecklist!.checklist.tasks
        .where((t) => t.isRequired)
        .map((t) => t.type)
        .toSet();
    return requiredTasks.every((type) => completedTasks.contains(type));
  }
}
