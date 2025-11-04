import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../utils/config/constants.dart';

/// 휴식 타이머를 표시하는 위젯
///
/// 기능:
/// - 남은 휴식 시간 표시 (분:초 형식)
/// - 원형 진행률 표시
/// - 휴식 건너뛰기 버튼
class RestTimerWidget extends StatelessWidget {
  final int restTimeRemaining;
  final int restTimeSeconds;
  final VoidCallback onSkipRest;

  const RestTimerWidget({
    super.key,
    required this.restTimeRemaining,
    required this.restTimeSeconds,
    required this.onSkipRest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenHeight < 700;

    final padding =
        isSmallScreen ? AppConstants.paddingL : AppConstants.paddingXL;
    final iconSize = isSmallScreen ? 40.0 : 48.0;
    final timerFontSize = isSmallScreen ? 48.0 : 60.0;
    final progressSize = isSmallScreen ? 100.0 : 120.0;

    final minutes = restTimeRemaining ~/ 60;
    final seconds = restTimeRemaining % 60;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(AppColors.secondaryColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        border:
            Border.all(color: const Color(AppColors.secondaryColor), width: 3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: const Color(AppColors.secondaryColor),
            size: iconSize,
          ),
          SizedBox(height: padding / 2),
          Text(
            AppLocalizations.of(context).restTimeTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: const Color(AppColors.secondaryColor),
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 16.0 : 20.0,
            ),
          ),
          SizedBox(height: padding),
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: theme.textTheme.displayLarge?.copyWith(
              color: const Color(AppColors.secondaryColor),
              fontWeight: FontWeight.bold,
              fontSize: timerFontSize,
            ),
          ),
          SizedBox(height: padding),
          SizedBox(
            width: progressSize,
            height: progressSize,
            child: CircularProgressIndicator(
              value: 1 - (restTimeRemaining / restTimeSeconds),
              strokeWidth: isSmallScreen ? 6 : 8,
              backgroundColor: Colors.grey.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(AppColors.secondaryColor),
              ),
            ),
          ),
          SizedBox(height: padding),

          // 휴식 건너뛰기 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSkipRest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(AppColors.secondaryColor),
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: padding / 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: isSmallScreen ? 20.0 : 24.0,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).skipRest,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 16.0 : 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
