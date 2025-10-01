import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mission100/screens/subscription_screen.dart';
import 'package:mission100/widgets/premium_gate_widget.dart';
import 'package:mission100/services/subscription_service.dart';

void main() {
  group('Subscription UI Tests', () {
    testWidgets('SubscriptionScreen should build without errors', (WidgetTester tester) async {
      // SubscriptionScreen이 정상적으로 빌드되는지 테스트
      await tester.pumpWidget(
        MaterialApp(
          home: SubscriptionScreen(),
        ),
      );

      // 로딩 인디케이터가 표시되어야 함
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('구독 상품을 불러오는 중...'), findsOneWidget);
    }, skip: true); // Requires platform channel - test on real device

    testWidgets('PremiumGateWidget should show lock for non-premium users', (WidgetTester tester) async {
      // 프리미엄 게이트 위젯이 무료 사용자에게 잠금 상태를 표시하는지 테스트
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: PremiumGateWidget(
                requiredFeature: PremiumFeature.unlimitedWorkouts,
                featureName: '무제한 운동',
                description: '프리미엄 사용자만 이용 가능합니다',
                child: Container(
                  width: 300,
                  height: 200,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      // 프리미엄 아이콘이 표시되어야 함
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
      expect(find.text('무제한 운동'), findsOneWidget);
      expect(find.text('프리미엄 사용자만 이용 가능합니다'), findsOneWidget);
      expect(find.text('업그레이드'), findsOneWidget);
    });

    testWidgets('PremiumFeatureButton should show lock icon for non-premium', (WidgetTester tester) async {
      // 프리미엄 기능 버튼이 무료 사용자에게 잠금 아이콘을 표시하는지 테스트
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumFeatureButton(
              text: '고급 통계',
              requiredFeature: PremiumFeature.advancedStats,
              onPressed: () {},
              icon: Icons.analytics,
            ),
          ),
        ),
      );

      // 잠금 아이콘이 표시되어야 함
      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.text('고급 통계'), findsOneWidget);
    });

    testWidgets('PremiumLimitWidget should display correctly', (WidgetTester tester) async {
      // 프리미엄 제한 안내 위젯이 올바르게 표시되는지 테스트
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumLimitWidget(
              limitMessage: '무료 사용자는 하루 3회만 운동할 수 있습니다.',
              upgradeFeature: PremiumFeature.unlimitedWorkouts,
            ),
          ),
        ),
      );

      // 제한 메시지가 표시되어야 함
      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.text('무료 사용자는 하루 3회만 운동할 수 있습니다.'), findsOneWidget);
      expect(find.text('프리미엄으로 업그레이드'), findsOneWidget);
    });

    testWidgets('PremiumUpgradeDialog should display correctly', (WidgetTester tester) async {
      // 프리미엄 업그레이드 다이얼로그가 올바르게 표시되는지 테스트
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => PremiumUpgradeDialog(
                      featureName: '무제한 운동',
                      requiredFeature: PremiumFeature.unlimitedWorkouts,
                    ),
                  );
                },
                child: Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // 버튼을 눌러 다이얼로그 열기
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // 다이얼로그 내용이 표시되어야 함
      expect(find.text('프리미엄 기능'), findsOneWidget);
      expect(find.text('무제한 운동을 사용하려면 프리미엄 구독이 필요합니다.'), findsOneWidget);
      expect(find.text('나중에'), findsOneWidget);
      expect(find.text('구독하기'), findsOneWidget);
    });
  });
}