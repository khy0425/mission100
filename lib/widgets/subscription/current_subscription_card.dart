import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/user_subscription.dart';
import 'subscription_detail_row.dart';

/// 현재 구독 정보를 표시하는 카드
class CurrentSubscriptionCard extends StatelessWidget {
  final UserSubscription subscription;

  const CurrentSubscriptionCard({
    super.key,
    required this.subscription,
  });

  String _getTypeName(SubscriptionType type, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case SubscriptionType.free:
        return l10n.freePlan;
      case SubscriptionType.launchPromo:
        return l10n.launchPromotion;
      case SubscriptionType.premium:
        return l10n.premiumMonthly;
    }
  }

  String _getStatusText(SubscriptionStatus status, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (status) {
      case SubscriptionStatus.active:
        return l10n.statusActive;
      case SubscriptionStatus.expired:
        return l10n.statusExpired;
      case SubscriptionStatus.cancelled:
        return l10n.statusCancelled;
      case SubscriptionStatus.trial:
        return l10n.statusTrial;
    }
  }

  String _formatDate(DateTime? date, BuildContext context) {
    if (date == null) return AppLocalizations.of(context).unlimited;
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.currentSubscription,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SubscriptionDetailRow(
              label: l10n.planLabel,
              value: _getTypeName(subscription.type, context),
            ),
            SubscriptionDetailRow(
              label: l10n.statusLabel,
              value: _getStatusText(subscription.status, context),
            ),
            SubscriptionDetailRow(
              label: l10n.startDate,
              value: _formatDate(subscription.startDate, context),
            ),
            SubscriptionDetailRow(
              label: l10n.expiryDate,
              value: _formatDate(subscription.endDate, context),
            ),
            if (subscription.type == SubscriptionType.premium) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  l10n.autoRenewalEnabled,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
