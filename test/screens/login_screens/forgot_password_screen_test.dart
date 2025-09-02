import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/screens/login_screens/forgot_password_screen.dart';
import 'package:mgs_app2/services/firebase/auth.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  group('ForgotPasswordScreen', () {
    late MockFirebaseAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );

      await tester.pump();

      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets('email input field validation', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: ForgotPasswordScreen(formKey: formKey),
        ),
      );

      await tester.pump();

      final emailField = find.byType(TextFormField);
      expect(emailField, findsOneWidget);

      await tester.enterText(emailField, 'invalid-email');
      await tester.pump();

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Email is not valid'), findsOneWidget);

      await tester.enterText(emailField, 'valid.email@test.com');
      await tester.pump();

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Email is not valid'), findsNothing);
    });

    testWidgets('finds Invia button and taps it', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );

      await tester.pump();

      final button = find.widgetWithText(ButtonText, 'Invia');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();
    });

    testWidgets('finds back button and taps it', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );

      await tester.pump();

      final backButton = find.byIcon(Icons.arrow_back_rounded);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pump();
    });

    testWidgets('shows success message on successful password reset', (WidgetTester tester) async {
      when(mockAuthService.sendPasswordResetEmail(any)).thenAnswer((_) async => true);

      await tester.pumpWidget(
        MaterialApp(
          home: ForgotPasswordScreen(authService: mockAuthService),
        ),
      );

      await tester.pump();

      final emailField = find.byType(TextFormField);
      await tester.enterText(emailField, 'valid.email@test.com');
      await tester.pump();

      final button = find.widgetWithText(ButtonText, 'Invia');
      await tester.tap(button);
      await tester.pump();

      expect(find.text('Email per il reset della password inviata!'), findsOneWidget);
    });

    testWidgets('shows error message on failed password reset', (WidgetTester tester) async {
      when(mockAuthService.sendPasswordResetEmail(any)).thenAnswer((_) async => FirebaseAuthException(code: 'user-not-found'));

      await tester.pumpWidget(
        MaterialApp(
          home: ForgotPasswordScreen(authService: mockAuthService),
        ),
      );

      await tester.pump();

      final emailField = find.byType(TextFormField);
      await tester.enterText(emailField, 'valid.email@test.com');
      await tester.pump();

      final button = find.widgetWithText(ButtonText, 'Invia');
      await tester.tap(button);
      await tester.pump();

      expect(find.text('Indirizzo email non registrato!'), findsOneWidget);
    });
  });
}
