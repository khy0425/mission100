import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 온보딩 현실 확인 방법 페이지 - 실천 가능한 테크닉 3가지
class OnboardingRealityCheckPage extends StatelessWidget {
  const OnboardingRealityCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    decoration: BoxDecoration(
                      color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.quiz_rounded,
                      size: 60,
                      color: Color(AppColors.primaryColor),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingL),
                  Text(
                    '현실 확인 방법',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(AppColors.primaryColor),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingS),
                  Text(
                    '꿈속에서 깨어나는 3가지 방법',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),

            // 방법 1: 손가락 세기
            _buildMethodCard(
              theme: theme,
              number: '1',
              icon: Icons.back_hand_rounded,
              title: '손가락 세기',
              description: '하루에 10번 이상 손가락을 세어보세요',
              reality: '현실: 손가락 5개',
              dream: '꿈: 손가락 6개 이상 또는 이상하게 보임',
              tip: '습관이 되면 꿈에서도 자동으로 확인하게 됩니다',
              color: const Color(0xFF4CAF50),
            ),
            const SizedBox(height: AppConstants.paddingL),

            // 방법 2: 시계 두 번 보기
            _buildMethodCard(
              theme: theme,
              number: '2',
              icon: Icons.access_time_rounded,
              title: '시계 두 번 보기',
              description: '시계를 보고, 다른 곳을 봤다가, 다시 보기',
              reality: '현실: 시간이 정상적으로 흐름',
              dream: '꿈: 시간이 크게 바뀌거나 숫자가 이상함',
              tip: '디지털/아날로그 시계 모두 가능',
              color: const Color(0xFF2196F3),
            ),
            const SizedBox(height: AppConstants.paddingL),

            // 방법 3: 코 막고 숨쉬기
            _buildMethodCard(
              theme: theme,
              number: '3',
              icon: Icons.air_rounded,
              title: '코 막고 숨쉬기',
              description: '코를 막고 숨을 들이마셔보세요',
              reality: '현실: 숨을 쉴 수 없음',
              dream: '꿈: 코를 막아도 숨을 쉴 수 있음',
              tip: '가장 확실한 방법 중 하나',
              color: const Color(0xFFFF9800),
            ),
            const SizedBox(height: AppConstants.paddingXL),

            // 실천 가이드
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
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                border: Border.all(
                  color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.rocket_launch_rounded,
                        color: Color(AppColors.primaryColor),
                        size: 28,
                      ),
                      const SizedBox(width: AppConstants.paddingS),
                      Text(
                        '실천 방법',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  _buildPracticeStep(
                    theme,
                    '1',
                    '하루에 10번 이상 현실 확인',
                  ),
                  _buildPracticeStep(
                    theme,
                    '2',
                    '이상한 일이 있을 때마다 확인',
                  ),
                  _buildPracticeStep(
                    theme,
                    '3',
                    '2-3주 후 꿈에서 자동으로 확인',
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.psychology_rounded,
                          color: Color(AppColors.primaryColor),
                          size: 24,
                        ),
                        const SizedBox(width: AppConstants.paddingS),
                        Expanded(
                          child: Text(
                            '습관이 되면 꿈에서도 자연스럽게!',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: const Color(AppColors.primaryColor),
                              fontWeight: FontWeight.bold,
                            ),
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

  Widget _buildMethodCard({
    required ThemeData theme,
    required String number,
    required IconData icon,
    required String title,
    required String description,
    required String reality,
    required String dream,
    required String tip,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: color, size: 24),
                        const SizedBox(width: AppConstants.paddingS),
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),

          // 설명
          Text(
            description,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),

          // 현실 vs 꿈
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildResultRow(
                  theme,
                  Icons.wb_sunny_rounded,
                  reality,
                  Colors.blue,
                ),
                const SizedBox(height: AppConstants.paddingS),
                _buildResultRow(
                  theme,
                  Icons.nightlight_round,
                  dream,
                  const Color(AppColors.primaryColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),

          // 팁
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingM,
              vertical: AppConstants.paddingS,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tips_and_updates_rounded,
                  color: color,
                  size: 18,
                ),
                const SizedBox(width: AppConstants.paddingS),
                Expanded(
                  child: Text(
                    tip,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(
    ThemeData theme,
    IconData icon,
    String text,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppConstants.paddingS),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.black87, // 흰색 배경에서 항상 보이도록 어두운 색 고정
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPracticeStep(ThemeData theme, String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingS),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(AppColors.primaryColor),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
