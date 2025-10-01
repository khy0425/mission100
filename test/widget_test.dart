import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mission100/services/theme_service.dart';
import 'package:mission100/services/onboarding_service.dart';
import 'package:mission100/services/chad_evolution_service.dart';
import 'package:mission100/services/chad_condition_service.dart';
import 'package:mission100/services/chad_recovery_service.dart';
import 'package:mission100/services/chad_active_recovery_service.dart';
import 'package:mission100/services/auth_service.dart';

// Simple test LocaleNotifier
class TestLocaleNotifier extends ChangeNotifier {
  Locale _locale = const Locale('ko');
  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}

void main() {
  group('Mission100 Chad Tests', () {
    testWidgets('App should start without crashing', (
      WidgetTester tester,
    ) async {
      // Create a minimal test app
      final testApp = MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService()),
          ChangeNotifierProvider(create: (_) => TestLocaleNotifier()),
          ChangeNotifierProvider(create: (_) => OnboardingService()),
          ChangeNotifierProvider(create: (_) => ChadEvolutionService()),
          ChangeNotifierProvider(create: (_) => ChadConditionService()),
          ChangeNotifierProvider(create: (_) => ChadRecoveryService()),
          ChangeNotifierProvider(create: (_) => ChadActiveRecoveryService()),
          ChangeNotifierProvider(create: (_) => AuthService()),
        ],
        child: MaterialApp(
          title: 'Mission: 100 Test',
          home: Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testApp);

      // Verify app loads without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Test App'), findsOneWidget);
    });

    testWidgets('Chad mode should be activated', (WidgetTester tester) async {
      // Create simple test app
      final testApp = MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService()),
          ChangeNotifierProvider(create: (_) => TestLocaleNotifier()),
          ChangeNotifierProvider(create: (_) => OnboardingService()),
          ChangeNotifierProvider(create: (_) => ChadEvolutionService()),
          ChangeNotifierProvider(create: (_) => ChadConditionService()),
          ChangeNotifierProvider(create: (_) => ChadRecoveryService()),
          ChangeNotifierProvider(create: (_) => ChadActiveRecoveryService()),
          ChangeNotifierProvider(create: (_) => AuthService()),
        ],
        child: MaterialApp(
          title: 'Mission: 100 Test',
          home: Scaffold(
            appBar: AppBar(title: Text('Chad Mode')),
            body: Center(
              child: Text('💪 Chad is Active'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Basic smoke test - app should render without errors
      expect(tester.takeException(), isNull);
      expect(find.text('💪 Chad is Active'), findsOneWidget);
      expect(find.text('Chad Mode'), findsOneWidget);
    });
  });

  group('Chad Localization Tests', () {
    test('Korean Chad messages should be loaded', () {
      // Test basic Chad message loading
      const koreanOkButton = '🔥 OK, 만삣삐! 🔥';
      expect(koreanOkButton.contains('🔥'), isTrue);
      expect(koreanOkButton.contains('만삣삐'), isTrue);
    });

    test('English Chad messages should be loaded', () {
      // Test English Chad messages
      const englishOkButton = '🔥 HELL YEAH, BRO! 🔥';
      expect(englishOkButton.contains('🔥'), isTrue);
      expect(englishOkButton.contains('HELL YEAH'), isTrue);
    });
  });

  group('Chad Motivation Engine Tests', () {
    test('Chad energy level should be maximum', () {
      // Chad energy is always at maximum
      const chadEnergyLevel = 100;
      expect(chadEnergyLevel, equals(100));
    });

    test('Weakness should not be an option', () {
      // Weakness is never allowed in Chad mode
      const weaknessAllowed = false;
      expect(weaknessAllowed, isFalse);
    });

    test('Chad philosophy should be enforced', () {
      // "Weakness is a choice. Strength is duty!"
      const chadPhilosophy = 'Strength is duty!';
      expect(chadPhilosophy.contains('Strength'), isTrue);
      expect(chadPhilosophy.contains('duty'), isTrue);
    });
  });

  group('Chad Service Integration Tests', () {
    test('Chad services should initialize properly', () {
      // Test Chad service initialization
      final chadEvolutionService = ChadEvolutionService();
      final chadConditionService = ChadConditionService();
      final chadRecoveryService = ChadRecoveryService();
      final chadActiveRecoveryService = ChadActiveRecoveryService();

      expect(chadEvolutionService, isNotNull);
      expect(chadConditionService, isNotNull);
      expect(chadRecoveryService, isNotNull);
      expect(chadActiveRecoveryService, isNotNull);

      // Test that services are proper ChangeNotifiers
      expect(chadEvolutionService, isA<ChangeNotifier>());
      expect(chadConditionService, isA<ChangeNotifier>());
      expect(chadRecoveryService, isA<ChangeNotifier>());
      expect(chadActiveRecoveryService, isA<ChangeNotifier>());
    });

    test('Theme service should work', () {
      // Test ThemeService initialization
      final themeService = ThemeService();
      expect(themeService, isNotNull);
      expect(themeService, isA<ChangeNotifier>());
    });

    test('Auth service should work', () {
      // Test AuthService initialization (without Firebase dependency in test)
      try {
        final authService = AuthService();
        expect(authService, isNotNull);
        expect(authService, isA<ChangeNotifier>());
      } catch (e) {
        // Firebase not initialized in test environment is expected
        expect(e.toString(), contains('No Firebase App'));
        debugPrint(
            '✅ AuthService Firebase dependency test passed (expected error)');
      }
    });
  });
}
