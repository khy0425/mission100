import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../generated/app_localizations.dart';
import '../../../utils/constants.dart';

/// 운동 횟수 카운터를 표시하는 위젯
///
/// 기능:
/// - 목표 횟수 및 현재 횟수 표시
/// - 성과 메시지 표시
/// - 빠른 입력 버튼들 (60%, 80%, 100%, 절반, 초과)
/// - 수동 조정 버튼 (+1, -1)
class RepCounterWidget extends StatelessWidget {
  final int currentReps;
  final int targetReps;
  final bool isSetCompleted;
  final ValueChanged<int> onRepsChanged;
  final VoidCallback onSetCompleted;
  final VoidCallback? onAchievementCheck;

  const RepCounterWidget({
    super.key,
    required this.currentReps,
    required this.targetReps,
    required this.isSetCompleted,
    required this.onRepsChanged,
    required this.onSetCompleted,
    this.onAchievementCheck,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenHeight < 700;

    // 더 컴팩트한 패딩과 여백
    final padding = AppConstants.paddingM;
    final spacing = AppConstants.paddingS;
    final fontSize = isSmallScreen ? 40.0 : 48.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: _getPerformanceColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(
          color: isSetCompleted
              ? Color(AppColors.successColor)
              : Color(AppColors.primaryColor),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 목표 횟수와 현재 횟수를 한 줄에 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 목표 횟수
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.target,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Color(AppColors.primaryColor),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$targetReps',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Color(AppColors.primaryColor),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // 구분선
              Container(
                height: 40,
                width: 2,
                color: Colors.grey[300],
              ),

              // 현재 횟수
              Column(
                children: [
                  Text(
                    isSetCompleted ? AppLocalizations.of(context)!.completed : AppLocalizations.of(context)!.current,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getPerformanceColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$currentReps',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: _getPerformanceColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (!isSetCompleted) ...[
            SizedBox(height: spacing),

            // 성과 메시지
            Text(
              _getPerformanceMessage(context),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _getPerformanceColor(),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: spacing),

            // 빠른 입력 버튼들 (2줄로 배치)
            Column(
              children: [
                // 첫 번째 줄: 주요 버튼들
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildQuickInputButton(
                        context,
                        (targetReps * 0.6).round(),
                        '60%',
                        Colors.orange[700]!,
                        true,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: _buildQuickInputButton(
                        context,
                        (targetReps * 0.8).round(),
                        '80%',
                        Colors.orange,
                        true,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: _buildQuickInputButton(
                        context,
                        targetReps,
                        '100%',
                        Color(AppColors.successColor),
                        true,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: spacing / 2),

                // 두 번째 줄: 추가 옵션
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildQuickInputButton(
                        context,
                        targetReps ~/ 2,
                        AppLocalizations.of(context)!.half,
                        Colors.grey[600]!,
                        true,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: _buildQuickInputButton(
                        context,
                        targetReps + 2,
                        AppLocalizations.of(context)!.exceed,
                        Color(AppColors.primaryColor),
                        true,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: spacing / 2),

            // 수동 조정 버튼들 (반응형)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // -1 버튼
                ElevatedButton(
                  onPressed: currentReps > 0
                      ? () {
                          onRepsChanged(currentReps - 1);
                          HapticFeedback.lightImpact();

                          // 횟수 변경 후 자동으로 세트 완료 처리
                          if (currentReps - 1 > 0) {
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (!isSetCompleted) {
                                onSetCompleted();
                              }
                            });
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(
                      isSmallScreen
                          ? AppConstants.paddingS
                          : AppConstants.paddingM,
                    ),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: isSmallScreen ? 16 : 20,
                  ),
                ),

                SizedBox(width: spacing),

                // +1 버튼
                ElevatedButton(
                  onPressed: () {
                    onRepsChanged(currentReps + 1);
                    HapticFeedback.lightImpact();
                    onAchievementCheck?.call();

                    // 횟수 변경 후 자동으로 세트 완료 처리
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (!isSetCompleted) {
                        onSetCompleted();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(AppColors.primaryColor),
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(
                      isSmallScreen
                          ? AppConstants.paddingS
                          : AppConstants.paddingM,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: isSmallScreen ? 16 : 20,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickInputButton(
    BuildContext context,
    int value,
    String label,
    Color color,
    bool isSmallScreen,
  ) {
    final theme = Theme.of(context);
    final padding = isSmallScreen
        ? EdgeInsets.symmetric(
            horizontal: AppConstants.paddingS,
            vertical: AppConstants.paddingS / 2,
          )
        : EdgeInsets.symmetric(
            horizontal: AppConstants.paddingM,
            vertical: AppConstants.paddingS,
          );

    return GestureDetector(
      onTap: () {
        onRepsChanged(value);
        HapticFeedback.lightImpact();
        onAchievementCheck?.call();

        // 횟수를 설정한 후 자동으로 세트 완료 처리
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!isSetCompleted) {
            onSetCompleted();
          }
        });
      },
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$value',
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 14.0 : 16.0,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: isSmallScreen ? 10.0 : 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPerformanceColor() {
    if (currentReps >= targetReps) {
      return Color(AppColors.successColor); // 목표 달성
    } else if (currentReps >= targetReps * 0.8) {
      return Color(AppColors.primaryColor); // 80% 이상
    } else if (currentReps >= targetReps * 0.5) {
      return Colors.orange; // 50% 이상
    } else {
      return Colors.grey[600]!; // 50% 미만
    }
  }

  String _getPerformanceMessage(BuildContext context) {
    if (currentReps >= targetReps) {
      return AppLocalizations.of(context)!.excellentPerformance;
    } else if (currentReps >= targetReps * 0.8) {
      return AppLocalizations.of(context)!.goodPerformance;
    } else if (currentReps >= targetReps * 0.5) {
      return AppLocalizations.of(context)!.keepGoing;
    } else {
      return AppLocalizations.of(context)!.motivationGeneral;
    }
  }
}