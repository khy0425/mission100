import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../utils/config/constants.dart';

/// 홈 화면의 주요 액션 버튼들을 표시하는 위젯
///
/// 기능:
/// - 진행률 추적 버튼
/// - 각 버튼별 고유한 색상과 아이콘
///
/// MVP: 튜토리얼 버튼 제거 (자각몽 앱에는 필요없음)
class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onProgressTrackingPressed;

  const ActionButtonsWidget({
    super.key,
    this.onProgressTrackingPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // MVP: 튜토리얼 버튼 제거 - 자각몽 앱에는 필요없음
        // 진행률 추적 버튼만 유지
        _buildProgressTrackingButton(context, theme),
      ],
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
