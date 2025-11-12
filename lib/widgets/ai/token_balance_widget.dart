import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/user_subscription.dart';
import '../../services/ai/conversation_token_service.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/config/constants.dart';

/// 토큰 잔액 및 일일 보상 위젯
class TokenBalanceWidget extends StatefulWidget {
  final bool showDailyReward;
  final bool showAdButton;

  const TokenBalanceWidget({
    super.key,
    this.showDailyReward = true,
    this.showAdButton = true,
  });

  @override
  State<TokenBalanceWidget> createState() => _TokenBalanceWidgetState();
}

class _TokenBalanceWidgetState extends State<TokenBalanceWidget> {
  bool _isClaimingReward = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Consumer<ConversationTokenService>(
      builder: (context, tokenService, _) {
        final balance = tokenService.balance;
        final canClaimDaily = tokenService.canClaimDailyReward;
        final timeUntilNextReward = tokenService.timeUntilNextReward;

        return Card(
          margin: const EdgeInsets.all(AppConstants.paddingM),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 토큰 잔액 헤더
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.tokenBalanceTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.primaryColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🎫', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            '$balance',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.paddingM),

                // 토큰 사용 안내
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey[800]?.withValues(alpha: 0.5)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.tokenBalanceUsageInfo,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (widget.showDailyReward) ...[
                  const SizedBox(height: AppConstants.paddingL),
                  const Divider(),
                  const SizedBox(height: AppConstants.paddingM),

                  // 일일 보상 섹션
                  _buildDailyRewardSection(
                    context,
                    theme,
                    isDark,
                    canClaimDaily,
                    timeUntilNextReward,
                  ),
                ],

                if (widget.showAdButton) ...[
                  const SizedBox(height: AppConstants.paddingM),

                  // 광고 시청 버튼
                  _buildAdButton(theme),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// 일일 보상 섹션
  Widget _buildDailyRewardSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    bool canClaimDaily,
    Duration timeUntilNextReward,
  ) {
    final authService = context.read<AuthService>();
    final isPremium = authService.currentSubscription?.type == SubscriptionType.premium;
    final rewardAmount = isPremium ? 5 : 1;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('🎁', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).tokenBalanceDailyReward,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingS),

        // 보상 금액 표시
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryColor.withValues(alpha: 0.1),
                theme.primaryColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.primaryColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎫', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                l10n.tokenBalanceRewardAmount(rewardAmount),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              if (isPremium) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLocalizations.of(context).tokenBalancePremium,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: AppConstants.paddingM),

        // 보상 받기 버튼 또는 카운트다운
        if (canClaimDaily)
          ElevatedButton(
            onPressed: _isClaimingReward ? null : _claimDailyReward,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isClaimingReward
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.card_giftcard),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context).tokenBalanceClaimReward(rewardAmount),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 20,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context).tokenBalanceNextReward,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDuration(timeUntilNextReward),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// 광고 시청 버튼
  Widget _buildAdButton(ThemeData theme) {
    return OutlinedButton.icon(
      onPressed: _watchAd,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: theme.primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.play_circle_outline),
      label: Text(
        AppLocalizations.of(context).tokenBalanceWatchAd,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 일일 보상 받기
  Future<void> _claimDailyReward() async {
    if (_isClaimingReward) return;

    setState(() => _isClaimingReward = true);

    try {
      final authService = context.read<AuthService>();
      final isPremium = authService.currentSubscription?.type == SubscriptionType.premium;
      final tokenService = context.read<ConversationTokenService>();
      await tokenService.claimDailyReward(isPremium: isPremium);

      if (!mounted) return;

      // 성공 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('🎉', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).tokenBalanceRewardReceived,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).tokenBalanceRewardFailed(e.toString()),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isClaimingReward = false);
      }
    }
  }

  /// 광고 시청
  Future<void> _watchAd() async {
    // TODO: 광고 SDK 연동 후 구현
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).tokenBalanceAdComingSoon),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 시간 포맷팅 (HH:MM:SS)
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
