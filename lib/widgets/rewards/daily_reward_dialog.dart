import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/ai/conversation_token_service.dart';

/// 일일 보상 다이얼로그
///
/// 매일 한 번 토큰 보상을 받을 수 있는 다이얼로그
/// - 일반 사용자: 1 토큰
/// - 프리미엄 사용자: 5 토큰
class DailyRewardDialog extends StatelessWidget {
  final bool isPremium;
  final int rewardAmount;

  const DailyRewardDialog({
    super.key,
    required this.isPremium,
    required this.rewardAmount,
  });

  /// 일일 보상 체크 및 다이얼로그 표시
  ///
  /// [context] - BuildContext
  /// [tokenService] - ConversationTokenService
  /// [isPremium] - 프리미엄 사용자 여부
  ///
  /// Returns: Future<void>
  static Future<void> checkAndShow(
    BuildContext context,
    ConversationTokenService tokenService,
    bool isPremium,
  ) async {
    // 이미 오늘 보상을 받았는지 확인
    if (!tokenService.canClaimDailyReward) {
      debugPrint('🎁 오늘 이미 보상을 받았습니다');
      return;
    }

    final rewardAmount = isPremium ? 5 : 1;

    // 일일 보상 다이얼로그 표시
    final shouldClaim = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => DailyRewardDialog(
        isPremium: isPremium,
        rewardAmount: rewardAmount,
      ),
    );

    // 사용자가 보상 받기를 선택한 경우
    if (shouldClaim == true && context.mounted) {
      await tokenService.claimDailyReward(isPremium: isPremium);

      if (context.mounted) {
        _showSuccessSnackBar(context, rewardAmount);
      }
    }
  }

  /// 보상 수령 성공 스낵바 표시
  static void _showSuccessSnackBar(BuildContext context, int rewardAmount) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('🎉', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.homeDailyRewardReceived(rewardAmount),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Text('🎁', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.homeDailyRewardTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeDailyRewardMessage,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          _buildRewardAmountCard(context, theme),
          if (isPremium) ...[
            const SizedBox(height: 12),
            _buildPremiumBonusBadge(context, l10n),
          ],
          const SizedBox(height: 12),
          Text(
            l10n.homeChatWithLumiMessage(rewardAmount),
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.homeLaterButton),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
          child: Text(
            l10n.homeClaimButton,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// 보상 금액 카드
  Widget _buildRewardAmountCard(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withValues(alpha: 0.1),
            theme.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎫', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Text(
            l10n.tokenBalanceRewardAmount(rewardAmount),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 프리미엄 보너스 배지
  Widget _buildPremiumBonusBadge(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Text('⭐', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.homePremiumBonusApplied,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.amber[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
