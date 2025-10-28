import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'onboarding_step_item.dart';

/// 온보딩 시작 페이지
class OnboardingGetStartedPage extends StatelessWidget {
  const OnboardingGetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(AppColors.primaryColor).withValues(alpha: 0.2),
                  const Color(AppColors.primaryColor).withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.rocket_launch,
              size: 70,
              color: Color(AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: AppConstants.paddingXL * 2),
          Text(
            '준비되셨나요?',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingL),
          Text(
            '먼저 간단한 레벨 테스트로\n당신의 시작점을 찾아보세요',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingXL * 2),
          const OnboardingStepItem(emoji: '1️⃣', text: '레벨 테스트 (30초)'),
          const SizedBox(height: AppConstants.paddingM),
          const OnboardingStepItem(emoji: '2️⃣', text: '운동 시작일 설정'),
          const SizedBox(height: AppConstants.paddingM),
          const OnboardingStepItem(emoji: '3️⃣', text: '14주 여정 시작!'),
        ],
      ),
    );
  }
}
