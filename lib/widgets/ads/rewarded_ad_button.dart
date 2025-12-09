import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/rewarded_ad_reward.dart';
import '../../models/user_subscription.dart';
import '../../services/payment/rewarded_ad_reward_service.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/config/constants.dart';

/// 리워드 광고 버튼 위젯
class RewardedAdButton extends StatefulWidget {
  final RewardedAdType rewardType;
  final Function() onRewardGranted;
  final String? customButtonText;
  final IconData? customIcon;
  final Color? buttonColor;

  const RewardedAdButton({
    super.key,
    required this.rewardType,
    required this.onRewardGranted,
    this.customButtonText,
    this.customIcon,
    this.buttonColor,
  });

  @override
  State<RewardedAdButton> createState() => _RewardedAdButtonState();
}

class _RewardedAdButtonState extends State<RewardedAdButton> {
  bool _isLoading = false;

  RewardedAdReward get _reward {
    switch (widget.rewardType) {
      case RewardedAdType.dreamAnalysis:
        return RewardedAdReward.dreamAnalysis;
      case RewardedAdType.wbtbSkip:
        return RewardedAdReward.wbtbSkip;
      case RewardedAdType.evolutionBoost:
        return RewardedAdReward.evolutionBoost;
      case RewardedAdType.premiumPreview:
        return RewardedAdReward.premiumPreview;
      case RewardedAdType.specialSkin:
        return RewardedAdReward.specialSkin;
    }
  }

  Future<void> _watchAd() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final service = context.read<RewardedAdRewardService>();
    final authService = context.read<AuthService>();
    final subscription = authService.currentSubscription;
    final isPremium = subscription?.type == SubscriptionType.premium ||
        subscription?.type == SubscriptionType.launchPromo;

    // 프리미엄 사용자: 광고 없이 즉시 보상
    if (isPremium) {
      // 바로 보상 지급 (강제 지급)
      await service.forceGrantReward(widget.rewardType);

      setState(() {
        _isLoading = false;
      });

      // 보상 지급 완료 메시지
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.workspace_premium, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${l10n.rewardedAdRewardGranted(_reward.icon, _reward.title)} (프리미엄)',
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF7B2CBF),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // 콜백 실행
      widget.onRewardGranted();
      return;
    }

    // 무료 사용자: 광고 시청 후 보상
    await service.watchAdAndReward(
      widget.rewardType,
      onRewardGranted: () {
        setState(() {
          _isLoading = false;
        });

        // 보상 지급 완료 메시지
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.rewardedAdRewardGranted(
                _reward.icon,
                _reward.title,
              )),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        // 콜백 실행
        widget.onRewardGranted();
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final service = context.watch<RewardedAdRewardService>();
    final authService = context.watch<AuthService>();
    final subscription = authService.currentSubscription;
    final isPremium = subscription?.type == SubscriptionType.premium ||
        subscription?.type == SubscriptionType.launchPromo;

    final canUse = service.canUseReward(widget.rewardType);

    // 버튼 텍스트와 아이콘 결정
    final buttonText = widget.customButtonText ??
        (isPremium
            ? '${_reward.title} 즉시 받기 ⭐'
            : l10n.rewardedAdWatchAndGet(_reward.title));

    final buttonIcon = isPremium
        ? Icons.workspace_premium
        : (widget.customIcon ?? Icons.play_circle_outline);

    final buttonColor = isPremium
        ? const Color(0xFF7B2CBF)
        : (widget.buttonColor ?? const Color(AppColors.primaryColor));

    return ElevatedButton.icon(
      onPressed: canUse && !_isLoading ? _watchAd : null,
      icon: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Icon(
              buttonIcon,
              color: Colors.white,
            ),
      label: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingL,
          vertical: AppConstants.paddingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        disabledBackgroundColor: Colors.grey[400],
      ),
    );
  }
}

/// 리워드 광고 카드 위젯 (상세 정보 포함)
class RewardedAdCard extends StatelessWidget {
  final RewardedAdType rewardType;
  final Function() onRewardGranted;

  const RewardedAdCard({
    super.key,
    required this.rewardType,
    required this.onRewardGranted,
  });

  RewardedAdReward get _reward {
    switch (rewardType) {
      case RewardedAdType.dreamAnalysis:
        return RewardedAdReward.dreamAnalysis;
      case RewardedAdType.wbtbSkip:
        return RewardedAdReward.wbtbSkip;
      case RewardedAdType.evolutionBoost:
        return RewardedAdReward.evolutionBoost;
      case RewardedAdType.premiumPreview:
        return RewardedAdReward.premiumPreview;
      case RewardedAdType.specialSkin:
        return RewardedAdReward.specialSkin;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final service = context.watch<RewardedAdRewardService>();

    final canUse = service.canUseReward(rewardType);
    final remaining = service.getRemainingUsage(rewardType);
    final nextAvailable = service.getNextAvailableTime(rewardType);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(AppColors.dreamGradient[0]),
                    Color(AppColors.dreamGradient[1]),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘 + 제목
            Row(
              children: [
                Text(
                  _reward.icon,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: AppConstants.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _reward.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _reward.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.paddingM),

            // 사용 정보
            if (_reward.maxUsage != -1) ...[
              Row(
                children: [
                  const Icon(Icons.confirmation_number, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    l10n.rewardedAdRemainingUses(remaining, _reward.maxUsage),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // 쿨다운 정보
            if (!canUse && nextAvailable != null) ...[
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    _getCooldownText(context, nextAvailable),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingM),
            ],

            // 버튼
            SizedBox(
              width: double.infinity,
              child: RewardedAdButton(
                rewardType: rewardType,
                onRewardGranted: onRewardGranted,
                customButtonText: l10n.rewardedAdWatchButton,
                customIcon: Icons.play_circle_fill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCooldownText(BuildContext context, DateTime nextAvailable) {
    final l10n = AppLocalizations.of(context);
    final remaining = nextAvailable.difference(DateTime.now());

    if (remaining.inHours > 0) {
      return l10n.rewardedAdAvailableInHours(
        remaining.inHours,
        remaining.inMinutes % 60,
      );
    } else if (remaining.inMinutes > 0) {
      return l10n.rewardedAdAvailableInMinutes(remaining.inMinutes);
    } else {
      return l10n.rewardedAdComingSoon;
    }
  }
}
