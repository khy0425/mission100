import 'package:flutter/material.dart';

/// 구독 관리 액션 카드
class SubscriptionActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const SubscriptionActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDestructive
              ? Colors.red.withValues(alpha: 0.1)
              : Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Theme.of(context).primaryColor,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
