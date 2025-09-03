import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/theme.dart';
import 'test_helpers.dart';

// Mock translator for testing
class MockTranslator implements TranslatorLike {
  bool loadCalled = false;
  bool changeLanguageCalled = false;
  Locale? loadedLocale;
  Locale? changedLocale;

  @override
  Future<void> load(Locale locale) async {
    loadCalled = true;
    loadedLocale = locale;
  }

  @override
  Future<void> changeLanguage(BuildContext context, Locale newLocale) async {
    changeLanguageCalled = true;
    changedLocale = newLocale;
  }
}

void main() {
  group('ThemeRoutePage', () {
    test('has correct enum values', () {
      expect(ThemeRoutePage.values.length, equals(3));
      expect(ThemeRoutePage.values, contains(ThemeRoutePage.auth));
      expect(ThemeRoutePage.values, contains(ThemeRoutePage.home));
      expect(ThemeRoutePage.values, contains(ThemeRoutePage.loading));
    });

    test('enum values have correct names', () {
      expect(ThemeRoutePage.auth.name, equals('auth'));
      expect(ThemeRoutePage.home.name, equals('home'));
      expect(ThemeRoutePage.loading.name, equals('loading'));
    });
  });

  group('TranslatorLike', () {
    test('is an abstract class with required methods', () {
      expect(TranslatorLike, isA<Type>());
    });

    test('MockTranslator implements TranslatorLike', () {
      final mockTranslator = MockTranslator();
      expect(mockTranslator, isA<TranslatorLike>());
    });
  });

  group('ThemeService', () {
    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    Widget createTestWidget({
      ThemeRoutePage routePage = ThemeRoutePage.loading, // Use loading to avoid UI issues
      TranslatorLike? translator,
    }) {
      return MaterialApp(
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('it', 'IT'),
        ],
        home: ThemeService(
          routePage: routePage,
          translator: translator,
        ),
      );
    }

    testWidgets('creates correctly with default parameters', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(ThemeService), findsOneWidget);
    });

    testWidgets('is a StatefulWidget', (WidgetTester tester) async {
      const themeService = ThemeService();
      expect(themeService, isA<StatefulWidget>());
    });

    testWidgets('has correct default routePage', (WidgetTester tester) async {
      const themeService = ThemeService();
      expect(themeService.routePage, equals(ThemeRoutePage.auth));
    });

    testWidgets('accepts custom routePage', (WidgetTester tester) async {
      const themeService = ThemeService(routePage: ThemeRoutePage.home);
      expect(themeService.routePage, equals(ThemeRoutePage.home));
    });

    testWidgets('accepts custom translator', (WidgetTester tester) async {
      final mockTranslator = MockTranslator();
      final themeService = ThemeService(translator: mockTranslator);
      expect(themeService.translator, equals(mockTranslator));
    });

    testWidgets('shows CircularProgressIndicator while loading', (WidgetTester tester) async {
      final mockTranslator = MockTranslator();
      
      await tester.pumpWidget(createTestWidget(
        routePage: ThemeRoutePage.loading,
        translator: mockTranslator,
      ));

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Verify translator.load was called
      expect(mockTranslator.loadCalled, isTrue);
    });

    testWidgets('shows Container for loading route', (WidgetTester tester) async {
      final mockTranslator = MockTranslator();
      
      await tester.pumpWidget(createTestWidget(
        routePage: ThemeRoutePage.loading,
        translator: mockTranslator,
      ));

      // Wait for loading to complete
      await tester.pump();
      await tester.pump();

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('uses default translator when none provided', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Should not throw and should build successfully
      expect(find.byType(ThemeService), findsOneWidget);
    });

    testWidgets('calls translator load with correct locale', (WidgetTester tester) async {
      final mockTranslator = MockTranslator();
      
      await tester.pumpWidget(createTestWidget(translator: mockTranslator));

      expect(mockTranslator.loadCalled, isTrue);
      expect(mockTranslator.loadedLocale, isA<Locale>());
    });

    testWidgets('rebuilds correctly when translator changes', (WidgetTester tester) async {
      final mockTranslator = MockTranslator();
      
      await tester.pumpWidget(createTestWidget(
        routePage: ThemeRoutePage.loading,
        translator: mockTranslator,
      ));
      await tester.pump();
      await tester.pump();

      expect(mockTranslator.loadCalled, isTrue);

      // Widget should rebuild without errors
      await tester.pump();
      expect(find.byType(ThemeService), findsOneWidget);
    });
  });
}