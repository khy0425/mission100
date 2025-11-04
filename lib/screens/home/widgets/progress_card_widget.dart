import 'package:flutter/material.dart';
import '../../../utils/config/constants.dart';
import '../../../generated/l10n/app_localizations.dart';

/// 프로그램 진행률을 표시하는 카드 위젯
///
/// 기능:
/// - 전체 프로그램 진행률 (주차별)
/// - 이번 주 완료 일수
/// - 총 운동 세션 진행률
/// - 다음 목표까지의 정보
class ProgressCardWidget extends StatelessWidget {
  final dynamic programProgress; // 서비스에서 가져오는 타입

  const ProgressCardWidget({super.key, required this.programProgress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(6),
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

          // 프로그램 진행률 내용
          if (programProgress == null)
            _buildLoadingOrError(context, theme)
          else
            _buildProgressContent(context, theme),

          const SizedBox(height: AppConstants.paddingM),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        const Icon(
          Icons.trending_up,
          color: Color(AppColors.primaryColor),
          size: 24,
        ),
        const SizedBox(width: AppConstants.paddingS),
        Text(
          AppLocalizations.of(context).programProgress,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(AppColors.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOrError(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: Colors.orange[600], size: 48),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).loadingProgramData,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).progressShownAfterWorkout,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressContent(BuildContext context, ThemeData theme) {
    final currentWeek =
        (programProgress?.weeklyProgress.currentWeek ?? 1) as int;
    final totalWeeks = (programProgress?.totalWeeks ?? 14) as int;
    final progressPercentage =
        (programProgress?.progressPercentage ?? 0.0) as double;
    final completedDaysThisWeek =
        (programProgress?.completedDaysThisWeek ?? 0) as int;
    final totalDaysThisWeek = (programProgress?.totalDaysThisWeek ?? 3) as int;
    final completedSessions = (programProgress?.completedSessions ?? 0) as int;
    final totalSessions = (programProgress?.totalSessions ?? 42) as int;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 전체 프로그램 진행도
          _buildOverallProgress(
            context,
            theme,
            currentWeek,
            totalWeeks,
            progressPercentage,
          ),

          const SizedBox(height: 16),

          // 이번 주 진행률
          _buildWeeklyProgress(
            context,
            theme,
            currentWeek,
            completedDaysThisWeek,
            totalDaysThisWeek,
          ),

          const SizedBox(height: 16),

          // 총 세션 진행률
          _buildSessionProgress(
            context,
            theme,
            completedSessions,
            totalSessions,
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgress(
    BuildContext context,
    ThemeData theme,
    int currentWeek,
    int totalWeeks,
    double progressPercentage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.track_changes,
              color: Color(AppColors.primaryColor),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                AppLocalizations.of(context).overallProgramProgress,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context).weeksFormat(currentWeek, totalWeeks),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progressPercentage.clamp(0.0, 1.0),
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color(AppColors.primaryColor),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(progressPercentage * 100).toStringAsFixed(1)}%',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgress(
    BuildContext context,
    ThemeData theme,
    int currentWeek,
    int completedDaysThisWeek,
    int totalDaysThisWeek,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).thisWeekFormat(currentWeek),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 0,
              child: Text(
                '$completedDaysThisWeek/$totalDaysThisWeek',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                AppLocalizations.of(context).daysCompleted,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: totalDaysThisWeek > 0
              ? completedDaysThisWeek / totalDaysThisWeek
              : 0.0,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            completedDaysThisWeek == totalDaysThisWeek
                ? Colors.green
                : const Color(AppColors.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionProgress(
    BuildContext context,
    ThemeData theme,
    int completedSessions,
    int totalSessions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.fitness_center,
              color: Color(AppColors.primaryColor),
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                AppLocalizations.of(context).totalSessions,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 0,
              child: Text(
                '$completedSessions/$totalSessions',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(AppColors.primaryColor),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '${totalSessions > 0 ? ((completedSessions / totalSessions) * 100).toStringAsFixed(1) : '0.0'}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: totalSessions > 0 ? completedSessions / totalSessions : 0.0,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color(AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
