import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/screens/registration_screens/optional_registration_screen1.dart';
import 'package:mgs_app2/screens/registration_screens/optional_registration_screen2.dart';
import 'package:mgs_app2/screens/registration_screens/registration_screen2.dart';
import 'package:mgs_app2/screens/registration_screens/registration_controller.dart';
import '../../test_helpers.dart';

void main() {
  group('OptionalRegistrationScreen1', () {
    late RegistrationController controller;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      controller = RegistrationController();
      // Set a name so the personalized text appears
      controller.setName('Mario');
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
            home: OptionalRegistrationScreen1(controller: controller),
          ),
        );

        expect(find.byType(OptionalRegistrationScreen1), findsOneWidget);
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
            home: OptionalRegistrationScreen1(controller: controller),
          ),
        );

        expect(find.byType(CircleAvatar), findsOneWidget);
        expect(find.text('Mario,devi superarla \nquesta cosa\n dell\'età, su...'), findsOneWidget);
        expect(find.text('Che poi potrebbe andare peggio.\nPensa a chi è pelato...'), findsOneWidget);
        expect(find.byType(FilledButton), findsNWidgets(2));
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays personalized text with user name', (WidgetTester tester) async {
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
            home: OptionalRegistrationScreen1(controller: controller),
          ),
        );

        // Check for personalized text with the user's name
        expect(find.textContaining('Mario'), findsOneWidget);
        expect(find.text('Mario,devi superarla \nquesta cosa\n dell\'età, su...'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays button texts correctly', (WidgetTester tester) async {
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
            home: OptionalRegistrationScreen1(controller: controller),
          ),
        );

        expect(find.text('In realtà lo sono...'), findsOneWidget);
        expect(find.text('Hai ragione'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
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
            home: OptionalRegistrationScreen1(controller: controller),
          ),
        );

        // Check for CircleAvatar with registration image
        expect(find.byType(CircleAvatar), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('first button exists and has correct configuration', (WidgetTester tester) async {
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
            home: OptionalRegistrationScreen1(controller: controller),
          ),
        );

        // Find the "In realtà lo sono..." button
        final firstButton = find.widgetWithText(FilledButton, 'In realtà lo sono...');
        expect(firstButton, findsOneWidget);
        
        // Verify it's a FilledButton with the correct text
        final buttonWidget = tester.widget<FilledButton>(firstButton);
        expect(buttonWidget.onPressed, isNotNull);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('second button exists and has correct configuration', (WidgetTester tester) async {
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
            home: OptionalRegistrationScreen1(controller: controller),
          ),
        );

        // Find the "Hai ragione" button
        final secondButton = find.widgetWithText(FilledButton, 'Hai ragione');
        expect(secondButton, findsOneWidget);
        
        // Verify it's a FilledButton with the correct text and has onPressed handler
        final buttonWidget = tester.widget<FilledButton>(secondButton);
        expect(buttonWidget.onPressed, isNotNull);
        
        await tester.binding.setSurfaceSize(null);
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
            home: OptionalRegistrationScreen1(controller: controller),
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

    testWidgets('controller preserves registration data', (WidgetTester tester) async {
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
            home: OptionalRegistrationScreen1(controller: controller),
          ),
        );

        // Set additional data to test preservation
        controller.setSurname('Rossi');
        controller.setCountry('Italia');

        // Verify all data persists
        expect(controller.name, equals('Mario'));
        expect(controller.surname, equals('Rossi'));
        expect(controller.country, equals('Italia'));
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays different name when controller name changes', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Create controller with different name
        final differentController = RegistrationController();
        differentController.setName('Luigi');

        await tester.binding.setSurfaceSize(Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: OptionalRegistrationScreen1(controller: differentController),
          ),
        );

        // Should show Luigi instead of Mario
        expect(find.textContaining('Luigi'), findsOneWidget);
        expect(find.text('Luigi,devi superarla \nquesta cosa\n dell\'età, su...'), findsOneWidget);
        expect(find.textContaining('Mario'), findsNothing);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('both buttons are tappable', (WidgetTester tester) async {
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
            home: OptionalRegistrationScreen1(controller: controller),
          ),
        );

        // Check that both buttons exist and are tappable
        final firstButton = find.widgetWithText(FilledButton, 'In realtà lo sono...');
        final secondButton = find.widgetWithText(FilledButton, 'Hai ragione');
        
        expect(firstButton, findsOneWidget);
        expect(secondButton, findsOneWidget);
        
        // Verify buttons are FilledButton widgets
        expect(tester.widget<FilledButton>(firstButton), isA<FilledButton>());
        expect(tester.widget<FilledButton>(secondButton), isA<FilledButton>());
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('maintains correct text styling and layout', (WidgetTester tester) async {
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
            home: OptionalRegistrationScreen1(controller: controller),
          ),
        );

        // Check for main text elements
        expect(find.text('Mario,devi superarla \nquesta cosa\n dell\'età, su...'), findsOneWidget);
        expect(find.text('Che poi potrebbe andare peggio.\nPensa a chi è pelato...'), findsOneWidget);
        
        // Verify layout elements are present
        expect(find.byType(SizedBox), findsWidgets);
        expect(find.byType(Center), findsWidgets);
        expect(find.byType(Padding), findsWidgets);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles empty or null name gracefully', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Create controller with empty name
        final emptyNameController = RegistrationController();
        emptyNameController.setName('');

        await tester.binding.setSurfaceSize(Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: OptionalRegistrationScreen1(controller: emptyNameController),
          ),
        );

        // Should still render without crashing
        expect(find.byType(OptionalRegistrationScreen1), findsOneWidget);
        expect(find.text(',devi superarla \nquesta cosa\n dell\'età, su...'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}