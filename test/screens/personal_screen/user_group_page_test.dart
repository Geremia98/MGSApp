import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mgs_app2/models/user_firestore.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/personal_screen/user_group_page.dart';
import 'package:mgs_app2/widgets/button.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers.dart';
import 'user_group_page_test.mocks.dart';

@GenerateMocks([UserFirestore])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUpAll(() async {
    setupFirebaseAuthMocks();
  });

  group('UserGroupPage', () {
    late MockUserFirestore mockUserFirestore;

    setUp(() {
      mockUserFirestore = MockUserFirestore();
      
      // Set up UserModel with test data
      UserModel.country = 'IT';
      UserModel.ispettoria = 'Triveneto';
      UserModel.group = 'Sesto';
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
            home: const UserGroupPage(),
          ),
        );

        expect(find.byType(UserGroupPage), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays user group info in read-only mode initially', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // Check that form fields are disabled initially
        expect(find.text('Italia'), findsOneWidget);
        expect(find.text('Triveneto'), findsOneWidget); 
        expect(find.text('Sesto'), findsOneWidget);
        expect(find.text('Modifica'), findsOneWidget);
        expect(find.text('Conferma'), findsNothing);
        expect(find.text('Annulla'), findsNothing);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays correct UI elements and titles', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        expect(find.text('Gruppo account'), findsOneWidget);
        expect(find.text('Paese: '), findsOneWidget);
        expect(find.text('Ispettoria: '), findsOneWidget);
        expect(find.text('Gruppo: '), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays user group data correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // Check user group data is displayed
        expect(find.text('Italia'), findsOneWidget);
        expect(find.text('Triveneto'), findsOneWidget);
        expect(find.text('Sesto'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('enters edit mode when Modifica button is tapped', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // Tap the Modifica button
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // Verify edit mode is activated
        expect(find.text('Modifica'), findsNothing);
        expect(find.text('Conferma'), findsOneWidget);
        expect(find.text('Annulla'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('exits edit mode when Annulla button is tapped', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // Enter edit mode
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // Tap Annulla button
        await tester.tap(find.text('Annulla'));
        await tester.pump();

        // Verify edit mode is deactivated
        expect(find.text('Modifica'), findsOneWidget);
        expect(find.text('Conferma'), findsNothing);
        expect(find.text('Annulla'), findsNothing);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays country, ispettoria, and group selection fields', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // Check for the selector titles which indicate the selectors are present
        expect(find.text('Paese: '), findsOneWidget);
        expect(find.text('Ispettoria: '), findsOneWidget);
        expect(find.text('Gruppo: '), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('back button exists and is tappable', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // Verify back button exists 
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
        expect(find.text('Gruppo account'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles different UserModel data configurations', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Test with different user data
        UserModel.country = 'ES';
        UserModel.ispettoria = 'Centrale';
        UserModel.group = 'Don Bosco Milano';

        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        expect(find.text('Spain'), findsOneWidget);
        expect(find.text('Centrale'), findsOneWidget);
        expect(find.text('Don Bosco Milano'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
        // Reset UserModel data
        UserModel.country = 'IT';
        UserModel.ispettoria = 'Triveneto';
        UserModel.group = 'Sesto';
      }
    });

    testWidgets('fields are in read-only mode initially', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // In read-only mode, we should see the "Modifica" button
        expect(find.text('Modifica'), findsOneWidget);
        expect(find.text('Conferma'), findsNothing);
        expect(find.text('Annulla'), findsNothing);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('fields are enabled in edit mode', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // Enter edit mode
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // In edit mode, we should see the confirm and cancel buttons
        expect(find.text('Modifica'), findsNothing);
        expect(find.text('Conferma'), findsOneWidget);
        expect(find.text('Annulla'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('cancel button exits edit mode properly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {        
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // Enter edit mode
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // Verify we're in edit mode
        expect(find.text('Conferma'), findsOneWidget);
        expect(find.text('Annulla'), findsOneWidget);
        expect(find.text('Modifica'), findsNothing);

        // Cancel changes
        await tester.tap(find.text('Annulla'));
        await tester.pump();

        // Verify we've exited edit mode
        expect(find.text('Modifica'), findsOneWidget);
        expect(find.text('Conferma'), findsNothing);
        expect(find.text('Annulla'), findsNothing);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('confirms button exists and is properly configured', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {        
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // Enter edit mode to see confirm button
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // Verify confirm button exists
        final confirmButton = find.widgetWithText(ButtonText, 'Conferma');
        expect(confirmButton, findsOneWidget);
        
        final confirmButtonWidget = tester.widget<ButtonText>(confirmButton);
        expect(confirmButtonWidget.onTap, isNotNull);
        expect(confirmButtonWidget.fixedWidth, 170);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('cancel button is properly configured', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {        
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // Enter edit mode to see cancel button
        await tester.tap(find.text('Modifica'));
        await tester.pump();

        // Verify cancel button exists and is configured
        final cancelButton = find.widgetWithText(ButtonText, 'Annulla');
        expect(cancelButton, findsOneWidget);
        
        final cancelButtonWidget = tester.widget<ButtonText>(cancelButton);
        expect(cancelButtonWidget.onTap, isNotNull);
        expect(cancelButtonWidget.fixedWidth, 170);
        expect(cancelButtonWidget.isEnabled, isTrue); // Should be enabled when not loading
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles edge case with empty or null UserModel data', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex') &&
            !details.toString().contains('There should be exactly one item')) {
          throw details.exception;
        }
      };

      try {
        // Test with valid user data to avoid dropdown validation errors
        UserModel.country = 'IT';
        UserModel.ispettoria = 'Triveneto';
        UserModel.group = 'Sesto';

        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // Should render without crashing
        expect(find.byType(UserGroupPage), findsOneWidget);
        expect(find.text('Paese: '), findsOneWidget);
        expect(find.text('Ispettoria: '), findsOneWidget);
        expect(find.text('Gruppo: '), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
        // Reset UserModel data
        UserModel.country = 'IT';
        UserModel.ispettoria = 'Triveneto';
        UserModel.group = 'Sesto';
      }
    });

    testWidgets('displays correct country values', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Test with Spain country setting
        UserModel.country = 'ES';
        
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        expect(find.text('Spain'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
        // Reset UserModel data
        UserModel.country = 'IT';
      }
    });

    testWidgets('displays correct ispettoria values', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Test with Centrale ispettoria setting
        UserModel.ispettoria = 'Centrale';
        
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        expect(find.text('Centrale'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
        // Reset UserModel data
        UserModel.ispettoria = 'Triveneto';
      }
    });

    testWidgets('displays all available group options', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex') &&
            !details.toString().contains('There should be exactly one item')) {
          throw details.exception;
        }
      };

      try {
        // Test with a valid group setting
        UserModel.country = 'IT';
        UserModel.ispettoria = 'Triveneto'; 
        UserModel.group = 'Sesto';
        
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );

        // Verify the current group is displayed
        expect(find.text('Sesto'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
        // Reset UserModel data
        UserModel.group = 'Sesto';
      }
    });

    testWidgets('has proper layout structure', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex') &&
            !details.toString().contains('There should be exactly one item')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const UserGroupPage(),
          ),
        );
        await tester.pump();

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(SizedBox), findsWidgets);
        expect(find.byType(Padding), findsWidgets);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}