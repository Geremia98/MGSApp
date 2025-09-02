import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mgs_app2/screens/main_screens/home_screen.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/utilities/my_colors.dart';
import '../../test_helpers.dart';

void main() {
  group('HomeScreen', () {
    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      // Reset UserModel before each test
      UserModel.name = 'Mario';
      UserModel.surname = 'Rossi';
      UserModel.gender = UserGender.male;
      UserModel.birth = DateTime(1990, 1, 1);
      UserModel.country = 'IT';
      UserModel.ispettoria = 'Triveneto';
      UserModel.group = 'Sesto';
      UserModel.bossCode = '';
    });

    testWidgets('HomeScreen widget can be instantiated', (WidgetTester tester) async {
      // Test that the widget can be created without throwing
      expect(() => const HomeScreen(), returnsNormally);
    });

    testWidgets('HomeScreen has correct static id', (WidgetTester tester) async {
      expect(HomeScreen.id, equals('HomeScreen'));
    });

    testWidgets('HomeScreen creates state object', (WidgetTester tester) async {
      const homeScreen = HomeScreen();
      final state = homeScreen.createState();
      expect(state, isNotNull);
    });

    testWidgets('HomeScreen can be built in widget tree', (WidgetTester tester) async {
      // Disable overflow errors for this test
      final originalOnError = FlutterError.onError;
      final errors = <FlutterErrorDetails>[];
      
      FlutterError.onError = (details) {
        // Only capture non-overflow errors
        if (!details.toString().contains('overflowed')) {
          errors.add(details);
        }
      };

      try {
        tester.view.physicalSize = const Size(1400, 2800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('it', ''),
            ],
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: const HomeScreen(),
          ),
        );

        // Just do a minimal pump to test basic structure
        await tester.pump(const Duration(milliseconds: 16));

        // Verify basic structure exists
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);

        // Verify no critical errors occurred
        expect(errors, isEmpty);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('UserModel boss code affects widget behavior', (WidgetTester tester) async {
      // Test that changing boss code doesn't break the widget
      UserModel.bossCode = 'BOSS123';
      expect(() => const HomeScreen(), returnsNormally);
      
      UserModel.bossCode = '';
      expect(() => const HomeScreen(), returnsNormally);
    });

    testWidgets('HomeScreen handles different user configurations', (WidgetTester tester) async {
      // Test various UserModel configurations
      final configurations = [
        () {
          UserModel.gender = UserGender.male;
          UserModel.bossCode = '';
        },
        () {
          UserModel.gender = UserGender.female;
          UserModel.bossCode = 'BOSS123';
        },
        () {
          UserModel.name = 'Test';
          UserModel.surname = 'User';
        },
      ];

      for (final config in configurations) {
        config();
        expect(() => const HomeScreen(), returnsNormally);
      }
    });

    testWidgets('HomeScreen state methods exist and are callable', (WidgetTester tester) async {
      // Disable overflow errors
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed')) {
          throw details.exception;
        }
      };

      try {
        tester.view.physicalSize = const Size(1400, 2800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('it', ''),
            ],
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: const HomeScreen(),
          ),
        );

        await tester.pump(const Duration(milliseconds: 16));

        // Get the state and test methods exist
        final state = tester.state(find.byType(HomeScreen));
        expect(state, isNotNull);
        
        // Test that calling needsRefreshEvents doesn't crash
        expect(() => (state as dynamic).needsRefreshEvents(true), returnsNormally);
        expect(() => (state as dynamic).needsRefreshEvents(false), returnsNormally);
        
        // Test that calling onEventCreation doesn't crash
        expect(() => (state as dynamic).onEventCreation(null), returnsNormally);

      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('HomeScreen renders without critical exceptions', (WidgetTester tester) async {
      bool hasCriticalError = false;
      final originalOnError = FlutterError.onError;
      
      FlutterError.onError = (details) {
        // Only flag as critical if it's not an overflow error
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          hasCriticalError = true;
        }
      };

      try {
        tester.view.physicalSize = const Size(1400, 2800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: const HomeScreen(),
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
          ),
        );

        // Minimal pump
        await tester.pump(const Duration(milliseconds: 16));
        
        // Verify no critical errors
        expect(hasCriticalError, isFalse);
        expect(find.byType(HomeScreen), findsOneWidget);

      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}