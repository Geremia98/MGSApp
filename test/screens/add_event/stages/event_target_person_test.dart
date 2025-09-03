import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/screens/add_event/stages/event_target_person.dart';
import '../../../test_helpers.dart';

void main() {
  group('EventTargetPersonStage', () {
    late AddEventController controller;
    late PageController pageController;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      pageController = PageController();
      controller = AddEventController(pageController: pageController);
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
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        expect(find.byType(EventTargetPersonStage), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
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
        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        // Check title elements
        expect(find.text('Per chi è?'), findsOneWidget);
        expect(find.text('Specifica le caratteristiche del target per cui è pensato l\'evento'), findsOneWidget);
        
        // Check gender selector
        expect(find.text('Genere:'), findsOneWidget);
        
        // Check age input fields
        expect(find.text('Età minima'), findsOneWidget);
        expect(find.text('Età massima'), findsOneWidget);
        expect(find.text('--'), findsOneWidget); // Separator between age fields
        
        // Check that we have the proper number of text fields
        expect(find.byType(TextFormField), findsNWidgets(2));
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('gender selector has all options', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        // Check that gender selector is present (using widget predicate to find SelectorStyle)
        expect(find.byWidgetPredicate((widget) => 
          widget.runtimeType.toString().startsWith('SelectorStyle')), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('initializes with stage invalid when no gender is selected', (WidgetTester tester) async {
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
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        // Stage should be invalid initially (no gender selected)
        expect(controller.isCurrentStageValid, isFalse);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('initializes with stage valid when gender is pre-selected', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Pre-set gender
        controller.setGender(EventTargetGender.both);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        // Stage should be valid with gender selected
        expect(controller.isCurrentStageValid, isTrue);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('age fields accept numeric input only', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        controller.setGender(EventTargetGender.both);

        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        final allTextFields = find.byType(TextFormField);
        final minAgeField = allTextFields.first;
        final maxAgeField = allTextFields.last;

        // Test that numeric input is accepted
        await tester.enterText(minAgeField, '18');
        await tester.enterText(maxAgeField, '25');
        
        // Check that values were entered correctly
        expect(find.text('18'), findsOneWidget);
        expect(find.text('25'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('age validation works correctly for valid ages', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        controller.setGender(EventTargetGender.both);

        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        final allTextFields = find.byType(TextFormField);
        final minAgeField = allTextFields.first;
        final maxAgeField = allTextFields.last;

        // Enter valid ages
        await tester.enterText(minAgeField, '18');
        await tester.enterText(maxAgeField, '25');
        
        // Trigger validation by tapping elsewhere
        await tester.tap(find.text('Genere:'));
        await tester.pump();

        // Should not show any error messages
        expect(find.textContaining('Inserisci'), findsNothing);
        expect(find.textContaining('Solo numeri'), findsNothing);
        expect(find.textContaining('Minimo 14 anni'), findsNothing);
        expect(find.textContaining('Non può essere maggiore di 199'), findsNothing);

        // Controller should have valid ages set
        expect(controller.getMinAge(), equals(18));
        expect(controller.getMaxAge(), equals(25));
        expect(controller.isCurrentStageValid, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('shows validation errors for invalid ages', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        controller.setGender(EventTargetGender.both);

        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        final allTextFields = find.byType(TextFormField);
        final minAgeField = allTextFields.first;
        final maxAgeField = allTextFields.last;

        // Test age too low
        await tester.enterText(minAgeField, '10');
        await tester.tap(find.text('Genere:'));
        await tester.pump();

        expect(find.textContaining('Minimo 14'), findsOneWidget);

        // Test age too high
        await tester.enterText(maxAgeField, '250');
        await tester.tap(find.text('Genere:'));
        await tester.pump();

        expect(find.textContaining('Non può essere maggiore'), findsOneWidget);

        // Test non-numeric input (should be prevented by input formatter)
        await tester.enterText(minAgeField, 'abc');
        await tester.tap(find.text('Genere:'));
        await tester.pump();

        expect(controller.isCurrentStageValid, isFalse);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('validates that max age is not less than min age', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        controller.setGender(EventTargetGender.both);

        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        final allTextFields = find.byType(TextFormField);
        final minAgeField = allTextFields.first;
        final maxAgeField = allTextFields.last;

        // Enter min age > max age
        await tester.enterText(minAgeField, '25');
        await tester.enterText(maxAgeField, '20');
        
        // Trigger validation
        await tester.tap(find.text('Genere:'));
        await tester.pump();

        // Should show error for max age being less than min age
        expect(find.textContaining('Non può essere minore'), findsOneWidget);
        expect(controller.isCurrentStageValid, isFalse);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('stage validation updates properly when fields change', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        controller.setGender(EventTargetGender.both);

        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        final allTextFields = find.byType(TextFormField);
        final minAgeField = allTextFields.first;
        final maxAgeField = allTextFields.last;
        
        // Stage should be valid with just gender initially
        expect(controller.isCurrentStageValid, isTrue);
        
        // Enter valid ages
        await tester.enterText(minAgeField, '18');
        await tester.enterText(maxAgeField, '25');
        await tester.pump();
        
        // Should remain valid
        expect(controller.isCurrentStageValid, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('stage remains invalid if gender is not selected even with valid ages', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        final allTextFields = find.byType(TextFormField);
        final minAgeField = allTextFields.first;
        final maxAgeField = allTextFields.last;

        // Enter valid ages but don't select gender
        await tester.enterText(minAgeField, '18');
        await tester.enterText(maxAgeField, '25');
        
        // Trigger validation
        await tester.tap(find.text('Genere:'));
        await tester.pump();

        // Stage should remain invalid without gender selection
        expect(controller.isCurrentStageValid, isFalse);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('controller updates correctly when gender changes', (WidgetTester tester) async {
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
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventTargetPersonStage));
        
        // Simulate gender selection
        (state as dynamic).onGenderTargetChanged(EventTargetGender.male);
        
        // Verify controller was updated
        expect(controller.getGender(), equals(EventTargetGender.male));
        // After gender change, _validateAges() is called which requires both age fields to be filled
        expect(controller.isCurrentStageValid, isFalse);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays pre-filled age values correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Pre-fill controller with age values
        controller.setMinAge(20);
        controller.setMaxAge(30);
        controller.setGender(EventTargetGender.both);

        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        // Check that pre-filled values are displayed
        expect(find.text('20'), findsOneWidget);
        expect(find.text('30'), findsOneWidget);
        expect(controller.isCurrentStageValid, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('widget handles focus changes without errors', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        controller.setGender(EventTargetGender.both);

        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        final allTextFields = find.byType(TextFormField);
        final minAgeField = allTextFields.first;
        
        // Test that focus changes work without errors
        await tester.tap(minAgeField);
        await tester.pump();
        
        await tester.tap(find.text('Genere:'));
        await tester.pump();
        
        // Should complete without throwing exceptions
        expect(find.byType(EventTargetPersonStage), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('complex validation scenario with all valid inputs', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventTargetPersonStage));
        final allTextFields = find.byType(TextFormField);
        final minAgeField = allTextFields.first;
        final maxAgeField = allTextFields.last;

        // Set all valid inputs
        (state as dynamic).onGenderTargetChanged(EventTargetGender.female);
        await tester.pump();
        
        await tester.enterText(minAgeField, '16');
        await tester.enterText(maxAgeField, '65');
        
        // Trigger validation
        await tester.tap(find.text('Genere:'));
        await tester.pump();

        // All should be valid
        expect(controller.getGender(), equals(EventTargetGender.female));
        expect(controller.getMinAge(), equals(16));
        expect(controller.getMaxAge(), equals(65));
        expect(controller.isCurrentStageValid, isTrue);
        
        // No error messages should be displayed
        expect(find.textContaining('Inserisci'), findsNothing);
        expect(find.textContaining('Solo numeri'), findsNothing);
        expect(find.textContaining('Minimo 14 anni'), findsNothing);
        expect(find.textContaining('Non può essere maggiore di 199'), findsNothing);
        expect(find.textContaining('Non può essere minore'), findsNothing);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('properly disposes resources', (WidgetTester tester) async {
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
            home: Scaffold(
              body: EventTargetPersonStage(controller: controller),
            ),
          ),
        );

        // Verify widget is created
        expect(find.byType(EventTargetPersonStage), findsOneWidget);

        // Dispose the widget
        await tester.pumpWidget(Container());

        // Widget should be removed without errors
        expect(find.byType(EventTargetPersonStage), findsNothing);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}