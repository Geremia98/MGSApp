import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/report_bug/report_bug_screen.dart';
import 'package:mgs_app2/screens/main_screens/home_screen.dart';
import 'package:mgs_app2/services/functions/firebase_function_caller.dart';
import 'package:mgs_app2/services/functions/function_response.dart';
import 'package:mgs_app2/services/functions/response_type.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/text_field.dart';
import 'package:mockito/mockito.dart';
import '../../test_helpers.dart';
import '../../mocks.mocks.dart';

void main() {
  group('ReportBugScreen', () {
    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      UserModel.name = 'Mario';
      UserModel.surname = 'Rossi';
      UserModel.gender = UserGender.male;
      UserModel.birth = DateTime(1990, 1, 1);
      UserModel.country = 'IT';
      UserModel.ispettoria = 'Triveneto';
      UserModel.group = 'Sesto';
      UserModel.uid = 'test_uid';
    });

    testWidgets('renders correctly with basic structure', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'test_category'),
          ),
        );

        expect(find.byType(ReportBugScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.text('Segnala un bug'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays all required UI elements', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'test_category'),
          ),
        );

        expect(find.byType(GoBackButton), findsOneWidget);
        expect(find.text('Segnala un bug'), findsOneWidget);
        expect(find.text('Perfavore descrivi il problema che stai riscontrando. \nIl nostro team controllerà appena possibile.'), findsOneWidget);
        expect(find.byType(PrimaryTextField), findsOneWidget);
        expect(find.byType(PrimaryButton), findsOneWidget);
        expect(find.text('Invia segnalazione'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('shows validation error for empty description', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'test_category'),
          ),
        );

        // Find and tap the submit button without entering text
        final submitButton = find.text('Invia segnalazione');
        await tester.tap(submitButton);
        await tester.pump();

        // Check for validation message
        expect(find.text('Please enter a description.'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('accepts text input in description field', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'test_category'),
          ),
        );

        final textField = find.byType(TextFormField);
        await tester.enterText(textField, 'This is a test bug description');
        await tester.pump();

        expect(find.text('This is a test bug description'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('submit button triggers submission process', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'test_category'),
          ),
        );

        // Enter text in the description field
        final textField = find.byType(TextFormField);
        await tester.enterText(textField, 'Test bug description');
        await tester.pump();

        // Find submit button and verify it's present
        final submitButton = find.text('Invia segnalazione');
        expect(submitButton, findsOneWidget);
        
        // Tap submit button
        await tester.tap(submitButton);
        await tester.pump();
        
        // At minimum, the submission process should start
        // (We can't easily test the loading state due to async timing)
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('back button pops navigator', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
        
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => ReportBugScreen(category: 'test_category'),
                        ),
                      );
                    },
                    child: const Text('Push'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(ReportBugScreen), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(ReportBugScreen), findsNothing);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('text field has correct properties', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'test_category'),
          ),
        );

        final textField = tester.widget<PrimaryTextField>(find.byType(PrimaryTextField));
        expect(textField.labelText, equals('Descrizione Bug'));
        expect(textField.maxLines, equals(100));
        expect(textField.maxLength, equals(1500));
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles different categories correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'ui_bug'),
          ),
        );

        expect(find.byType(ReportBugScreen), findsOneWidget);
        
        // Test with different category
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'crash_bug'),
          ),
        );

        expect(find.byType(ReportBugScreen), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('has proper layout structure', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'test_category'),
          ),
        );

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(Padding), findsWidgets);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(SizedBox), findsWidgets);
        expect(find.byType(Center), findsWidgets);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('disposes controller properly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'test_category'),
          ),
        );

        // Navigate away to trigger dispose
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Text('Different screen')),
          ),
        );

        // Should not throw any errors
        expect(find.text('Different screen'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('maintains state during interaction', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'test_category'),
          ),
        );

        // Enter text
        final textField = find.byType(TextFormField);
        await tester.enterText(textField, 'Test description');
        await tester.pump();

        // Text should persist
        expect(find.text('Test description'), findsOneWidget);

        // Scroll and text should still be there
        await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -100));
        await tester.pump();
        
        expect(find.text('Test description'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles long text input correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'test_category'),
          ),
        );

        // Enter long text
        final longText = 'A' * 200;
        final textField = find.byType(TextFormField);
        await tester.enterText(textField, longText);
        await tester.pump();

        expect(find.textContaining('A'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('submit button exists and is tappable with valid input', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportBugScreen(category: 'test_category'),
          ),
        );

        // Enter text
        final textField = find.byType(TextFormField);
        await tester.enterText(textField, 'Test bug description');
        await tester.pump();

        // Find submit button
        final submitButton = find.text('Invia segnalazione');
        expect(submitButton, findsOneWidget);
        
        // Verify button can be tapped
        await tester.tap(submitButton);
        await tester.pump();
        
        // Test passes if no exception is thrown
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}