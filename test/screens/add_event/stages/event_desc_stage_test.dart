import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/screens/add_event/stages/event_desc_stage.dart';
import '../../../test_helpers.dart';

void main() {
  group('EventDescStage', () {
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
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        expect(find.byType(EventDescStage), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
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
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        // Check title elements
        expect(find.text('Descrizione evento'), findsOneWidget);
        expect(find.text('Ora inserisci una breve descrizione riguardo a cosa si farà'), findsOneWidget);
        
        // Check description field hint
        expect(find.text('Descrizione'), findsOneWidget);
        
        // Check that we have one text field
        expect(find.byType(TextFormField), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('initializes with stage invalid when no description is set', (WidgetTester tester) async {
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
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        // Stage should be invalid initially (no description set)
        expect(controller.isCurrentStageValid, isFalse);
        expect(controller.getDesc(), isEmpty);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('initializes with stage valid when description is pre-set', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Pre-set description
        controller.setDesc('This is a test event description');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        // Stage should be valid with description set
        expect(controller.isCurrentStageValid, isTrue);
        expect(controller.getDesc(), equals('This is a test event description'));
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('description field validation works correctly', (WidgetTester tester) async {
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
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        final descriptionField = find.byType(TextFormField);

        // Initially invalid (no description)
        expect(controller.isCurrentStageValid, isFalse);

        // Enter a valid description
        await tester.enterText(descriptionField, 'This event will include fun activities for everyone');
        await tester.pump();

        // Should become valid
        expect(controller.getDesc(), equals('This event will include fun activities for everyone'));
        expect(controller.isCurrentStageValid, isTrue);

        // Clear the description
        await tester.enterText(descriptionField, '');
        await tester.pump();

        // Should become invalid again
        expect(controller.getDesc(), isEmpty);
        expect(controller.isCurrentStageValid, isFalse);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('supports multiline description input', (WidgetTester tester) async {
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
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        final descriptionField = find.byType(TextFormField);

        // Enter multiline description
        const multilineDescription = 'This is a great event.\n\nWe will have:\n- Fun activities\n- Good food\n- Great company';
        await tester.enterText(descriptionField, multilineDescription);
        await tester.pump();

        // Should accept multiline input
        expect(controller.getDesc(), equals(multilineDescription));
        expect(controller.isCurrentStageValid, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles long description text correctly', (WidgetTester tester) async {
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
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        final descriptionField = find.byType(TextFormField);

        // Create a long description string (near the 1500 character limit)
        final longDescription = 'A' * 1000 + ' - This is a very detailed description of an amazing event that will take place soon. ' +
            'We have planned many activities and we want to make sure everyone knows what to expect.';
        await tester.enterText(descriptionField, longDescription);
        await tester.pump();

        // Should accept long text up to maxLength
        expect(controller.getDesc(), equals(longDescription));
        expect(controller.isCurrentStageValid, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays pre-filled description correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Pre-fill controller with description
        controller.setDesc('Pre-filled description for the event');

        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        // Check that pre-filled value is displayed
        expect(find.text('Pre-filled description for the event'), findsOneWidget);
        expect(controller.isCurrentStageValid, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('controller updates correctly when description changes', (WidgetTester tester) async {
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
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventDescStage));
        
        // Test description change via state method
        (state as dynamic).onTitleChange('New event description');
        
        // Verify controller was updated
        expect(controller.getDesc(), equals('New event description'));
        expect(controller.isCurrentStageValid, isTrue);

        // Test empty description
        (state as dynamic).onTitleChange('');
        expect(controller.getDesc(), isEmpty);
        expect(controller.isCurrentStageValid, isFalse);

        // Test null description
        (state as dynamic).onTitleChange(null);
        expect(controller.getDesc(), isEmpty);
        expect(controller.isCurrentStageValid, isFalse);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('text field accepts multiline input correctly', (WidgetTester tester) async {
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
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        final textField = find.byType(TextFormField);
        expect(textField, findsOneWidget);

        // Test that multiline input works (functional test instead of property access)
        const multilineText = 'Line 1\nLine 2\nLine 3';
        await tester.enterText(textField, multilineText);
        await tester.pump();
        
        expect(controller.getDesc(), equals(multilineText));
        expect(controller.isCurrentStageValid, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('stage validation updates in build method', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Initially invalid
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        expect(controller.isCurrentStageValid, isFalse);

        // Set description directly on controller
        controller.setDesc('Direct description update');
        
        // Trigger rebuild by pumping the widget again
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        // Build method should update validation based on controller state
        expect(controller.isCurrentStageValid, isTrue);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles text input correctly', (WidgetTester tester) async {
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
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        final textField = find.byType(TextFormField);
        
        // Test text input functionality
        await tester.enterText(textField, 'Sample event description');
        await tester.pump();
        
        expect(controller.getDesc(), equals('Sample event description'));
        expect(controller.isCurrentStageValid, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('widget responds to description changes correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Start with no description
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        expect(controller.isCurrentStageValid, isFalse);

        // Add description and rebuild
        controller.setDesc('Event description added');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        expect(controller.isCurrentStageValid, isTrue);

        // Remove description and rebuild
        controller.setDesc('');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        expect(controller.isCurrentStageValid, isFalse);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('widget is properly wrapped in SingleChildScrollView', (WidgetTester tester) async {
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
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        // Check that content is wrapped in SingleChildScrollView for long descriptions
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        
        // Verify the SingleChildScrollView contains the text field
        expect(find.descendant(
          of: find.byType(SingleChildScrollView), 
          matching: find.byType(TextFormField)
        ), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles whitespace-only input correctly', (WidgetTester tester) async {
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
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        final descriptionField = find.byType(TextFormField);

        // Enter whitespace-only description
        await tester.enterText(descriptionField, '   \n\n   ');
        await tester.pump();

        // Should store the whitespace (validation doesn't trim)
        expect(controller.getDesc(), equals('   \n\n   '));
        expect(controller.isCurrentStageValid, isTrue); // Non-empty, so valid
        
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
              body: EventDescStage(controller: controller),
            ),
          ),
        );

        // Verify widget is created
        expect(find.byType(EventDescStage), findsOneWidget);

        // Dispose the widget
        await tester.pumpWidget(Container());

        // Widget should be removed without errors
        expect(find.byType(EventDescStage), findsNothing);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}