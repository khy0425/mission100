import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/auth/auth_service.dart';
import '../../models/user_subscription.dart';
import '../../widgets/common/vip_badge_widget.dart';
import '../../screens/settings/subscription_screen.dart';
import 'elegant_settings_tile.dart';

/// 구독 관리 섹션 위젯
///
/// 현재 구독 상태 (무료/프리미엄/프로모션) 표시 및 VIP 배지
class SubscriptionSection extends StatelessWidget {
  const SubscriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final subscription = authService.currentSubscription;
        final isPremium = subscription?.type == SubscriptionType.premium;
        final isLaunchPromo = subscription?.type == SubscriptionType.launchPromo;

        String statusText;
        Color statusColor;
        if (isPremium) {
          statusText = l10n.premiumActive;
          statusColor = Colors.green;
        } else if (isLaunchPromo) {
          statusText = l10n.launchPromoActive;
          statusColor = Colors.purple;
        } else {
          statusText = l10n.freeUsing;
          statusColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ElegantSettingsTile(
            icon: Icons.workspace_premium,
            iconColor: isPremium ? Colors.amber : Colors.purple,
            title: l10n.currentSubscription,
            subtitle: statusText,
            showDivider: false,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (subscription != null)
                  VIPBadgeWidget(
                    subscription: subscription,
                    size: VIPBadgeSize.small,
                    showLabel: false,
                  ),
                const SizedBox(width: 8),
                if (isPremium)
                  const Icon(Icons.verified, color: Colors.green, size: 20)
                else
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const SubscriptionScreen(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
