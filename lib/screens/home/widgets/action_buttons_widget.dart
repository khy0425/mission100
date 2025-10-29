import 'package:flutter/material.dart';
import '../../../generated/app_localizations.dart';
import '../../../utils/config/constants.dart';

/// 홈 화면의 주요 액션 버튼들을 표시하는 위젯
///
/// 기능:
/// - 푸시업 튜토리얼 버튼
/// - 푸시업 폼 가이드 버튼
/// - 진행률 추적 버튼
/// - 각 버튼별 고유한 색상과 아이콘
class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onTutorialPressed;
  final VoidCallback? onFormGuidePressed;
  final VoidCallback? onProgressTrackingPressed;

  const ActionButtonsWidget({
    super.key,
    this.onTutorialPressed,
    this.onFormGuidePressed,
    this.onProgressTrackingPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 푸시업 튜토리얼 버튼
        _buildTutorialButton(context, theme),

        const SizedBox(height: AppConstants.paddingM),

        // 푸시업 폼 가이드 버튼
        _buildFormGuideButton(context, theme),

        const SizedBox(height: AppConstants.paddingM),

        // 진행률 추적 버튼
        _buildProgressTrackingButton(context, theme),
      ],
    );
  }

  Widget _buildTutorialButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTutorialPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4DABF7),
          padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, color: Colors.white, size: 24),
            const SizedBox(width: AppConstants.paddingS),
            Text(
              AppLocalizations.of(context).tutorialButton,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormGuideButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onFormGuidePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppColors.secondaryColor),
          padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, color: Colors.white, size: 24),
            const SizedBox(width: AppConstants.paddingS),
            Text(
              AppLocalizations.of(context).perfectPushupForm,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTrackingButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onProgressTrackingPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppColors.primaryColor),
          padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics, color: Colors.black, size: 24),
            const SizedBox(width: AppConstants.paddingS),
            Text(
              AppLocalizations.of(context).progressTracking,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
