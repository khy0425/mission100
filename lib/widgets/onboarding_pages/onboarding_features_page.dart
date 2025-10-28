import 'package:flutter/material.dart';
import '../../utils/constants.dart';
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
            '✨ 주요 기능',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingXL * 2),
          const OnboardingFeatureItem(
            icon: Icons.science,
            title: '과학적 근거 기반',
            description: '최신 스포츠 과학 논문을\n바탕으로 설계된 프로그램',
          ),
          const SizedBox(height: AppConstants.paddingXL),
          const OnboardingFeatureItem(
            icon: Icons.trending_up,
            title: '점진적 과부하',
            description: '매주 체계적으로 증가하는\n운동량으로 안전한 성장',
          ),
          const SizedBox(height: AppConstants.paddingXL),
          const OnboardingFeatureItem(
            icon: Icons.psychology,
            title: 'RPE 기반 적응',
            description: '운동 강도를 기록하면\n자동으로 난이도 조정',
          ),
          const SizedBox(height: AppConstants.paddingXL),
          const OnboardingFeatureItem(
            icon: Icons.emoji_events,
            title: '차드 진화 시스템',
            description: '운동할수록 성장하는\n나만의 캐릭터',
          ),
        ],
      ),
    );
  }
}
