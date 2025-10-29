import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../generated/app_localizations.dart';
import '../../utils/config/constants.dart';
import '../../services/core/first_launch_service.dart';
import '../../widgets/onboarding_pages/onboarding_welcome_page.dart';
import '../../widgets/onboarding_pages/onboarding_mission_page.dart';
import '../../widgets/onboarding_pages/onboarding_features_page.dart';
import '../../widgets/onboarding_pages/onboarding_get_started_page.dart';
import 'initial_test_screen.dart';

/// 🚀 온보딩 화면
///
/// 앱 첫 실행 시 사용자에게 앱을 소개하는 화면
/// - 앱의 핵심 가치 제안
/// - 주요 기능 소개
/// - 시작하기 버튼으로 레벨 테스트로 이동
class QuickOnboardingScreen extends StatefulWidget {
  const QuickOnboardingScreen({super.key});

  @override
  State<QuickOnboardingScreen> createState() => _QuickOnboardingScreenState();
}

class _QuickOnboardingScreenState extends State<QuickOnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLevelTest();
    }
  }

  void _skipOnboarding() {
    _navigateToLevelTest();
  }

  void _navigateToLevelTest() async {
    // 온보딩 완료 표시
    await FirstLaunchService.setOnboardingCompleted();
    await FirstLaunchService.setFirstLaunchCompleted();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => const InitialTestScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Skip 버튼
              if (_currentPage < _totalPages - 1)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    child: TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        AppLocalizations.of(context).skip,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(AppColors.primaryColor),
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
                  children: const [
                    OnboardingWelcomePage(),
                    OnboardingMissionPage(),
                    OnboardingFeaturesPage(),
                    OnboardingGetStartedPage(),
                  ],
                ),
              ),

              // 페이지 인디케이터
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingL,
                ),
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
                      width: _currentPage == index ? 32 : 8,
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

              // 시작하기/다음 버튼
              Padding(
                padding: const EdgeInsets.all(AppConstants.paddingL),
                child: SizedBox(
                  width: double.infinity,
                  height: AppConstants.buttonHeightL,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(AppColors.primaryColor),
                      foregroundColor: theme.colorScheme.surface,
                      elevation: AppConstants.elevationM,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusM,
                        ),
                      ),
                    ),
                    child: Text(
                      _currentPage == _totalPages - 1
                          ? AppLocalizations.of(context).getStarted
                          : AppLocalizations.of(context).next,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
