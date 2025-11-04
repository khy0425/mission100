import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../utils/config/constants.dart';

/// 운동 화면 상단 헤더를 표시하는 위젯
///
/// 기능:
/// - 운동 제목 표시
/// - 현재 세트/총 세트 정보
/// - 목표 횟수 표시
/// - 전체 진행률 표시
class WorkoutHeaderWidget extends StatelessWidget {
  final String workoutTitle;
  final int currentSet;
  final int totalSets;
  final int currentTargetReps;
  final double overallProgress;
  final bool isTablet;
  final bool isLargeTablet;

  const WorkoutHeaderWidget({
    super.key,
    required this.workoutTitle,
    required this.currentSet,
    required this.totalSets,
    required this.currentTargetReps,
    required this.overallProgress,
    this.isTablet = false,
    this.isLargeTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleFontSize = isLargeTablet ? 24.0 : (isTablet ? 20.0 : 18.0);
    final padding = isLargeTablet ? 32.0 : (isTablet ? 24.0 : 16.0);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Column(
        children: [
          Text(
            workoutTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: const Color(AppColors.primaryColor),
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  AppLocalizations.of(
                    context,
                  ).setFormat(currentSet + 1, totalSets),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(AppColors.primaryColor),
                    fontWeight: FontWeight.w600,
                    fontSize: isLargeTablet ? 16.0 : (isTablet ? 14.0 : 12.0),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: padding / 2,
                ),
                decoration: BoxDecoration(
                  color: const Color(AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Text(
                  AppLocalizations.of(
                    context,
                  ).targetRepsLabel(currentTargetReps),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: isLargeTablet ? 14.0 : (isTablet ? 12.0 : 10.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: padding),
          LinearProgressIndicator(
            value: overallProgress,
            backgroundColor: Colors.grey.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
