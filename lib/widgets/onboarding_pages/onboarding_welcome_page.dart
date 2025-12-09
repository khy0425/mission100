import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../utils/user_title_helper.dart';

/// 온보딩 환영 페이지 - 순수 환영 인사
class OnboardingWelcomePage extends StatelessWidget {
  const OnboardingWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppConstants.paddingXL),

            // 달 아이콘
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.5 + (value * 0.5),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(AppColors.primaryColor),
                      const Color(AppColors.primaryColor).withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(AppColors.primaryColor).withValues(alpha: 0.4),
                      blurRadius: 40,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL * 2),

            // 환영 메시지
            Text(
              '환영합니다,',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              UserTitleHelper.defaultTitle,
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(AppColors.primaryColor),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingXL),

            // 앱 소개
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(AppColors.primaryColor).withValues(alpha: 0.15),
                    const Color(AppColors.primaryColor).withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                border: Border.all(
                  color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '꿈의 세계로 떠나는 여정',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(AppColors.primaryColor),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  Text(
                    '자각몽을 통해 꿈 속에서\n깨어나는 법을 배워보세요',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),

            // 핵심 기능 미리보기
            _buildFeaturePreview(
              theme,
              Icons.menu_book_rounded,
              '꿈 일기',
              '매일 꿈을 기록하고 패턴을 발견하세요',
            ),
            const SizedBox(height: AppConstants.paddingM),
            _buildFeaturePreview(
              theme,
              Icons.psychology_rounded,
              'AI 꿈 분석',
              '인공지능이 꿈의 의미를 해석해드려요',
            ),
            const SizedBox(height: AppConstants.paddingM),
            _buildFeaturePreview(
              theme,
              Icons.self_improvement_rounded,
              '자각몽 훈련',
              '과학적 기법으로 자각몽을 유도하세요',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturePreview(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingS),
            decoration: BoxDecoration(
              color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
            ),
            child: Icon(
              icon,
              color: const Color(AppColors.primaryColor),
              size: 24,
            ),
          ),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
