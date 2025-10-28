import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.account_circle, color: const Color(0xFF00BCD4)),
          SizedBox(width: 8),
          Text('계정 정보'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user != null) ...[
            if (user!.displayName != null)
              InfoRow(
                label: '이름',
                value: user!.displayName!,
              ),
            if (user!.email != null)
              InfoRow(
                label: '이메일',
                value: user!.email!,
              ),
            InfoRow(
              label: '계정 유형',
              value: subscription?.type == SubscriptionType.premium
                  ? '프리미엄 계정'
                  : '무료 계정',
            ),
            InfoRow(
              label: '로그인 방법',
              value: user!.providerData.isNotEmpty
                  ? user!.providerData.first.providerId.contains('google')
                      ? 'Google'
                      : '이메일'
                  : '이메일',
            ),
          ] else ...[
            const Text('게스트 모드로 사용 중입니다. 로그인하여 진행 상황을 저장하세요.'),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}
