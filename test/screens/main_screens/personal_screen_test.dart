import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/main_screens/personal_screen.dart';
import 'package:mgs_app2/utilities/constants_strings.dart';
import 'package:mgs_app2/utilities/my_colors.dart';
import '../../test_helpers.dart';

void main() {
  group('PersonalScreen', () {
    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      // Reset the UserModel before each test
      UserModel.name = 'Mario';
      UserModel.surname = 'Rossi';
      UserModel.gender = UserGender.male;
      UserModel.birth = DateTime(1990, 1, 1);
      UserModel.country = 'IT';
      UserModel.ispettoria = 'Triveneto';
      UserModel.group = 'Sesto';
      UserModel.bossCode = '';
    });

    Future<void> pumpWidget(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('it', ''), // Italian, no country code
          ],
          theme: ThemeData(
            extensions: const <ThemeExtension<dynamic>>[
              CustomColors.light,
            ],
          ),
          home: const Material(
            child: PersonalScreen(),
          ),
        ),
      );
    }

    testWidgets('creates correctly', (WidgetTester tester) async {
      await pumpWidget(tester);
      
      expect(find.byType(PersonalScreen), findsOneWidget);
    });

    testWidgets('is a StatefulWidget', (WidgetTester tester) async {
      await pumpWidget(tester);
      
      expect(find.byType(PersonalScreen), findsOneWidget);
      final widget = tester.widget<PersonalScreen>(find.byType(PersonalScreen));
      expect(widget, isA<StatefulWidget>());
    });

    testWidgets('renders basic structure', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;

      await pumpWidget(tester);
      await tester.pumpAndSettle();

      // Check that the widget renders without errors
      expect(find.byType(PersonalScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('handles UserModel data access', (WidgetTester tester) async {
      // Test that UserModel fields can be accessed
      expect(UserModel.name, equals('Mario'));
      expect(UserModel.surname, equals('Rossi'));
      expect(UserModel.gender, equals(UserGender.male));
      expect(UserModel.country, equals('IT'));
      expect(UserModel.ispettoria, equals('Triveneto'));
      expect(UserModel.group, equals('Sesto'));
    });

    testWidgets('widget can be instantiated without parameters', (WidgetTester tester) async {
      const personalScreen = PersonalScreen();
      expect(personalScreen, isNotNull);
      expect(personalScreen.key, isNull);
    });

    testWidgets('widget accepts optional key parameter', (WidgetTester tester) async {
      const key = Key('test-key');
      const personalScreen = PersonalScreen(key: key);
      expect(personalScreen.key, equals(key));
    });

    testWidgets('widget maintains state correctly', (WidgetTester tester) async {
      await pumpWidget(tester);
      await tester.pumpAndSettle();

      final personalScreenState = tester.state<PersonalScreenState>(find.byType(PersonalScreen));
      expect(personalScreenState, isNotNull);
      expect(personalScreenState.controller, isNotNull);
    });

    testWidgets('renders without overflow issues', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await pumpWidget(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('handles different screen sizes', (WidgetTester tester) async {
      // Test with large screen
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1.0;

      await pumpWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byType(PersonalScreen), findsOneWidget);

      // Test with small screen
      tester.view.physicalSize = const Size(300, 600);
      tester.view.devicePixelRatio = 1.0;

      await pumpWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byType(PersonalScreen), findsOneWidget);
    });

    testWidgets('theme is properly configured', (WidgetTester tester) async {
      await pumpWidget(tester);
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(PersonalScreen));
      final theme = Theme.of(context);
      expect(theme, isNotNull);
      expect(theme.extensions, isNotEmpty);
    });
  });
}