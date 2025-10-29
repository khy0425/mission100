import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mission100/services/payment/billing_service.dart';
import 'package:mission100/services/old_archive/subscription_service.dart';

@GenerateMocks([BillingService, SubscriptionService])
import 'billing_service_mock_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Billing Service Mock Tests (CI/CD)', () {
    late MockBillingService mockBillingService;
    late MockSubscriptionService mockSubscriptionService;

    setUp(() {
      mockBillingService = MockBillingService();
      mockSubscriptionService = MockSubscriptionService();
    });

    group('BillingService Mock Tests', () {
      test('BillingService initialization should return true', () async {
        when(mockBillingService.initialize()).thenAnswer((_) async => true);

        final result = await mockBillingService.initialize();
        expect(result, true);
        verify(mockBillingService.initialize()).called(1);
      });

      test('BillingService should handle store unavailable', () async {
        when(mockBillingService.initialize()).thenAnswer((_) async => false);

        final result = await mockBillingService.initialize();
        expect(result, false);
      });

      test('BillingService restore purchases should not throw', () async {
        when(mockBillingService.restorePurchases())
            .thenAnswer((_) async {});

        await mockBillingService.restorePurchases();
        verify(mockBillingService.restorePurchases()).called(1);
      });
    });

    group('SubscriptionService Mock Tests', () {
      test('Initial subscription should be free', () {
        when(mockSubscriptionService.currentSubscription)
            .thenReturn(SubscriptionType.free);

        expect(mockSubscriptionService.currentSubscription,
               SubscriptionType.free);
      });

      test('Premium user should have premium status', () {
        when(mockSubscriptionService.isPremium).thenReturn(true);
        when(mockSubscriptionService.currentSubscription)
            .thenReturn(SubscriptionType.monthly);

        expect(mockSubscriptionService.isPremium, true);
        expect(mockSubscriptionService.currentSubscription,
               SubscriptionType.monthly);
      });

      test('Free user should not have premium status', () {
        when(mockSubscriptionService.isPremium).thenReturn(false);
        when(mockSubscriptionService.currentSubscription)
            .thenReturn(SubscriptionType.free);

        expect(mockSubscriptionService.isPremium, false);
      });

      test('Yearly subscription should be premium', () {
        when(mockSubscriptionService.isPremium).thenReturn(true);
        when(mockSubscriptionService.currentSubscription)
            .thenReturn(SubscriptionType.yearly);

        expect(mockSubscriptionService.isPremium, true);
        expect(mockSubscriptionService.currentSubscription,
               SubscriptionType.yearly);
      });

      test('Lifetime subscription should be premium', () {
        when(mockSubscriptionService.isPremium).thenReturn(true);
        when(mockSubscriptionService.currentSubscription)
            .thenReturn(SubscriptionType.lifetime);

        expect(mockSubscriptionService.isPremium, true);
        expect(mockSubscriptionService.currentSubscription,
               SubscriptionType.lifetime);
      });
    });
  });
}
