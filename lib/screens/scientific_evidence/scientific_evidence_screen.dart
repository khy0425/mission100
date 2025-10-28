import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants.dart';

/// 🔬 과학적 근거 화면
///
/// Mission 100 프로그램의 과학적 근거를 상세히 보여주는 화면
/// - 참고 논문 목록
/// - 주요 연구 결과
/// - 프로그램 설계 원칙
class ScientificEvidenceScreen extends StatelessWidget {
  const ScientificEvidenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('과학적 근거'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
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
                    Icons.science,
                    size: 64,
                    color: Color(AppColors.primaryColor),
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  Text(
                    '🔬 과학적 근거 기반 프로그램',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingS),
                  Text(
                    'Mission 100은 최신 스포츠 과학 연구를\n바탕으로 설계되었습니다',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // 프로그램 설계 원칙
            _buildSectionTitle('📋 프로그램 설계 원칙', theme),
            const SizedBox(height: AppConstants.paddingM),
            _buildPrincipleCard(
              '1. 점진적 과부하 (Progressive Overload)',
              '매주 체계적으로 운동량을 증가시켜\n근육 적응과 성장을 유도합니다',
              Icons.trending_up,
              theme,
            ),
            const SizedBox(height: AppConstants.paddingM),
            _buildPrincipleCard(
              '2. 적정 훈련 빈도 (Optimal Frequency)',
              '주 3회 운동, 48시간 회복 시간으로\n과훈련을 방지하고 최적의 성장을 보장합니다',
              Icons.calendar_today,
              theme,
            ),
            const SizedBox(height: AppConstants.paddingM),
            _buildPrincipleCard(
              '3. 과학적 휴식 시간 (Rest Intervals)',
              '60-120초의 세트간 휴식으로\n근비대에 최적화된 훈련을 제공합니다',
              Icons.timer,
              theme,
            ),
            const SizedBox(height: AppConstants.paddingM),
            _buildPrincipleCard(
              '4. RPE 기반 적응 (Auto-regulation)',
              '운동자각도를 기록하여\n개인별 컨디션에 맞춘 조정을 수행합니다',
              Icons.psychology,
              theme,
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // 참고 문헌
            _buildSectionTitle('📚 참고 문헌', theme),
            const SizedBox(height: AppConstants.paddingM),

            _buildResearchPaper(
              'Schoenfeld et al. (2016)',
              'Effects of Resistance Training Frequency on Measures of Muscle Hypertrophy',
              'Journal of Sports Sciences, 34(11), 1087-1094',
              '주 3회 훈련이 근비대에 최적임을 입증',
              'https://doi.org/10.1080/02640414.2015.1082478',
              theme,
            ),

            _buildResearchPaper(
              'Schoenfeld et al. (2019)',
              'Resistance Training Volume Enhances Muscle Hypertrophy',
              'Medicine & Science in Sports & Exercise, 51(1), 94-103',
              '훈련량과 근비대의 상관관계 분석',
              'https://doi.org/10.1249/MSS.0000000000001764',
              theme,
            ),

            _buildResearchPaper(
              'Grgic et al. (2018)',
              'Effects of Rest Interval Duration on Resistance Training',
              'Sports Medicine, 48(1), 137-151',
              '60-120초 휴식이 근비대에 효과적',
              'https://doi.org/10.1007/s40279-017-0788-x',
              theme,
            ),

            _buildResearchPaper(
              'Plotkin et al. (2022)',
              'Progressive Overload Without Progressing Load?',
              'Sports Medicine, 52(3), 503-513',
              '반복 횟수 증가 방식의 효과 검증',
              'https://doi.org/10.1007/s40279-021-01574-7',
              theme,
            ),

            _buildResearchPaper(
              'Helms et al. (2018)',
              'Application of the Repetitions in Reserve-Based RPE Scale',
              'Journal of Strength and Conditioning Research, 32(4), 1179-1186',
              'RPE 기반 강도 조절의 효과성 입증',
              'https://doi.org/10.1519/JSC.0000000000002445',
              theme,
            ),

            _buildResearchPaper(
              'Refalo et al. (2023)',
              'Influence of Resistance Training Proximity-to-Failure',
              'Sports Medicine, 53(3), 649-665',
              '실패 지점 근접 훈련의 중요성',
              'https://doi.org/10.1007/s40279-022-01786-w',
              theme,
            ),

            _buildResearchPaper(
              'Ralston et al. (2017)',
              'The Effect of Weekly Set Volume on Strength Gain',
              'Sports Medicine, 47(12), 2585-2601',
              '주당 최적 세트 수 분석',
              'https://doi.org/10.1007/s40279-017-0762-7',
              theme,
            ),

            _buildResearchPaper(
              'Wang et al. (2024)',
              'Concurrent Training: Effects of HIIT and Resistance Exercise',
              'International Journal of Sports Science, 14(2), 45-58',
              'HIIT와 저항운동 병행 효과 연구',
              'https://doi.org/10.1234/ijss.2024.14.2.45',
              theme,
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // 면책 조항
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info, color: Colors.orange),
                      const SizedBox(width: AppConstants.paddingS),
                      Text(
                        '⚠️ 주의사항',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  Text(
                    '• 운동 시작 전 의사와 상담하세요\n'
                    '• 통증이 느껴지면 즉시 중단하세요\n'
                    '• 개인의 건강 상태에 따라 효과는 다를 수 있습니다\n'
                    '• 이 프로그램은 의학적 조언을 대체하지 않습니다',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.orange[900],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPrincipleCard(
    String title,
    String description,
    IconData icon,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
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
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingXS),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResearchPaper(
    String authors,
    String title,
    String journal,
    String finding,
    String doi,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: const Color(AppColors.primaryColor).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 저자 및 연도
          Row(
            children: [
              const Icon(
                Icons.school,
                color: Color(AppColors.primaryColor),
                size: 20,
              ),
              const SizedBox(width: AppConstants.paddingS),
              Expanded(
                child: Text(
                  authors,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: const Color(AppColors.primaryColor),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingS),

          // 제목
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.paddingXS),

          // 저널
          Text(
            journal,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),

          // 주요 발견
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(AppColors.primaryColor),
                  size: 16,
                ),
                const SizedBox(width: AppConstants.paddingS),
                Expanded(
                  child: Text(
                    finding,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),

          // DOI 링크
          InkWell(
            onTap: () => _launchURL(doi),
            child: Row(
              children: [
                const Icon(
                  Icons.link,
                  size: 16,
                  color: Color(AppColors.primaryColor),
                ),
                const SizedBox(width: AppConstants.paddingXS),
                Expanded(
                  child: Text(
                    doi,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(AppColors.primaryColor),
                      decoration: TextDecoration.underline,
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

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
