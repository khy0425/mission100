import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../generated/app_localizations.dart';
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
        title: const Text('튜토리얼'),
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
                        child: const Text('이전'),
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
                            ? '시작'
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
          const Icon(
            Icons.fitness_center,
            size: 120,
            color: Color(AppColors.primaryColor),
          ),
          const SizedBox(height: AppConstants.paddingXL),
          Text(
            '🏋️ Mission 100',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(AppColors.primaryColor),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingL),
          Text(
            '14주 만에 푸시업 100개 달성',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingXL),
          const TutorialFeatureCard(
            icon: Icons.science,
            title: '과학적 근거 기반',
            description: '최신 스포츠 과학 논문(2016-2024)을\n바탕으로 설계된 프로그램',
          ),
          const SizedBox(height: AppConstants.paddingM),
          const TutorialFeatureCard(
            icon: Icons.trending_up,
            title: '점진적 과부하',
            description: '매주 체계적으로 증가하는 운동량으로\n안전하고 효과적인 성장',
          ),
          const SizedBox(height: AppConstants.paddingM),
          const TutorialFeatureCard(
            icon: Icons.favorite,
            title: '개인화된 프로그램',
            description: '당신의 레벨에 맞춘\n맞춤형 운동 계획',
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
            '📋 프로그램 구성',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingXL),
          const ProgramDetailCard(
            title: '⏱️ 기간',
            subtitle: '14주 (총 42회)',
            description: '주 3회 운동 (월, 수, 금)\n48시간 회복 시간 보장',
          ),
          const SizedBox(height: AppConstants.paddingM),
          const ProgramDetailCard(
            title: '💪 구성',
            subtitle: '푸시업 + 피니셔',
            description: '메인: 푸시업 5-9세트\n피니셔: 버피/점프스쿼트 등',
          ),
          const SizedBox(height: AppConstants.paddingM),
          const ProgramDetailCard(
            title: '⏳ 휴식 시간',
            subtitle: '과학적 최적화',
            description: '세트간: 45-120초\n레벨/주차별 자동 조정',
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
                  '💡 꿀팁',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(AppColors.primaryColor),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingS),
                Text(
                  '매 운동 후 RPE(운동자각도)를 기록하면\n다음 운동 강도가 자동으로 조정됩니다!',
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
            '✅ 올바른 푸시업 자세',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingXL),
          const FormCheckItem(
            title: '1. 시작 자세',
            description: '손을 어깨 너비로 벌리고\n몸을 일직선으로 유지',
            icon: Icons.check_circle,
          ),
          const FormCheckItem(
            title: '2. 내려가기',
            description: '가슴이 바닥에 닿을 때까지\n팔꿈치를 45도 각도로 구부리기',
            icon: Icons.check_circle,
          ),
          const FormCheckItem(
            title: '3. 올라오기',
            description: '가슴과 코어에 힘을 주고\n폭발적으로 밀어올리기',
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
                      '⚠️ 주의사항',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[900],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingM),
                const WarningItem(text: '허리가 처지지 않도록 코어에 힘주기'),
                const WarningItem(text: '목을 과도하게 젖히지 않기'),
                const WarningItem(text: '팔꿈치를 몸에 너무 붙이지 않기'),
                const WarningItem(text: '통증이 느껴지면 즉시 중단'),
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
            '📊 RPE란?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            'Rate of Perceived Exertion\n(운동자각도)',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppConstants.paddingXL),
          const RPEScaleItem(level: 6, emoji: '😊 너무 쉬워요', description: '다음엔 더 할 수 있어요'),
          const RPEScaleItem(level: 7, emoji: '🙂 적당해요', description: '딱 좋은 난이도예요'),
          const RPEScaleItem(level: 8, emoji: '😤 힘들어요', description: '완료하기 버거웠어요'),
          const RPEScaleItem(level: 9, emoji: '😫 너무 힘들어요', description: '거의 불가능했어요'),
          const RPEScaleItem(level: 10, emoji: '🤯 한계 돌파!', description: '정말 최선을 다했어요'),
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
                  '🎯 똑똑한 자동 조정',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingM),
                Text(
                  'RPE를 기록하면 다음 운동 강도가\n자동으로 최적화됩니다!\n\n• RPE 6-7: 난이도 +5%\n• RPE 8: 유지\n• RPE 9-10: 난이도 -5%',
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
            '🔬 과학적 근거',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            '최신 연구 결과를 바탕으로 설계되었습니다',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppConstants.paddingXL),
          const ResearchCard(
            author: 'Schoenfeld et al. (2016, 2019)',
            topic: '근비대와 훈련 빈도',
            finding: '주 3회 훈련이 근육 성장에 최적\n48시간 회복 시간 권장',
          ),
          const SizedBox(height: AppConstants.paddingM),
          const ResearchCard(
            author: 'Grgic et al. (2018)',
            topic: '세트간 휴식 시간',
            finding: '60-120초 휴식이\n근비대에 가장 효과적',
          ),
          const SizedBox(height: AppConstants.paddingM),
          const ResearchCard(
            author: 'Plotkin et al. (2022)',
            topic: '점진적 과부하',
            finding: '점진적 반복 증가가\n근력 향상에 효과적',
          ),
          const SizedBox(height: AppConstants.paddingM),
          const ResearchCard(
            author: 'Wang et al. (2024)',
            topic: 'HIIT + 저항운동 병행',
            finding: '유산소와 근력운동 병행 시\n체력과 근력 동시 향상',
          ),
          const SizedBox(height: AppConstants.paddingXL),
          Center(
            child: TextButton.icon(
              onPressed: () {
                // TODO: 과학적 근거 상세 페이지로 이동
              },
              icon: const Icon(Icons.article),
              label: const Text('전체 참고문헌 보기'),
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
