import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/config/constants.dart';
import '../../utils/data/weekly_guide_data.dart';
import '../../screens/guide/weekly_guide_screen.dart';
import '../../services/auth/auth_service.dart';
import '../../screens/settings/subscription_screen.dart';
import 'dart:ui';

/// 홈 화면 주차별 학습 가이드 카드
class WeeklyGuideCardWidget extends StatelessWidget {
  final int currentWeek;

  const WeeklyGuideCardWidget({
    super.key,
    required this.currentWeek,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final guideData = WeeklyGuideData.getGuideForWeek(currentWeek);

    if (guideData == null) {
      return const SizedBox.shrink();
    }

    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final hasAccess = authService.canAccessWeek(currentWeek);

        return Card(
      elevation: AppConstants.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: InkWell(
        onTap: () {
          if (hasAccess) {
            // 접근 가능 - 가이드 화면으로 이동
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WeeklyGuideScreen(weekNumber: currentWeek),
              ),
            );
          } else {
            // 접근 불가 - 구독 화면으로 이동
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SubscriptionScreen(),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        child: Stack(
          children: [
            Container(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            gradient: LinearGradient(
              colors: [
                const Color(AppColors.primaryColor).withValues(alpha: 0.08),
                const Color(AppColors.accentColor).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingS),
                    decoration: BoxDecoration(
                      color: const Color(AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '이번 주 학습 가이드',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: const Color(AppColors.primaryColor),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Week $currentWeek',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(AppColors.primaryColor),
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingM),

              // 구분선
              Container(
                height: 1,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              ),
              const SizedBox(height: AppConstants.paddingM),

              // 학습 내용
              Row(
                children: [
                  const Icon(
                    Icons.auto_stories_rounded,
                    color: Color(AppColors.accentColor),
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.paddingS),
                  Expanded(
                    child: Text(
                      guideData.titleKo,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingS),

              // 학습 목표
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingM),

              // CTA 버튼
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingS,
                ),
                decoration: BoxDecoration(
                  color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  border: Border.all(
                    color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_circle_outline_rounded,
                      color: Color(AppColors.primaryColor),
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.paddingS),
                    Text(
                      '학습 시작하기',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: const Color(AppColors.primaryColor),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

            // 프리미엄 잠금 오버레이
            if (!hasAccess)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppConstants.radiusL),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppConstants.paddingM),
                            decoration: BoxDecoration(
                              color: const Color(AppColors.primaryColor),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingS),
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
                              'Week 3+ 프리미엄 전용',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
        );
      },
    );
  }
}
