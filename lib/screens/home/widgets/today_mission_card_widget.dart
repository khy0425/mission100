import 'package:flutter/material.dart';
import '../../../generated/app_localizations.dart';
import '../../../utils/constants.dart';
import '../../../models/workout_history.dart';

/// 오늘의 운동 미션을 표시하는 카드 위젯
///
/// 기능:
/// - 오늘의 운동 계획 표시 (주차, 일차, 세트별 목표)
/// - 완료된 운동 표시 (완료 시 녹색으로 표시)
/// - 총 목표 횟수 및 완료 상태 표시
/// - 운동 시작 버튼
class TodayMissionCardWidget extends StatelessWidget {
  final dynamic todayWorkout; // 서비스에서 가져오는 타입
  final WorkoutHistory? todayCompletedWorkout;
  final VoidCallback? onStartWorkout;

  const TodayMissionCardWidget({
    super.key,
    required this.todayWorkout,
    this.todayCompletedWorkout,
    this.onStartWorkout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: Color(isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
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
          _buildHeader(context, theme),
          const SizedBox(height: AppConstants.paddingM),
          if (todayWorkout != null) ...[
            _buildWeekDayInfo(context),
            const SizedBox(height: 16),
            _buildTodayGoal(context, theme),
            const SizedBox(height: 8),
            _buildSetsList(context, theme),
            const SizedBox(height: 16),
            _buildTotalGoal(context, theme),
            const SizedBox(height: 16),
            _buildActionButton(context, theme),
          ] else ...[
            _buildNoWorkoutMessage(context, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        const Icon(Icons.today, color: Color(AppColors.primaryColor), size: 24),
        const SizedBox(width: AppConstants.paddingS),
        Text(
          AppLocalizations.of(context).todayMissionTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(AppColors.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDayInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(AppColors.primaryColor).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        AppLocalizations.of(
          context,
        ).weekDayFormat(
            (todayWorkout!.week ?? 0) as int, (todayWorkout!.day ?? 0) as int),
        style: const TextStyle(
          color: Color(AppColors.primaryColor),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTodayGoal(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        l10n.todaysGoal,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSetsList(BuildContext context, ThemeData theme) {
    final workoutSets = todayWorkout!.workoutSets;

    return Column(
      children: List.generate(workoutSets.length, (index) {
        final setIndex = index + 1;
        final reps = workoutSets[index].reps;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Icon(
                Icons.fitness_center,
                size: 16,
                color:
                    todayCompletedWorkout != null ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)
                    .setRepsFormat(setIndex, reps),
                style: TextStyle(
                  color: todayCompletedWorkout != null
                      ? Colors.green[700]
                      : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTotalGoal(BuildContext context, ThemeData theme) {
    final totalReps = todayWorkout!.totalReps;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: todayCompletedWorkout != null
            ? Colors.green.withValues(alpha: 0.1)
            : const Color(AppColors.primaryColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: todayCompletedWorkout != null
              ? Colors.green
              : const Color(AppColors.primaryColor),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context).totalTarget,
            style: TextStyle(
              color: todayCompletedWorkout != null
                  ? Colors.green[700]
                  : const Color(AppColors.primaryColor),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            AppLocalizations.of(context).totalRepsFormat(totalReps),
            style: TextStyle(
              color: todayCompletedWorkout != null
                  ? Colors.green[700]
                  : const Color(AppColors.primaryColor),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ThemeData theme) {
    if (todayCompletedWorkout != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 24),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).todayWorkoutCompleted,
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onStartWorkout,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppColors.primaryColor),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_arrow, size: 24),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).startWorkout,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoWorkoutMessage(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).noWorkoutToday,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
