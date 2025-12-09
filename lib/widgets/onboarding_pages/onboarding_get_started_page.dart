import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';
import 'onboarding_step_item.dart';

/// 온보딩 시작 페이지
class OnboardingGetStartedPage extends StatelessWidget {
  const OnboardingGetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppConstants.paddingXL),
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
              Icons.nightlight_round,
              size: 70,
              color: Color(AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: AppConstants.paddingXL * 2),
          Text(
            l10n.readyToStart,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingL),
          Text(
            l10n.readyToStartSubtitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingXL * 2),
          OnboardingStepItem(emoji: '🌙', text: l10n.getStartedStep1),
          const SizedBox(height: AppConstants.paddingM),
          OnboardingStepItem(emoji: '✨', text: l10n.getStartedStep2),
          const SizedBox(height: AppConstants.paddingM),
          OnboardingStepItem(emoji: '🎯', text: l10n.getStartedStep3),
          const SizedBox(height: AppConstants.paddingXL * 3),
        ],
      ),
    );
  }
}
