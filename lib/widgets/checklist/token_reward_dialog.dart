import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';

/// 토큰 획득 축하 다이얼로그
///
/// 체크리스트 완료 시 토큰 보상을 표시하는 다이얼로그
class TokenRewardDialog extends StatelessWidget {
  final int baseTokens;
  final int bonusTokens;
  final int totalTokens;
  final int currentStreak;
  final bool isPremium;

  const TokenRewardDialog({
    super.key,
    required this.baseTokens,
    required this.bonusTokens,
    required this.totalTokens,
    required this.currentStreak,
    required this.isPremium,
  });

  /// 정적 메서드: 다이얼로그 표시
  static Future<void> show({
    required BuildContext context,
    required int baseTokens,
    required int bonusTokens,
    required int totalTokens,
    required int currentStreak,
    required bool isPremium,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TokenRewardDialog(
        baseTokens: baseTokens,
        bonusTokens: bonusTokens,
        totalTokens: totalTokens,
        currentStreak: currentStreak,
        isPremium: isPremium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingXL),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(AppColors.lucidGradient[0]),
              Color(AppColors.lucidGradient[1]),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🎫', style: TextStyle(fontSize: 48)),
              ),
            ),

            const SizedBox(height: AppConstants.paddingL),

            // 제목
            Text(
              l10n.tokenRewardTitle,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: AppConstants.paddingM),

            // 토큰 정보
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: Column(
                children: [
                  // 기본 토큰
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPremium ? l10n.tokenDailyRewardPremium : l10n.tokenDailyRewardFree,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '+$baseTokens',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // 보너스 토큰 (있을 경우)
                  if (bonusTokens > 0) ...[
                    const SizedBox(height: AppConstants.paddingS),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.tokenStreakBonus(currentStreak),
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '+$bonusTokens',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const Divider(color: Colors.white54, height: 24),

                  // 총 획득
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.tokenTotalReward,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '+$totalTokens 🎫',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingM),

            // 연속 출석 정보
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '🔥',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.tokenStreakStatus(currentStreak),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            if (currentStreak < 3) ...[
              const SizedBox(height: AppConstants.paddingS),
              Text(
                l10n.tokenStreakGoal3Days(3 - currentStreak),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ] else if (currentStreak < 7) ...[
              const SizedBox(height: AppConstants.paddingS),
              Text(
                l10n.tokenStreakGoal7Days(7 - currentStreak),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: AppConstants.paddingL),

            // 확인 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(AppColors.primaryColor),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.paddingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                ),
                child: Text(
                  l10n.tokenRewardConfirm,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
