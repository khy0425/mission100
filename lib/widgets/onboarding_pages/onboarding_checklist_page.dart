import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 온보딩 체크리스트 페이지 - 매일 수행할 과제 소개
class OnboardingChecklistPage extends StatelessWidget {
  const OnboardingChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppConstants.paddingL),

            // 체크리스트 아이콘
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
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
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(AppColors.primaryColor),
                      const Color(AppColors.primaryColor).withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.checklist_rounded,
                  size: 70,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),

            // 제목
            Text(
              '매일의 실천',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(AppColors.primaryColor),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingM),

            // 설명
            Text(
              '자각몽을 꾸기 위해서는\n매일 꾸준한 실천이 필요해요',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingXL),

            // 체크리스트 항목들
            _buildChecklistItem(
              theme,
              Icons.edit_note_rounded,
              '꿈 일기 작성',
              '아침에 일어나면 꿈을 바로 기록하세요',
              '기억력 향상과 꿈 인식에 필수!',
            ),
            const SizedBox(height: AppConstants.paddingM),
            _buildChecklistItem(
              theme,
              Icons.visibility_rounded,
              '현실 점검',
              '하루 중 여러 번 "지금 꿈인가?" 확인',
              '습관이 꿈 속에서도 나타나요',
            ),
            const SizedBox(height: AppConstants.paddingM),
            _buildChecklistItem(
              theme,
              Icons.bedtime_rounded,
              'MILD 기법',
              '잠들기 전 자각몽을 상상하며 의도 설정',
              '가장 효과적인 자각몽 유도법',
            ),
            const SizedBox(height: AppConstants.paddingXL),

            // 격려 메시지
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(AppColors.primaryColor).withValues(alpha: 0.1),
                    const Color(AppColors.primaryColor).withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                border: Border.all(
                  color: const Color(AppColors.primaryColor).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: Color(AppColors.primaryColor),
                    size: 32,
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  Expanded(
                    child: Text(
                      '매일 3가지만 실천하면\n평균 2-4주 안에 첫 자각몽을 경험해요!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
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

  Widget _buildChecklistItem(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
    String tip,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingS),
            decoration: BoxDecoration(
              color: const Color(AppColors.primaryColor).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
            ),
            child: Icon(
              icon,
              color: const Color(AppColors.primaryColor),
              size: 28,
            ),
          ),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(AppColors.primaryColor),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(AppColors.primaryColor),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
