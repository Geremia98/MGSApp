import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/main_screens/personal_screen.dart';
import 'package:mgs_app2/utilities/constants_strings.dart';
import 'package:mgs_app2/utilities/my_colors.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_date_picker.dart';
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

    testWidgets('renders correctly with initial data', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;

      await pumpWidget(tester);
      await tester.pumpAndSettle();

      expect(find.text('Mario'), findsOneWidget);
      expect(find.text('Rossi'), findsOneWidget);
      // Add more expects for other initial data
    });

    testWidgets('entering and exiting edit mode', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;

      await pumpWidget(tester);
      await tester.pumpAndSettle();

      // Initially, fields should be disabled
      expect(tester.widget<TextFormField>(find.byType(TextFormField).first).enabled, isFalse);

      // Tap the edit button
      await tester.tap(find.byIcon(Icons.edit_rounded));
      await tester.pumpAndSettle();

      // Now, fields should be enabled
      expect(tester.widget<TextFormField>(find.byType(TextFormField).first).enabled, isTrue);

      // Tap the cancel button
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      // Fields should be disabled again
      expect(tester.widget<TextFormField>(find.byType(TextFormField).first).enabled, isFalse);
    });

    testWidgets('editing and saving data', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;

      await pumpWidget(tester);
      await tester.pumpAndSettle();

      // Tap the edit button
      await tester.tap(find.byIcon(Icons.edit_rounded));
      await tester.pumpAndSettle();

      // Edit the name
      await tester.enterText(find.byType(TextFormField).first, 'Luigi');
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.byIcon(Icons.check_rounded));
      await tester.pumpAndSettle();

      // Verify that the UserModel has been updated
      expect(UserModel.name, 'Luigi');

      // Fields should be disabled again
      expect(tester.widget<TextFormField>(find.byType(TextFormField).first).enabled, isFalse);
    });

    testWidgets('changing gender', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;

      await pumpWidget(tester);
      await tester.pumpAndSettle();

      // Tap the edit button
      await tester.tap(find.byIcon(Icons.edit_rounded));
      await tester.pumpAndSettle();

      // Change gender to Female
      await tester.tap(find.text('Femmina'));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.byIcon(Icons.check_rounded));
      await tester.pumpAndSettle();

      // Verify that the UserModel has been updated
      expect(UserModel.gender, UserGender.female);
    });

    testWidgets('toggling boss code field', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;

      await pumpWidget(tester);
      await tester.pumpAndSettle();

      // Initially, boss code field should not be visible
      expect(find.text('Codice del Boss: '), findsNothing);

      // Tap the edit button
      await tester.tap(find.byIcon(Icons.edit_rounded));
      await tester.pumpAndSettle();

      // Tap the "Si" button for "Boss?"
      await tester.tap(find.text('Si'));
      await tester.pumpAndSettle();

      // Now, boss code field should be visible
      expect(find.text('Codice del Boss: '), findsOneWidget);

      // Tap the "No" button for "Boss?"
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      // Now, boss code field should not be visible
      expect(find.text('Codice del Boss: '), findsNothing);
    });
  });
}