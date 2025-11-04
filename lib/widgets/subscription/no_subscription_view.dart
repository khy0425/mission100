import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// 구독이 없을 때 표시되는 뷰
class NoSubscriptionView extends StatelessWidget {
  const NoSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.card_membership,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).noActiveSubscription,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).subscribeForPremium,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // 구독 화면으로 이동
              Navigator.pushNamed(context, '/subscription');
            },
            child: Text(AppLocalizations.of(context).startSubscriptionButton),
          ),
        ],
      ),
    );
  }
}
