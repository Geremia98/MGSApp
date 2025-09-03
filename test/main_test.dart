import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/main.dart';
import 'package:provider/provider.dart';
import 'test_helpers.dart';

void main() {
  group('BrightnessManager', () {
    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    group('singleton pattern', () {
      test('returns same instance', () {
        final instance1 = BrightnessManager();
        final instance2 = BrightnessManager();
        
        expect(identical(instance1, instance2), isTrue);
      });

      test('factory constructor works correctly', () {
        final instance = BrightnessManager();
        expect(instance, isNotNull);
        expect(instance, isA<BrightnessManager>());
      });
    });

    group('brightness management', () {
      test('has initial brightness value', () {
        final brightnessManager = BrightnessManager();
        expect(brightnessManager.brightness, isA<Brightness>());
        expect(brightnessManager.brightness, anyOf(Brightness.light, Brightness.dark));
      });

      test('toggleBrightness changes brightness', () {
        final brightnessManager = BrightnessManager();
        final initialBrightness = brightnessManager.brightness;
        
        brightnessManager.toggleBrightness();
        
        expect(brightnessManager.brightness, isNot(equals(initialBrightness)));
      });

      test('toggleBrightness alternates between light and dark', () {
        final brightnessManager = BrightnessManager();
        
        // Set to known state first
        final initialBrightness = brightnessManager.brightness;
        
        // Toggle once
        brightnessManager.toggleBrightness();
        final firstToggle = brightnessManager.brightness;
        expect(firstToggle, isNot(equals(initialBrightness)));
        
        // Toggle back
        brightnessManager.toggleBrightness();
        final secondToggle = brightnessManager.brightness;
        expect(secondToggle, equals(initialBrightness));
      });

      test('multiple toggles work correctly', () {
        final brightnessManager = BrightnessManager();
        final initialBrightness = brightnessManager.brightness;
        
        // Toggle twice should return to original
        brightnessManager.toggleBrightness();
        brightnessManager.toggleBrightness();
        
        expect(brightnessManager.brightness, equals(initialBrightness));
      });
    });

    group('ChangeNotifier behavior', () {
      test('is a ChangeNotifier', () {
        final brightnessManager = BrightnessManager();
        expect(brightnessManager, isA<ChangeNotifier>());
      });

      test('notifies listeners when brightness changes', () {
        final brightnessManager = BrightnessManager();
        bool notified = false;
        
        brightnessManager.addListener(() {
          notified = true;
        });
        
        brightnessManager.toggleBrightness();
        
        expect(notified, isTrue);
      });
    });

    group('state consistency', () {
      test('brightness getter is consistent', () {
        final brightnessManager = BrightnessManager();
        final brightness1 = brightnessManager.brightness;
        final brightness2 = brightnessManager.brightness;
        
        expect(brightness1, equals(brightness2));
      });

      test('state persists across multiple accesses', () {
        final brightnessManager = BrightnessManager();
        brightnessManager.toggleBrightness();
        final brightness1 = brightnessManager.brightness;
        
        // Create another reference to same instance
        final anotherReference = BrightnessManager();
        final brightness2 = anotherReference.brightness;
        
        expect(brightness1, equals(brightness2));
      });
    });
  });

  group('MyApp', () {
    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    testWidgets('is a StatefulWidget', (WidgetTester tester) async {
      expect(const MyApp(), isA<StatefulWidget>());
    });

    testWidgets('has correct key type', (WidgetTester tester) async {
      const app = MyApp(key: ValueKey('test'));
      expect(app.key, isA<Key>());
    });

    testWidgets('creates state correctly', (WidgetTester tester) async {
      const app = MyApp();
      final state = app.createState();
      expect(state, isNotNull);
    });

    testWidgets('builds MaterialApp structure', (WidgetTester tester) async {
      final brightnessManager = BrightnessManager();
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: brightnessManager,
          child: const MyApp(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
      expect(materialApp.supportedLocales, hasLength(2));
      expect(materialApp.supportedLocales, contains(const Locale('en', 'US')));
      expect(materialApp.supportedLocales, contains(const Locale('it', 'IT')));
    });

    testWidgets('has correct localization setup', (WidgetTester tester) async {
      final brightnessManager = BrightnessManager();
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: brightnessManager,
          child: const MyApp(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.localizationsDelegates, isNotNull);
      expect(materialApp.localizationsDelegates, isNotEmpty);
    });
  });
}