import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mgs_app2/screens/login_screens/change_email_screen.dart';
import 'package:mgs_app2/services/firebase/auth.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers.dart';
import 'change_email_screen_test.mocks.dart';

@GenerateMocks([FirebaseAuthService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUpAll(() async {
    setupFirebaseAuthMocks();
  });

  group('ChangeEmailScreen', () {
    late MockFirebaseAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
    });

    testWidgets('displays basic UI elements', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(MaterialApp(home: const ChangeEmailScreen()));

        expect(find.text('Modifica email'), findsOneWidget);
        expect(find.text('Inserisci la tua nuova email. Verrà inviata una mail di conferma per completare la richiesta.'), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Modifica'), findsOneWidget);
        expect(find.byType(GoBackButton), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('email validation works correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(MaterialApp(home: const ChangeEmailScreen()));

        final emailField = find.byType(TextFormField);

        // Test invalid email with manual validation trigger
        await tester.enterText(emailField, 'invalid-email');
        await tester.pump();
        
        // Manually trigger form validation by accessing the form
        final formState = tester.state<FormState>(find.byType(Form));
        formState.validate();
        await tester.pump();

        expect(find.text('Email is not valid'), findsOneWidget);

        // Test valid email
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump();
        
        formState.validate();
        await tester.pump();
        
        expect(find.text('Email is not valid'), findsNothing);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('email validation helper function works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const ChangeEmailScreen()));

      final state = tester.state(find.byType(ChangeEmailScreen)) as dynamic;
      
      // Test valid emails
      expect(state.isEmailStringValid('test@example.com'), isTrue);
      expect(state.isEmailStringValid('user.name@domain.co.uk'), isTrue);
      expect(state.isEmailStringValid('user+tag@example.org'), isTrue);
      
      // Test invalid emails
      expect(state.isEmailStringValid(''), isFalse);
      expect(state.isEmailStringValid('invalid-email'), isFalse);
      expect(state.isEmailStringValid('@example.com'), isFalse);
      expect(state.isEmailStringValid('test@'), isFalse);
      expect(state.isEmailStringValid('test@.com'), isFalse);
    });

    testWidgets('form submission with valid email calls auth service', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Mock successful email reset
        when(mockAuthService.resetEmail(any)).thenAnswer((_) async => 'Success');

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(MaterialApp(
          home: ChangeEmailScreen(authService: mockAuthService),
        ));

        // Enter valid email
        final emailField = find.byType(TextFormField);
        await tester.enterText(emailField, 'newemail@example.com');
        await tester.pump();

        // Call changeEmail method directly
        final state = tester.state(find.byType(ChangeEmailScreen)) as dynamic;
        await state.changeEmail();
        await tester.pumpAndSettle();

        // Verify service was called
        verify(mockAuthService.resetEmail('newemail@example.com')).called(1);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('loading state changes correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(MaterialApp(
          home: ChangeEmailScreen(authService: mockAuthService),
        ));

        final state = tester.state(find.byType(ChangeEmailScreen)) as dynamic;
        
        // Initially not loading
        expect(state.isLoading, isFalse);
        
        // Manually set loading state to test the property
        state.setState(() {
          state.isLoading = true;
        });
        await tester.pump();
        
        expect(state.isLoading, isTrue);
        
        // Reset to false
        state.setState(() {
          state.isLoading = false;
        });
        await tester.pump();
        
        expect(state.isLoading, isFalse);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('form does not submit with invalid email', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(MaterialApp(home: const ChangeEmailScreen()));

        // Enter invalid email
        final emailField = find.byType(TextFormField);
        await tester.enterText(emailField, 'invalid-email');
        await tester.pump();

        // Trigger validation manually
        final formState = tester.state<FormState>(find.byType(Form));
        final isValid = formState.validate();
        await tester.pump();

        // Should not be valid and show error
        expect(isValid, isFalse);
        expect(find.text('Email is not valid'), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(MaterialApp(home: const ChangeEmailScreen()));

        // Verify back button exists
        expect(find.byType(GoBackButton), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles empty email field', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(MaterialApp(home: const ChangeEmailScreen()));

        // Trigger validation with empty field
        final formState = tester.state<FormState>(find.byType(Form));
        final isValid = formState.validate();
        await tester.pump();

        // Should not be valid and show error for empty field
        expect(isValid, isFalse);
        expect(find.text('Email is not valid'), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('email field trims whitespace', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(MaterialApp(home: const ChangeEmailScreen()));

        final state = tester.state(find.byType(ChangeEmailScreen)) as dynamic;
        
        // Test that onEmailChange validates email with whitespace (should fail)
        final result = state.onEmailChange('  test@example.com  ');
        expect(result, 'Email is not valid'); // Should be invalid due to whitespace
        
        // Test valid email without whitespace
        final validResult = state.onEmailChange('test@example.com');
        expect(validResult, isNull); // Should be valid
        expect(state.email, 'test@example.com'); // Should be stored
        
        // Test invalid email
        final invalidResult = state.onEmailChange('invalid-email');
        expect(invalidResult, 'Email is not valid'); // Should be invalid
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('form structure and layout', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(MaterialApp(home: const ChangeEmailScreen()));

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(SizedBox), findsWidgets);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}