import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 온보딩 꿈일기 작성법 페이지 - 좋은 예시와 나쁜 예시
class OnboardingDreamJournalPage extends StatelessWidget {
  const OnboardingDreamJournalPage({super.key});

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
                      Icons.menu_book_rounded,
                      size: 60,
                      color: Color(AppColors.primaryColor),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingL),
                  Text(
                    '꿈일기 작성법',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(AppColors.primaryColor),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingS),
                  Text(
                    '명석몽의 첫 단계는 꿈을 기억하는 것',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),

            // 좋은 예시
            _buildExampleCard(
              theme: theme,
              title: '좋은 예시',
              icon: Icons.check_circle_rounded,
              iconColor: Colors.green,
              backgroundColor: Colors.green.withValues(alpha: 0.1),
              borderColor: Colors.green.withValues(alpha: 0.3),
              content: [
                _ExampleText(
                  theme: theme,
                  text: '오전 6시에 깼을 때 기억:',
                  isBold: true,
                ),
                const SizedBox(height: AppConstants.paddingS),
                _ExampleText(
                  theme: theme,
                  text: '하늘을 날고 있었다. 팔을 펼치면 자연스럽게 위로 올라갔다. '
                      '아래로 바다가 보였는데 파란색이 아니라 보라색이었다. '
                      '구름 사이를 지나갈 때 촉촉하고 차가운 느낌이 있었다. '
                      '자유로운 기분이 들어서 웃음이 나왔다.',
                ),
                const SizedBox(height: AppConstants.paddingM),
                _TipBubble(
                  theme: theme,
                  text: '시간, 감각, 감정, 세부 사항을 모두 기록',
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingL),

            // 나쁜 예시
            _buildExampleCard(
              theme: theme,
              title: '나쁜 예시',
              icon: Icons.cancel_rounded,
              iconColor: Colors.red,
              backgroundColor: Colors.red.withValues(alpha: 0.1),
              borderColor: Colors.red.withValues(alpha: 0.3),
              content: [
                _ExampleText(
                  theme: theme,
                  text: '꿈 꿨는데 기억 안남',
                  isBold: true,
                ),
                const SizedBox(height: AppConstants.paddingM),
                _TipBubble(
                  theme: theme,
                  text: '너무 짧고 세부 사항이 없음',
                  isNegative: true,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingXL),

            // 작성 팁
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
                      const Icon(
                        Icons.tips_and_updates_rounded,
                        color: Color(0xFFFFB74D),
                        size: 24,
                      ),
                      const SizedBox(width: AppConstants.paddingS),
                      Text(
                        '작성 팁',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  _buildTip(theme, Icons.alarm_rounded, '깨자마자 바로 기록'),
                  _buildTip(theme, Icons.visibility_rounded, '본 것을 구체적으로'),
                  _buildTip(theme, Icons.touch_app_rounded, '느낀 감각을 상세히'),
                  _buildTip(theme, Icons.sentiment_satisfied_rounded, '당시의 감정도 함께'),
                  _buildTip(theme, Icons.color_lens_rounded, '색깔과 장소도 중요'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required Color borderColor,
    required List<Widget> content,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: AppConstants.paddingS),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          ...content,
        ],
      ),
    );
  }

  Widget _buildTip(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingS),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(AppColors.primaryColor),
            size: 20,
          ),
          const SizedBox(width: AppConstants.paddingS),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleText extends StatelessWidget {
  final ThemeData theme;
  final String text;
  final bool isBold;

  const _ExampleText({
    required this.theme,
    required this.text,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
      ),
    );
  }
}

class _TipBubble extends StatelessWidget {
  final ThemeData theme;
  final String text;
  final bool isNegative;

  const _TipBubble({
    required this.theme,
    required this.text,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM,
        vertical: AppConstants.paddingS,
      ),
      decoration: BoxDecoration(
        color: isNegative
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: isNegative
              ? Colors.red.withValues(alpha: 0.3)
              : Colors.green.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isNegative ? Icons.close_rounded : Icons.check_rounded,
            color: isNegative ? Colors.red : Colors.green,
            size: 18,
          ),
          const SizedBox(width: AppConstants.paddingXS),
          Flexible(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isNegative ? Colors.red[700] : Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
