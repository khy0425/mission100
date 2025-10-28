import 'package:flutter/material.dart';
import '../../models/user_subscription.dart';
import 'subscription_detail_row.dart';

/// 현재 구독 정보를 표시하는 카드
class CurrentSubscriptionCard extends StatelessWidget {
  final UserSubscription subscription;

  const CurrentSubscriptionCard({
    super.key,
    required this.subscription,
  });

  String _getTypeName(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.free:
        return '무료 플랜';
      case SubscriptionType.launchPromo:
        return '런칭 프로모션';
      case SubscriptionType.premium:
        return '프리미엄 (₩4,900/월)';
    }
  }

  String _getStatusText(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return '활성';
      case SubscriptionStatus.expired:
        return '만료됨';
      case SubscriptionStatus.cancelled:
        return '취소됨';
      case SubscriptionStatus.trial:
        return '체험중';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '무제한';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
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
                  '현재 구독',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SubscriptionDetailRow(
              label: '플랜',
              value: _getTypeName(subscription.type),
            ),
            SubscriptionDetailRow(
              label: '상태',
              value: _getStatusText(subscription.status),
            ),
            SubscriptionDetailRow(
              label: '시작일',
              value: _formatDate(subscription.startDate),
            ),
            SubscriptionDetailRow(
              label: '만료일',
              value: _formatDate(subscription.endDate),
            ),
            if (subscription.type == SubscriptionType.premium) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '자동 갱신 활성화',
                  style: TextStyle(
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
