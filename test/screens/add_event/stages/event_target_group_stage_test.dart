import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/screens/add_event/stages/event_target_group_stage.dart';
import 'package:mgs_app2/widgets/selector.dart';
import '../../../test_helpers.dart';

void main() {
  group('EventTargetGroupStage', () {
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
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        expect(find.byType(EventTargetGroupStage), findsOneWidget);
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
        await tester.binding.setSurfaceSize(Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // Check title and subtitle
        expect(find.text('Per chi è?'), findsOneWidget);
        expect(find.text('Inserisci il paese, l\'ispettoria e il gruppo a cui vuoi inviare l\'evento'), findsOneWidget);
        
        // Check selector labels
        expect(find.text('Paese:'), findsOneWidget);
        expect(find.text('Ispettoria:'), findsOneWidget);
        expect(find.text('Gruppo:'), findsOneWidget);
        
        // Check checkboxes
        expect(find.text('Invia a tutto il paese'), findsOneWidget);
        expect(find.text('Invia a tutta l\'ispetttoria'), findsOneWidget);
        
        // Check selectors - they might be a different generic type
        expect(find.byWidgetPredicate((widget) => widget.runtimeType.toString().startsWith('SelectorStyle')), findsNWidgets(3)); // Country, Ispettoria, Group
        expect(find.byType(CheckboxListTile), findsNWidgets(2)); // Country and Ispettoria broadcast
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('initializes with stage invalid when no selections made', (WidgetTester tester) async {
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
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // Stage should be invalid initially (no selections made)
        expect(controller.isCurrentStageValid, isFalse);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('country broadcast checkbox enables/disables correctly', (WidgetTester tester) async {
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
            home: Scaffold(
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // Initially country broadcast should be false
        final countryCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutto il paese');
        expect(countryCheckbox, findsOneWidget);
        
        CheckboxListTile checkbox = tester.widget<CheckboxListTile>(countryCheckbox);
        expect(checkbox.value, isFalse);

        // Tap to enable country broadcast
        await tester.tap(countryCheckbox);
        await tester.pump();

        // Should now be enabled
        checkbox = tester.widget<CheckboxListTile>(countryCheckbox);
        expect(checkbox.value, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('ispettoria broadcast checkbox enables/disables correctly', (WidgetTester tester) async {
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
            home: Scaffold(
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // Initially ispettoria broadcast should be false
        final ispettoriaCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutta l\'ispetttoria');
        expect(ispettoriaCheckbox, findsOneWidget);
        
        CheckboxListTile checkbox = tester.widget<CheckboxListTile>(ispettoriaCheckbox);
        expect(checkbox.value, isFalse);

        // Tap to enable ispettoria broadcast
        await tester.tap(ispettoriaCheckbox);
        await tester.pump();

        // Should now be enabled
        checkbox = tester.widget<CheckboxListTile>(ispettoriaCheckbox);
        expect(checkbox.value, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('country broadcast disables other options', (WidgetTester tester) async {
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
            home: Scaffold(
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // Enable country broadcast
        final countryCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutto il paese');
        await tester.tap(countryCheckbox);
        await tester.pump();

        // Check that ispettoria broadcast is now disabled
        final ispettoriaCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutta l\'ispetttoria');
        CheckboxListTile checkbox = tester.widget<CheckboxListTile>(ispettoriaCheckbox);
        expect(checkbox.value, isFalse);

        // Check that selectors are disabled appropriately
        final selectors = find.byType(SelectorStyle<String>);
        expect(selectors, findsNWidgets(3));
        
        // Ispettoria selector should be disabled when country broadcast is on
        final ispettoriaSelector = tester.widgetList<SelectorStyle<String>>(selectors).elementAt(1);
        expect(ispettoriaSelector.isEnable, isFalse);
        
        // Group selector should be disabled when country broadcast is on
        final groupSelector = tester.widgetList<SelectorStyle<String>>(selectors).elementAt(2);
        expect(groupSelector.isEnable, isFalse);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('ispettoria broadcast disables group selector but not country', (WidgetTester tester) async {
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
            home: Scaffold(
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // Enable ispettoria broadcast
        final ispettoriaCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutta l\'ispetttoria');
        await tester.tap(ispettoriaCheckbox);
        await tester.pump();

        // Check selectors enable state
        final selectors = find.byType(SelectorStyle<String>);
        expect(selectors, findsNWidgets(3));
        
        // Country selector should still be enabled
        final countrySelector = tester.widgetList<SelectorStyle<String>>(selectors).elementAt(0);
        expect(countrySelector.isEnable, isTrue);
        
        // Ispettoria selector should still be enabled
        final ispettoriaSelector = tester.widgetList<SelectorStyle<String>>(selectors).elementAt(1);
        expect(ispettoriaSelector.isEnable, isTrue);
        
        // Group selector should be disabled when ispettoria broadcast is on
        final groupSelector = tester.widgetList<SelectorStyle<String>>(selectors).elementAt(2);
        expect(groupSelector.isEnable, isFalse);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('validation works correctly for country broadcast', (WidgetTester tester) async {
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
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // Initially invalid
        expect(controller.isCurrentStageValid, isFalse);

        // Set country and enable country broadcast
        controller.setCountry('IT');
        final state = tester.state(find.byType(EventTargetGroupStage));
        (state as dynamic).onCountryChange('IT');
        await tester.pump();

        // Still invalid without country broadcast enabled
        expect(controller.isCurrentStageValid, isFalse);

        // Enable country broadcast
        final countryCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutto il paese');
        await tester.tap(countryCheckbox);
        await tester.pump();

        // Should now be valid (country selected + country broadcast enabled)
        expect(controller.isCurrentStageValid, isTrue);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('validation works correctly for ispettoria broadcast', (WidgetTester tester) async {
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
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // Set country and ispettoria
        final state = tester.state(find.byType(EventTargetGroupStage));
        (state as dynamic).onCountryChange('IT');
        (state as dynamic).onIspettoriaChange('Triveneto');
        await tester.pump();

        // Should be invalid without ispettoria broadcast enabled (needs group too)
        expect(controller.isCurrentStageValid, isFalse);

        // Enable ispettoria broadcast
        final ispettoriaCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutta l\'ispetttoria');
        await tester.tap(ispettoriaCheckbox);
        await tester.pump();

        // Should now be valid (country + ispettoria selected + ispettoria broadcast enabled)
        expect(controller.isCurrentStageValid, isTrue);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('validation works correctly for specific group selection', (WidgetTester tester) async {
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
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // Set all three selections
        final state = tester.state(find.byType(EventTargetGroupStage));
        (state as dynamic).onCountryChange('IT');
        await tester.pump();

        // Still invalid with only country
        expect(controller.isCurrentStageValid, isFalse);

        (state as dynamic).onIspettoriaChange('Triveneto');
        await tester.pump();

        // Still invalid with only country and ispettoria
        expect(controller.isCurrentStageValid, isFalse);

        (state as dynamic).onGroupChange('Sesto');
        await tester.pump();

        // Should now be valid (all three selected, no broadcast)
        expect(controller.isCurrentStageValid, isTrue);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('controller updates correctly when selections change', (WidgetTester tester) async {
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
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventTargetGroupStage));
        
        // Test country change
        (state as dynamic).onCountryChange('FR');
        expect(controller.getCountry(), equals('FR'));
        
        // Test ispettoria change
        (state as dynamic).onIspettoriaChange('Paris');
        expect(controller.getIspettoria(), equals('Paris'));
        
        // Test group change
        (state as dynamic).onGroupChange('Lyon');
        expect(controller.getGroup(), equals('Lyon'));
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('controller broadcast flags update correctly', (WidgetTester tester) async {
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
            home: Scaffold(
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // Initially both should be false
        expect(controller.isCountryBroadcast, isFalse);
        expect(controller.isIspettoriaBroadcast, isFalse);

        // Enable country broadcast
        final countryCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutto il paese');
        await tester.tap(countryCheckbox);
        await tester.pump();

        expect(controller.isCountryBroadcast, isTrue);
        expect(controller.isIspettoriaBroadcast, isFalse);

        // Disable country broadcast and enable ispettoria broadcast
        await tester.tap(countryCheckbox);
        await tester.pump();
        
        final ispettoriaCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutta l\'ispetttoria');
        await tester.tap(ispettoriaCheckbox);
        await tester.pump();

        expect(controller.isCountryBroadcast, isFalse);
        expect(controller.isIspettoriaBroadcast, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('country broadcast clears ispettoria and group selections', (WidgetTester tester) async {
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
            home: Scaffold(
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // First set all selections
        final state = tester.state(find.byType(EventTargetGroupStage));
        (state as dynamic).onCountryChange('IT');
        (state as dynamic).onIspettoriaChange('Triveneto');
        (state as dynamic).onGroupChange('Sesto');
        await tester.pump();

        // Verify selections are set
        expect(controller.getCountry(), equals('IT'));
        expect(controller.getIspettoria(), equals('Triveneto'));
        expect(controller.getGroup(), equals('Sesto'));

        // Enable country broadcast
        final countryCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutto il paese');
        await tester.tap(countryCheckbox);
        await tester.pump();

        // Country should remain, but ispettoria and group should be cleared
        expect(controller.getCountry(), equals('IT'));
        expect(controller.getIspettoria(), isNull);
        expect(controller.getGroup(), isNull);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('ispettoria broadcast clears group selection but keeps country', (WidgetTester tester) async {
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
            home: Scaffold(
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // First set all selections
        final state = tester.state(find.byType(EventTargetGroupStage));
        (state as dynamic).onCountryChange('IT');
        (state as dynamic).onIspettoriaChange('Triveneto');
        (state as dynamic).onGroupChange('Sesto');
        await tester.pump();

        // Enable ispettoria broadcast
        final ispettoriaCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutta l\'ispetttoria');
        await tester.tap(ispettoriaCheckbox);
        await tester.pump();

        // Country and ispettoria should remain, but group should be cleared
        expect(controller.getCountry(), equals('IT'));
        expect(controller.getIspettoria(), equals('Triveneto'));
        expect(controller.getGroup(), isNull);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('mutually exclusive broadcast checkboxes', (WidgetTester tester) async {
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
            home: Scaffold(
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        final countryCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutto il paese');
        final ispettoriaCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutta l\'ispetttoria');

        // Enable country broadcast
        await tester.tap(countryCheckbox);
        await tester.pump();

        expect(tester.widget<CheckboxListTile>(countryCheckbox).value, isTrue);
        expect(tester.widget<CheckboxListTile>(ispettoriaCheckbox).value, isFalse);

        // Enable ispettoria broadcast (should disable country broadcast)
        await tester.tap(ispettoriaCheckbox);
        await tester.pump();

        expect(tester.widget<CheckboxListTile>(countryCheckbox).value, isFalse);
        expect(tester.widget<CheckboxListTile>(ispettoriaCheckbox).value, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('initializes with existing controller values', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Pre-set controller values
        controller.setCountry('IT');
        controller.setIspettoria('Triveneto');
        controller.setGroup('Sesto');
        controller.setIspettoriaBroadcast(true);

        await tester.binding.setSurfaceSize(Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        // Should initialize with pre-set values
        expect(controller.getCountry(), equals('IT'));
        expect(controller.getIspettoria(), equals('Triveneto'));
        expect(controller.getGroup(), equals('Sesto'));
        
        // Ispettoria broadcast should be enabled
        final ispettoriaCheckbox = find.widgetWithText(CheckboxListTile, 'Invia a tutta l\'ispetttoria');
        expect(tester.widget<CheckboxListTile>(ispettoriaCheckbox).value, isTrue);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles null values correctly', (WidgetTester tester) async {
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
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventTargetGroupStage));
        
        // Test setting null values
        (state as dynamic).onCountryChange(null);
        (state as dynamic).onIspettoriaChange(null);
        (state as dynamic).onGroupChange(null);
        
        expect(controller.getCountry(), isNull);
        expect(controller.getIspettoria(), isNull);
        expect(controller.getGroup(), isNull);
        
        // Test setting empty strings
        (state as dynamic).onCountryChange('');
        (state as dynamic).onIspettoriaChange('');
        (state as dynamic).onGroupChange('');
        
        expect(controller.getCountry(), isNull);
        expect(controller.getIspettoria(), isNull);
        expect(controller.getGroup(), isNull);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('stage validation updates on each change', (WidgetTester tester) async {
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
              body: EventTargetGroupStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventTargetGroupStage));
        
        // Initially invalid
        expect(controller.isCurrentStageValid, isFalse);
        
        // Add country
        (state as dynamic).onCountryChange('IT');
        expect(controller.isCurrentStageValid, isFalse); // Still invalid
        
        // Add ispettoria
        (state as dynamic).onIspettoriaChange('Triveneto');
        expect(controller.isCurrentStageValid, isFalse); // Still invalid
        
        // Add group
        (state as dynamic).onGroupChange('Sesto');
        expect(controller.isCurrentStageValid, isTrue); // Now valid
        
        // Remove group
        (state as dynamic).onGroupChange(null);
        expect(controller.isCurrentStageValid, isFalse); // Invalid again
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}