import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';
import '../../utils/data/weekly_guide_data.dart';

/// 주차별 학습 가이드 화면
class WeeklyGuideScreen extends StatelessWidget {
  final int weekNumber;

  const WeeklyGuideScreen({
    super.key,
    required this.weekNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final guideData = WeeklyGuideData.getGuideForWeek(weekNumber);

    if (guideData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Week $weekNumber Guide'),
        ),
        body: const Center(
          child: Text('Guide not available'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Week $weekNumber: ${guideData.titleKo}'),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          // 주차 정보 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.paddingL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(AppColors.primaryColor).withValues(alpha: 0.1),
                  const Color(AppColors.accentColor).withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingM,
                        vertical: AppConstants.paddingS,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      ),
                      child: Text(
                        'Week $weekNumber',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingM),
                Text(
                  '이번 주 학습 목표',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: const Color(AppColors.primaryColor),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingS),
                Row(
                  children: [
                    const Icon(
                      Icons.flag_rounded,
                      color: Color(AppColors.accentColor),
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.paddingS),
                    Expanded(
                      child: Text(
                        guideData.goalKo,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 가이드 콘텐츠
          Expanded(
            child: guideData.guideWidget,
          ),
        ],
      ),
    );
  }
}
