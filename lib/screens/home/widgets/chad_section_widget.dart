import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/chad_evolution_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/chad_translation_helper.dart';
import '../../../generated/app_localizations.dart';

/// Chad 진화 상태를 표시하는 섹션 위젯
///
/// 기능:
/// - Chad 이미지 및 현재 진화 단계 표시
/// - 진화 진행도 및 다음 진화까지의 정보
/// - 반응형 디자인 (태블릿 대응)
class ChadSectionWidget extends StatelessWidget {
  final double chadImageSize;

  const ChadSectionWidget({super.key, required this.chadImageSize});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ChadEvolutionService>(
      builder: (context, chadService, child) {
        final currentChad = chadService.currentChad;
        final evolutionState = chadService.evolutionState;

        return Container(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          decoration: BoxDecoration(
            color: Color(
              isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : Colors.grey).withValues(
                  alpha: 0.1,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Chad 진화 단계 표시
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingM,
                  vertical: AppConstants.paddingS,
                ),
                decoration: BoxDecoration(
                  color: currentChad.themeColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Text(
                  ChadTranslationHelper.getChadName(context, currentChad),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingM),

              // Chad 이미지
              _buildChadImage(context, chadService, currentChad),

              const SizedBox(height: AppConstants.paddingM),

              // 진화 상태 텍스트
              _buildEvolutionStatusText(context, theme, chadService),

              const SizedBox(height: AppConstants.paddingS),

              // 진화 진행도 바
              _buildEvolutionProgressBar(theme, chadService, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChadImage(
    BuildContext context,
    ChadEvolutionService chadService,
    dynamic currentChad,
  ) {
    return Container(
      width: chadImageSize,
      height: chadImageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: currentChad.themeColor, width: 3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        child: FutureBuilder<ImageProvider>(
          future: chadService.getCurrentChadImage(
            targetSize: chadImageSize.toInt(),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image(
                image: snapshot.data!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/수면모자차드.jpg',
                    fit: BoxFit.cover,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Image.asset('assets/images/수면모자차드.jpg', fit: BoxFit.cover);
            } else {
              return Container(
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildEvolutionStatusText(
    BuildContext context,
    ThemeData theme,
    ChadEvolutionService chadService,
  ) {
    return Text(
      chadService.isMaxEvolution
          ? (Localizations.localeOf(context).languageCode == 'ko'
                ? '최종 진화 완료!'
                : 'Final evolution complete!')
          : (Localizations.localeOf(context).languageCode == 'ko'
                ? '진화 진행 중...'
                : 'Evolution in progress...'),
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEvolutionProgressBar(
    ThemeData theme,
    ChadEvolutionService chadService,
    bool isDark,
  ) {
    final evolutionState = chadService.evolutionState;
    final progress = chadService.evolutionProgress;

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            chadService.currentChad.themeColor,
          ),
        ),
        const SizedBox(height: AppConstants.paddingXS),
        Text(
          '${(progress * 100).toInt()}%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
