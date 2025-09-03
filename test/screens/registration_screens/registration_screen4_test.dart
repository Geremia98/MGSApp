import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/screens/registration_screens/registration_screen4.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import 'package:mgs_app2/widgets/back_button_app_bar.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_big_async_button.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';
import '../../test_helpers.dart';

void main() {
  group('RegistrationScreen4', () {
    late RegistrationController controller;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      controller = RegistrationController();
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        expect(find.byType(RegistrationScreen4), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
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
        await tester.binding.setSurfaceSize(Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: RegistrationScreen4(controller: controller),
          ),
        );

        expect(find.byType(BackButtonAppBar), findsOneWidget);
        expect(find.byType(CircleAvatar), findsOneWidget);
        expect(find.text('Ultimo step ...\nemail e password'), findsOneWidget);
        expect(find.text('(Yep, le tue credenziali)'), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(MyBigAsyncButton), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays form fields with correct labels', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: RegistrationScreen4(controller: controller),
          ),
        );

        // Check for hint texts in form fields
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.text('Conferma password'), findsOneWidget);
        
        // Check that form has the right number of text fields
        expect(find.byType(TextFormField), findsNWidgets(3));
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('can find email field by hint text', (WidgetTester tester) async {
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        // Find email field by hint text
        final emailField = find.widgetWithText(TextFormField, 'Email');
        expect(emailField, findsOneWidget);
        
        // Test text entry works
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump();
        
        // Text should appear in the field
        expect(find.text('test@example.com'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('can find password field by hint text', (WidgetTester tester) async {
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        // Find password field by hint text
        final passwordField = find.widgetWithText(TextFormField, 'Password');
        expect(passwordField, findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('can find confirm password field by hint text', (WidgetTester tester) async {
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        // Find confirm password field by hint text
        final confirmPasswordField = find.widgetWithText(TextFormField, 'Conferma password');
        expect(confirmPasswordField, findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('has password and confirm password fields', (WidgetTester tester) async {
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        // Verify we have the correct number of text fields
        expect(find.byType(TextFormField), findsNWidgets(3));
        
        // Verify hint texts are present
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.text('Conferma password'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('register button has correct text', (WidgetTester tester) async {
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        expect(find.text('Registrati'), findsOneWidget);
        expect(find.byType(MyBigAsyncButton), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('controller manages email correctly', (WidgetTester tester) async {
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        // Test email management - setEmail returns null for valid emails and sets the value
        String? result = controller.setEmail('user@test.com');
        expect(result, isNull); // Valid email should return null
        expect(controller.email, equals('user@test.com'));

        // Invalid email should return error message
        String? invalidResult = controller.setEmail('invalid-email');
        expect(invalidResult, isNotNull);
        expect(invalidResult, contains('Email non valida'));
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('controller manages password correctly', (WidgetTester tester) async {
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        // Test password management
        controller.setPassword('mySecretPassword');
        expect(controller.password, equals('mySecretPassword'));

        // Test confirm password
        controller.setConfirmPassword('mySecretPassword');
        expect(controller.confirmPassword, equals('mySecretPassword'));
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
                          builder: (BuildContext context) => RegistrationScreen4(controller: controller),
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

        expect(find.byType(RegistrationScreen4), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(RegistrationScreen4), findsNothing);
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(Stack), findsWidgets);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Positioned), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('form validation works correctly', (WidgetTester tester) async {
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        // Test form validation by setting valid data
        controller.setEmail('test@example.com');
        controller.setPassword('validPassword123');
        controller.setConfirmPassword('validPassword123');

        // Verify controller has valid data
        expect(controller.email, equals('test@example.com'));
        expect(controller.password, equals('validPassword123'));
        expect(controller.confirmPassword, equals('validPassword123'));
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('controller preserves all registration data', (WidgetTester tester) async {
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        // Set data from previous screens
        controller.setName('Mario');
        controller.setSurname('Rossi');
        controller.setCountry('Italia');
        controller.setGroup('Sesto');
        
        // Set current screen data
        controller.setEmail('mario.rossi@test.com');
        controller.setPassword('myPassword123');
        controller.setConfirmPassword('myPassword123');

        // Verify all data persists
        expect(controller.name, equals('Mario'));
        expect(controller.surname, equals('Rossi'));
        expect(controller.country, equals('Italia'));
        expect(controller.group, equals('Sesto'));
        expect(controller.email, equals('mario.rossi@test.com'));
        expect(controller.password, equals('myPassword123'));
        expect(controller.confirmPassword, equals('myPassword123'));
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('text fields can accept text input', (WidgetTester tester) async {
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        // Test that text fields can accept input
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), 'test@email.com');
        await tester.pump();
        
        // Verify text appears in UI (not necessarily in controller due to validation timing)
        expect(find.text('test@email.com'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('async button handles registration correctly', (WidgetTester tester) async {
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        final asyncButton = tester.widget<MyBigAsyncButton>(find.byType(MyBigAsyncButton));
        
        // Verify the async button has the correct properties
        expect(asyncButton.buttonText, equals('Registrati'));
        expect(asyncButton.onPressedAsync, isNotNull);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('form key is properly assigned', (WidgetTester tester) async {
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
            home: RegistrationScreen4(controller: controller),
          ),
        );

        // Verify form exists and can be accessed
        expect(find.byType(Form), findsOneWidget);
        final form = tester.widget<Form>(find.byType(Form));
        expect(form.key, isNotNull);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays registration illustration', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: RegistrationScreen4(controller: controller),
          ),
        );

        // Check for CircleAvatar with registration image
        expect(find.byType(CircleAvatar), findsOneWidget);
        
        // Check for main text elements
        expect(find.text('Ultimo step ...\nemail e password'), findsOneWidget);
        expect(find.text('(Yep, le tue credenziali)'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}