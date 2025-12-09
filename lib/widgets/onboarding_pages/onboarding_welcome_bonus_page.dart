import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../utils/user_title_helper.dart';

/// 온보딩 환영 보너스 페이지 - 첫 방문 보너스 1토큰 안내
class OnboardingWelcomeBonusPage extends StatelessWidget {
  const OnboardingWelcomeBonusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎁 Gift animation
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
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
                width: 180,
                height: 180,
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
                  Icons.card_giftcard_rounded,
                  size: 100,
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
            const SizedBox(height: AppConstants.paddingM),

            // 보너스 안내
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(AppColors.primaryColor).withValues(alpha: 0.15),
                    const Color(AppColors.primaryColor).withValues(alpha: 0.08),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.stars_rounded,
                        color: Color(AppColors.primaryColor),
                        size: 32,
                      ),
                      const SizedBox(width: AppConstants.paddingS),
                      Text(
                        '첫 방문 보너스',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingL,
                      vertical: AppConstants.paddingM,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.toll_rounded,
                          color: Color(0xFFFFD700),
                          size: 36,
                        ),
                        const SizedBox(width: AppConstants.paddingS),
                        Text(
                          '+ 1 토큰',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(AppColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),

            // 토큰 사용 안내
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_rounded,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: AppConstants.paddingS),
                      Text(
                        '토큰으로 할 수 있는 일',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  _buildTokenFeature(
                    theme,
                    Icons.flash_on_rounded,
                    'AI 빠른 분석',
                    '꿈을 입력하면 즉시 기본 해석',
                    '1 토큰',
                  ),
                  const SizedBox(height: AppConstants.paddingS),
                  _buildTokenFeature(
                    theme,
                    Icons.psychology_rounded,
                    'AI 심층 대화',
                    '루미와 대화하며 꿈의 의미 탐구',
                    '3 토큰',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),

            // 토큰 획득 방법
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4CAF50).withValues(alpha: 0.15),
                    const Color(0xFF4CAF50).withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                border: Border.all(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.play_circle_filled_rounded,
                    color: Color(0xFF4CAF50),
                    size: 32,
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '토큰이 부족하면?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                        Text(
                          '광고 시청으로 무료 충전!',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
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

  Widget _buildTokenFeature(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
    String cost,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
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
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingS,
              vertical: AppConstants.paddingXS,
            ),
            decoration: BoxDecoration(
              color: const Color(AppColors.primaryColor),
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
            ),
            child: Text(
              cost,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
