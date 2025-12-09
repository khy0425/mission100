import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';
import '../../widgets/tutorial/tutorial_feature_card.dart';
import '../../widgets/tutorial/program_detail_card.dart';
import '../../widgets/tutorial/form_check_item.dart';
import '../../widgets/tutorial/warning_item.dart';
import '../../widgets/tutorial/rpe_scale_item.dart';
import '../../widgets/tutorial/research_card.dart';

/// 🎓 튜토리얼 화면
///
/// 초회 사용자를 위한 앱 사용법 가이드
/// - 운동 방법 설명
/// - 푸시업 폼 가이드
/// - 과학적 근거 소개
/// - RPE(운동자각도) 설명
class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeTutorial();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipTutorial() {
    _completeTutorial();
  }

  void _completeTutorial() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tutorial),
        actions: [
          if (_currentPage < _totalPages - 1)
            TextButton(
              onPressed: _skipTutorial,
              child: Text(
                AppLocalizations.of(context).skip,
                style: const TextStyle(color: Color(AppColors.primaryColor)),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 페이지 인디케이터
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _totalPages,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingXS,
                    ),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(AppColors.primaryColor)
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // 페이지 컨텐츠
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                  HapticFeedback.lightImpact();
                },
                children: [
                  _buildWelcomePage(theme),
                  _buildProgramOverviewPage(theme),
                  _buildPushupFormPage(theme),
                  _buildRPEExplanationPage(theme),
                  _buildScientificEvidencePage(theme),
                ],
              ),
            ),

            // 네비게이션 버튼
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.paddingM,
                          ),
                        ),
                        child: Text(AppLocalizations.of(context).previous),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: AppConstants.paddingM),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(AppColors.primaryColor),
                        foregroundColor: theme.colorScheme.surface,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingM,
                        ),
                      ),
                      child: Text(
                        _currentPage == _totalPages - 1
                            ? AppLocalizations.of(context).start
                            : AppLocalizations.of(context).next,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.surface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 페이지 1: 환영 & 소개
  Widget _buildWelcomePage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        children: [
          const SizedBox(height: AppConstants.paddingXL),
          Image.asset(
            'assets/images/logo/logo_light.png',
            width: 200,
            height: 120,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.nightlight_round,
              size: 120,
              color: Color(AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: AppConstants.paddingL),
          Text(
            'DreamFlow',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(AppColors.primaryColor),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingL),
          Text(
            AppLocalizations.of(context).tutorialWelcomeSubtitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingXL),
          TutorialFeatureCard(
            icon: Icons.science,
            title: AppLocalizations.of(context).tutorialFeature1Title,
            description: AppLocalizations.of(context).tutorialFeature1Desc,
          ),
          const SizedBox(height: AppConstants.paddingM),
          TutorialFeatureCard(
            icon: Icons.trending_up,
            title: AppLocalizations.of(context).tutorialFeature2Title,
            description: AppLocalizations.of(context).tutorialFeature2Desc,
          ),
          const SizedBox(height: AppConstants.paddingM),
          TutorialFeatureCard(
            icon: Icons.favorite,
            title: AppLocalizations.of(context).tutorialFeature3Title,
            description: AppLocalizations.of(context).tutorialFeature3Desc,
          ),
        ],
      ),
    );
  }

  // 페이지 2: 프로그램 개요
  Widget _buildProgramOverviewPage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).tutorialProgramTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingXL),
          ProgramDetailCard(
            title: AppLocalizations.of(context).tutorialDurationTitle,
            subtitle: AppLocalizations.of(context).tutorialDurationSubtitle,
            description: AppLocalizations.of(context).tutorialDurationDesc,
          ),
          const SizedBox(height: AppConstants.paddingM),
          ProgramDetailCard(
            title: AppLocalizations.of(context).tutorialStructureTitle,
            subtitle: AppLocalizations.of(context).tutorialStructureSubtitle,
            description: AppLocalizations.of(context).tutorialStructureDesc,
          ),
          const SizedBox(height: AppConstants.paddingM),
          ProgramDetailCard(
            title: AppLocalizations.of(context).tutorialRestTitle,
            subtitle: AppLocalizations.of(context).tutorialRestSubtitle,
            description: AppLocalizations.of(context).tutorialRestDesc,
          ),
          const SizedBox(height: AppConstants.paddingXL),
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            decoration: BoxDecoration(
              color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(
                color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: Color(AppColors.primaryColor),
                  size: 32,
                ),
                const SizedBox(height: AppConstants.paddingM),
                Text(
                  AppLocalizations.of(context).tutorialTipTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(AppColors.primaryColor),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingS),
                Text(
                  AppLocalizations.of(context).tutorialTipDesc,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 페이지 3: 푸시업 폼 가이드
  Widget _buildPushupFormPage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).tutorialFormTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingXL),
          FormCheckItem(
            title: AppLocalizations.of(context).tutorialForm1Title,
            description: AppLocalizations.of(context).tutorialForm1Desc,
            icon: Icons.check_circle,
          ),
          FormCheckItem(
            title: AppLocalizations.of(context).tutorialForm2Title,
            description: AppLocalizations.of(context).tutorialForm2Desc,
            icon: Icons.check_circle,
          ),
          FormCheckItem(
            title: AppLocalizations.of(context).tutorialForm3Title,
            description: AppLocalizations.of(context).tutorialForm3Desc,
            icon: Icons.check_circle,
          ),
          const SizedBox(height: AppConstants.paddingXL),
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red),
                    const SizedBox(width: AppConstants.paddingS),
                    Text(
                      AppLocalizations.of(context).tutorialWarningTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[900],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingM),
                WarningItem(text: AppLocalizations.of(context).tutorialWarning1),
                WarningItem(text: AppLocalizations.of(context).tutorialWarning2),
                WarningItem(text: AppLocalizations.of(context).tutorialWarning3),
                WarningItem(text: AppLocalizations.of(context).tutorialWarning4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 페이지 4: RPE 설명
  Widget _buildRPEExplanationPage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).tutorialRpeTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            AppLocalizations.of(context).tutorialRpeSubtitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppConstants.paddingXL),
          RPEScaleItem(level: 6, emoji: AppLocalizations.of(context).tutorialRpe6, description: AppLocalizations.of(context).tutorialRpe6Desc),
          RPEScaleItem(level: 7, emoji: AppLocalizations.of(context).tutorialRpe7, description: AppLocalizations.of(context).tutorialRpe7Desc),
          RPEScaleItem(level: 8, emoji: AppLocalizations.of(context).tutorialRpe8, description: AppLocalizations.of(context).tutorialRpe8Desc),
          RPEScaleItem(level: 9, emoji: AppLocalizations.of(context).tutorialRpe9, description: AppLocalizations.of(context).tutorialRpe9Desc),
          RPEScaleItem(level: 10, emoji: AppLocalizations.of(context).tutorialRpe10, description: AppLocalizations.of(context).tutorialRpe10Desc),
          const SizedBox(height: AppConstants.paddingXL),
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(AppColors.primaryColor).withValues(alpha: 0.1),
                  const Color(AppColors.primaryColor).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: Color(AppColors.primaryColor),
                  size: 40,
                ),
                const SizedBox(height: AppConstants.paddingM),
                Text(
                  AppLocalizations.of(context).tutorialAutoAdjustTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingM),
                Text(
                  AppLocalizations.of(context).tutorialAutoAdjustDesc,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 페이지 5: 과학적 근거
  Widget _buildScientificEvidencePage(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).tutorialScienceTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            AppLocalizations.of(context).tutorialScienceSubtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppConstants.paddingXL),
          ResearchCard(
            author: AppLocalizations.of(context).tutorialResearch1Author,
            topic: AppLocalizations.of(context).tutorialResearch1Topic,
            finding: AppLocalizations.of(context).tutorialResearch1Finding,
          ),
          const SizedBox(height: AppConstants.paddingM),
          ResearchCard(
            author: AppLocalizations.of(context).tutorialResearch2Author,
            topic: AppLocalizations.of(context).tutorialResearch2Topic,
            finding: AppLocalizations.of(context).tutorialResearch2Finding,
          ),
          const SizedBox(height: AppConstants.paddingM),
          ResearchCard(
            author: AppLocalizations.of(context).tutorialResearch3Author,
            topic: AppLocalizations.of(context).tutorialFeature2Title,
            finding: AppLocalizations.of(context).tutorialResearch3Finding,
          ),
          const SizedBox(height: AppConstants.paddingM),
          ResearchCard(
            author: AppLocalizations.of(context).tutorialResearch4Author,
            topic: AppLocalizations.of(context).tutorialResearch4Topic,
            finding: AppLocalizations.of(context).tutorialResearch4Finding,
          ),
          const SizedBox(height: AppConstants.paddingXL),
          Center(
            child: TextButton.icon(
              onPressed: () {
                // TODO: 과학적 근거 상세 페이지로 이동
              },
              icon: const Icon(Icons.article),
              label: Text(AppLocalizations.of(context).viewAllReferences),
              style: TextButton.styleFrom(
                foregroundColor: const Color(AppColors.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
