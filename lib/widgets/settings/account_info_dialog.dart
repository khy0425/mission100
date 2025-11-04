import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/user_subscription.dart';
import 'info_row.dart';

/// 계정 정보 다이얼로그
class AccountInfoDialog extends StatelessWidget {
  final User? user;
  final UserSubscription? subscription;

  const AccountInfoDialog({
    super.key,
    required this.user,
    this.subscription,
  });

  static void show(
    BuildContext context, {
    required User? user,
    UserSubscription? subscription,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AccountInfoDialog(
        user: user,
        subscription: subscription,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.account_circle, color: Color(0xFF00BCD4)),
          const SizedBox(width: 8),
          Text(l10n.accountInfo),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user != null) ...[
            if (user!.displayName != null)
              InfoRow(
                label: l10n.name,
                value: user!.displayName!,
              ),
            if (user!.email != null)
              InfoRow(
                label: l10n.emailLabel,
                value: user!.email!,
              ),
            InfoRow(
              label: l10n.accountTypeLabel,
              value: subscription?.type == SubscriptionType.premium
                  ? l10n.premiumAccountType
                  : l10n.freeAccountType,
            ),
            InfoRow(
              label: l10n.loginMethodLabel,
              value: user!.providerData.isNotEmpty
                  ? user!.providerData.first.providerId.contains('google')
                      ? l10n.googleMethod
                      : l10n.emailMethod
                  : l10n.emailMethod,
            ),
          ] else ...[
            Text(l10n.guestModeMessage),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
