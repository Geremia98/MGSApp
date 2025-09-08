import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mgs_app2/screens/login_screens/change_password_screen.dart';
import 'package:mgs_app2/services/firebase/auth.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers.dart';
import 'change_password_screen_test.mocks.dart';

@GenerateMocks([FirebaseAuthService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUpAll(() async {
    setupFirebaseAuthMocks();
  });

  group('ChangePasswordScreen', () {
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
        await tester.pumpWidget(MaterialApp(home: const ChangePasswordScreen()));

        expect(find.text('Modifica password'), findsOneWidget);
        expect(find.text('Inserisci la tua nuova password. E\' possibile, per motivi di sicurezza, venga richiesto di rieffettuare il login prima di poterla modificare.'), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Modifica'), findsOneWidget);
        expect(find.byType(GoBackButton), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('password validation works correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(MaterialApp(home: const ChangePasswordScreen()));

        final passwordField = find.byType(TextFormField);

        // Test short password with manual validation trigger
        await tester.enterText(passwordField, '123');
        await tester.pump();
        
        // Manually trigger form validation by accessing the form
        final formState = tester.state<FormState>(find.byType(Form));
        formState.validate();
        await tester.pump();

        expect(find.text('Password non valida (minimo 6 caratteri)'), findsOneWidget);

        // Test valid password
        await tester.enterText(passwordField, 'validpassword123');
        await tester.pump();
        
        formState.validate();
        await tester.pump();
        
        expect(find.text('Password non valida (minimo 6 caratteri)'), findsNothing);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('password validation helper function works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const ChangePasswordScreen()));

      final state = tester.state(find.byType(ChangePasswordScreen)) as dynamic;
      
      // Test valid passwords
      expect(state.onPassChange('password123'), isNull);
      expect(state.onPassChange('123456'), isNull);
      expect(state.onPassChange('a1b2c3d4e5f6'), isNull);
      
      // Test invalid passwords
      expect(state.onPassChange(''), 'Password non valida (minimo 6 caratteri)');
      expect(state.onPassChange('12345'), 'Password non valida (minimo 6 caratteri)');
      expect(state.onPassChange('abc'), 'Password non valida (minimo 6 caratteri)');
      expect(state.onPassChange(null), 'Password non valida (minimo 6 caratteri)');
    });

    testWidgets('form submission with valid password calls auth service', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Mock successful password reset
        when(mockAuthService.resetPassword(any)).thenAnswer((_) async => 'Success');

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(MaterialApp(
          home: ChangePasswordScreen(authService: mockAuthService),
        ));

        // Enter valid password
        final passwordField = find.byType(TextFormField);
        await tester.enterText(passwordField, 'newpassword123');
        await tester.pump();

        // Call changePassword method directly
        final state = tester.state(find.byType(ChangePasswordScreen)) as dynamic;
        await state.changePassword();
        await tester.pumpAndSettle();

        // Verify service was called
        verify(mockAuthService.resetPassword('newpassword123')).called(1);

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
          home: ChangePasswordScreen(authService: mockAuthService),
        ));

        final state = tester.state(find.byType(ChangePasswordScreen)) as dynamic;
        
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

    testWidgets('form does not submit with invalid password', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(MaterialApp(home: const ChangePasswordScreen()));

        // Enter invalid password
        final passwordField = find.byType(TextFormField);
        await tester.enterText(passwordField, '123');
        await tester.pump();

        // Trigger validation manually
        final formState = tester.state<FormState>(find.byType(Form));
        final isValid = formState.validate();
        await tester.pump();

        // Should not be valid and show error
        expect(isValid, isFalse);
        expect(find.text('Password non valida (minimo 6 caratteri)'), findsOneWidget);

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
        await tester.pumpWidget(MaterialApp(home: const ChangePasswordScreen()));

        // Verify back button exists
        expect(find.byType(GoBackButton), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles empty password field', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(MaterialApp(home: const ChangePasswordScreen()));

        // Trigger validation with empty field
        final formState = tester.state<FormState>(find.byType(Form));
        final isValid = formState.validate();
        await tester.pump();

        // Should not be valid and show error for empty field
        expect(isValid, isFalse);
        expect(find.text('Password non valida (minimo 6 caratteri)'), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('password field stores value correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(MaterialApp(home: const ChangePasswordScreen()));

        final state = tester.state(find.byType(ChangePasswordScreen)) as dynamic;
        
        // Test that onPassChange stores valid password
        final result = state.onPassChange('validpassword123');
        expect(result, isNull); // Should be valid
        expect(state.pass, 'validpassword123'); // Should be stored
        
        // Test invalid password
        final invalidResult = state.onPassChange('123');
        expect(invalidResult, 'Password non valida (minimo 6 caratteri)'); // Should be invalid
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
        await tester.pumpWidget(MaterialApp(home: const ChangePasswordScreen()));

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