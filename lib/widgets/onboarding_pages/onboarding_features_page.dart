import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';
import '../../utils/config/constants.dart';
import 'onboarding_feature_item.dart';

/// 온보딩 기능 페이지
class OnboardingFeaturesPage extends StatelessWidget {
  const OnboardingFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      child: Column(
        children: [
          const SizedBox(height: AppConstants.paddingXL),
          Text(
            AppLocalizations.of(context).keyFeatures,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingXL * 2),
          OnboardingFeatureItem(
            icon: Icons.science,
            title: AppLocalizations.of(context).scientificBasisTitle,
            description: AppLocalizations.of(context).scientificBasisDesc,
          ),
          const SizedBox(height: AppConstants.paddingXL),
          OnboardingFeatureItem(
            icon: Icons.trending_up,
            title: AppLocalizations.of(context).progressiveOverloadTitle,
            description: AppLocalizations.of(context).progressiveOverloadDesc,
          ),
          const SizedBox(height: AppConstants.paddingXL),
          OnboardingFeatureItem(
            icon: Icons.psychology,
            title: AppLocalizations.of(context).rpeAdaptationTitle,
            description: AppLocalizations.of(context).rpeAdaptationDesc,
          ),
          const SizedBox(height: AppConstants.paddingXL),
          OnboardingFeatureItem(
            icon: Icons.emoji_events,
            title: AppLocalizations.of(context).chadEvolutionTitle,
            description: AppLocalizations.of(context).chadEvolutionDesc,
          ),
        ],
      ),
    );
  }
}
