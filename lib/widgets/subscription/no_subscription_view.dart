import 'package:flutter/material.dart';

/// 구독이 없을 때 표시되는 뷰
class NoSubscriptionView extends StatelessWidget {
  const NoSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.card_membership,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            '활성 구독이 없습니다',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            '프리미엄 기능을 이용하려면 구독을 시작하세요',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // 구독 화면으로 이동
              Navigator.pushNamed(context, '/subscription');
            },
            child: const Text('구독 시작하기'),
          ),
        ],
      ),
    );
  }
}
