import 'package:flutter/material.dart';
import '../../../generated/app_localizations.dart';
import '../../../utils/constants.dart';

/// 운동 컨트롤 버튼들을 표시하는 위젯
///
/// 기능:
/// - 휴식 중: 휴식 건너뛰기 버튼
/// - 세트 완료: 다음 세트 또는 운동 완료 버튼
/// - 세트 진행 중: 세트 완료 버튼
class WorkoutControlsWidget extends StatelessWidget {
  final bool isRestTime;
  final bool isSetCompleted;
  final int currentSet;
  final int totalSets;
  final int currentReps;
  final VoidCallback onSkipRest;
  final VoidCallback onStartRest;
  final VoidCallback onCompleteWorkout;
  final VoidCallback onMarkSetCompleted;

  const WorkoutControlsWidget({
    super.key,
    required this.isRestTime,
    required this.isSetCompleted,
    required this.currentSet,
    required this.totalSets,
    required this.currentReps,
    required this.onSkipRest,
    required this.onStartRest,
    required this.onCompleteWorkout,
    required this.onMarkSetCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenHeight < 700;

    final padding = isSmallScreen
        ? AppConstants.paddingM
        : AppConstants.paddingL;
    final buttonHeight = isSmallScreen ? 50.0 : 60.0;
    final fontSize = isSmallScreen ? 16.0 : 18.0;
    final iconSize = isSmallScreen ? 20.0 : 24.0;

    if (isRestTime) {
      return Column(
        children: [
          // 휴식 상태 메시지
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Color(AppColors.secondaryColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Text(
              AppLocalizations.of(context).restMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Color(AppColors.secondaryColor),
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 14.0 : 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: padding),

          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: onSkipRest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(AppColors.secondaryColor),
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
                    size: iconSize,
                  ),
                  SizedBox(width: padding / 2),
                  Text(
                    AppLocalizations.of(context).skipRest,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (isSetCompleted) {
      return SizedBox(
        width: double.infinity,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: currentSet < totalSets - 1
              ? onStartRest
              : onCompleteWorkout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(AppColors.successColor),
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
                currentSet == totalSets - 1
                    ? Icons.celebration
                    : Icons.arrow_forward,
                color: Colors.white,
                size: iconSize,
              ),
              SizedBox(width: padding / 2),
              Text(
                currentSet == totalSets - 1
                    ? AppLocalizations.of(context).completeSetButton
                    : AppLocalizations.of(context).completeSetContinue,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 세트 진행 중 - 자동 완료 안내 메시지만 표시
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Color(AppColors.primaryColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: Color(AppColors.primaryColor).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.touch_app,
                color: Color(AppColors.primaryColor),
                size: iconSize,
              ),
              SizedBox(width: padding / 2),
              Text(
                '🔥 CHAD 자동 모드 🔥',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Color(AppColors.primaryColor),
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
          SizedBox(height: padding / 2),
          Text(
            currentReps > 0
                ? '💪 횟수 입력 완료! 자동으로 휴식 타이머 시작! FXXK YEAH! 💪'
                : '💀 횟수를 입력하면 자동으로 세트 완료! BEAST MODE! 💀',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Color(AppColors.primaryColor),
              fontWeight: FontWeight.w600,
              fontSize: isSmallScreen ? 12.0 : 14.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}