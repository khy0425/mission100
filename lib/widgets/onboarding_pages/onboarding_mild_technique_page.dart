import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 온보딩 MILD 테크닉 페이지 - Mnemonic Induction of Lucid Dreams
class OnboardingMILDTechniquePage extends StatelessWidget {
  const OnboardingMILDTechniquePage({super.key});

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
                      Icons.bedtime_rounded,
                      size: 60,
                      color: Color(AppColors.primaryColor),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingL),
                  Text(
                    'MILD 테크닉',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(AppColors.primaryColor),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingS),
                  Text(
                    '자기 전 마음가짐으로 명석몽 유도',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),

            // MILD란?
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
                        Icons.info_rounded,
                        color: Color(AppColors.primaryColor),
                        size: 28,
                      ),
                      const SizedBox(width: AppConstants.paddingS),
                      Text(
                        'MILD란?',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  Text(
                    'Mnemonic Induction of Lucid Dreams\n(기억술을 이용한 명석몽 유도법)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingS),
                  Text(
                    '자기 전 특정 문장을 반복하여 꿈에서 깨어나도록 훈련하는 방법입니다.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),

            // 4단계 프로세스
            Text(
              '4단계 프로세스',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(AppColors.primaryColor),
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),

            _buildStepCard(
              theme: theme,
              step: '1',
              icon: Icons.bedtime_rounded,
              title: '잠들기 전',
              description: '최근 꿈을 떠올립니다',
              example: '"오늘 아침에 날고 있는 꿈을 꿨지"',
              color: const Color(0xFF9C27B0),
            ),
            const SizedBox(height: AppConstants.paddingM),

            _buildStepCard(
              theme: theme,
              step: '2',
              icon: Icons.search_rounded,
              title: '꿈 신호 찾기',
              description: '그 꿈에서 이상한 점을 찾습니다',
              example: '"사람이 날 수 없는데 날고 있었네"',
              color: const Color(0xFF3F51B5),
            ),
            const SizedBox(height: AppConstants.paddingM),

            _buildStepCard(
              theme: theme,
              step: '3',
              icon: Icons.loop_rounded,
              title: '문장 반복',
              description: '이 문장을 마음속으로 반복합니다',
              example: '"다음에 꿈을 꾸면, 꿈인 줄 알아차릴 거야"',
              color: const Color(0xFF00BCD4),
              isHighlight: true,
            ),
            const SizedBox(height: AppConstants.paddingM),

            _buildStepCard(
              theme: theme,
              step: '4',
              icon: Icons.theater_comedy_rounded,
              title: '상상하기',
              description: '꿈에서 깨어나는 모습을 상상합니다',
              example: '"날고 있다가 \'아! 이건 꿈이야\'라고 깨달아"',
              color: const Color(0xFFFF9800),
            ),
            const SizedBox(height: AppConstants.paddingXL),

            // 효과와 기대
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.celebration_rounded,
                        color: Colors.green,
                        size: 28,
                      ),
                      const SizedBox(width: AppConstants.paddingS),
                      Text(
                        '기대 효과',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  _buildBenefit(theme, Icons.schedule_rounded, '1-2주 후부터 효과 시작'),
                  _buildBenefit(theme, Icons.trending_up_rounded, '꾸준히 하면 성공률 증가'),
                  _buildBenefit(theme, Icons.self_improvement_rounded, '습관이 되면 자동으로 작동'),
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
                          Icons.spa_rounded,
                          color: Color(AppColors.primaryColor),
                          size: 24,
                        ),
                        const SizedBox(width: AppConstants.paddingS),
                        Expanded(
                          child: Text(
                            '포기하지 말고 매일 실천하세요!',
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

  Widget _buildStepCard({
    required ThemeData theme,
    required String step,
    required IconData icon,
    required String title,
    required String description,
    required String example,
    required Color color,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isHighlight ? 0.2 : 0.15),
            color.withValues(alpha: isHighlight ? 0.1 : 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(
          color: color.withValues(alpha: isHighlight ? 0.5 : 0.3),
          width: isHighlight ? 3 : 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    step,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: Row(
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
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            description,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.format_quote_rounded,
                  color: Color(AppColors.primaryColor),
                  size: 20,
                ),
                const SizedBox(width: AppConstants.paddingS),
                Expanded(
                  child: Text(
                    example,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
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

  Widget _buildBenefit(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingS),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.green,
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
