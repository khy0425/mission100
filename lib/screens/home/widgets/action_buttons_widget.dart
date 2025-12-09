import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../utils/config/constants.dart';

/// 홈 화면의 주요 액션 버튼들을 표시하는 위젯
///
/// 기능:
/// - 설정 버튼
/// - 진행률 추적 버튼
/// - 각 버튼별 고유한 색상과 아이콘
///
/// MVP: 튜토리얼 버튼 제거 (자각몽 앱에는 필요없음)
class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onProgressTrackingPressed;

  const ActionButtonsWidget({
    super.key,
    this.onSettingsPressed,
    this.onProgressTrackingPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        // 설정 버튼
        _buildSettingsButton(context, theme),
        const SizedBox(height: AppConstants.paddingM),

        // 진행률 추적 버튼
        _buildProgressTrackingButton(context, theme),
      ],
    );
  }

  // 설정 버튼
  Widget _buildSettingsButton(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onSettingsPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF607D8B), // Blue Grey - 설정 색상
          padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings, color: Colors.white, size: 24),
            const SizedBox(width: AppConstants.paddingS),
            Text(
              l10n.settings,
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

  // MVP: 튜토리얼 버튼들 제거
  // Widget _buildTutorialButton(BuildContext context, ThemeData theme) { ... }
  // Widget _buildFormGuideButton(BuildContext context, ThemeData theme) { ... }

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
