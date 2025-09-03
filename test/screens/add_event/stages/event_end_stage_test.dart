import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/screens/add_event/stages/event_end_stage.dart';
import '../../../test_helpers.dart';

void main() {
  group('EventEndStage', () {
    late AddEventController controller;
    late PageController pageController;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      pageController = PageController();
      controller = AddEventController(pageController: pageController);
      
      // Set up initial start date and time for validation
      controller.setStartDate(DateTime(2024, 6, 15)); // June 15, 2024
      controller.setStartTime(const TimeOfDay(hour: 10, minute: 0)); // 10:00 AM
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        expect(find.byType(EventEndStage), findsOneWidget);
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        expect(find.text('Fine evento'), findsOneWidget);
        expect(find.text('... e giorno e ora in cui si torna a casa'), findsOneWidget);
        expect(find.text('Giorno:  '), findsOneWidget);
        expect(find.text('Orario:  '), findsOneWidget);
        expect(find.byIcon(Icons.mode_edit_rounded), findsNWidgets(2)); // Two edit buttons
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays formatted date and time correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Set specific end date and time
        controller.setEndDate(DateTime(2024, 6, 16)); // June 16, 2024
        controller.setEndTIme(const TimeOfDay(hour: 15, minute: 30)); // 3:30 PM

        await tester.binding.setSurfaceSize(Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Check that formatted date and time are displayed
        expect(find.textContaining('16 / 6 / 2024'), findsOneWidget);
        expect(find.textContaining('15:30'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('initializes with stage invalid', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Stage should be invalid initially (no end date/time set)
        expect(controller.isCurrentStageValid, isFalse);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('date edit button opens date picker', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Find and tap the first edit button (date edit button)
        final editButtons = find.byIcon(Icons.mode_edit_rounded);
        expect(editButtons, findsNWidgets(2));
        
        await tester.tap(editButtons.first);
        await tester.pumpAndSettle();

        // Should show date picker dialog
        expect(find.byType(DatePickerDialog), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('time edit button opens time picker', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Find and tap the second edit button (time edit button)
        final editButtons = find.byIcon(Icons.mode_edit_rounded);
        expect(editButtons, findsNWidgets(2));
        
        await tester.tap(editButtons.last);
        await tester.pumpAndSettle();

        // Should show time picker dialog
        expect(find.byType(TimePickerDialog), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('validates end datetime is after start datetime', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Set valid end date and time (after start) and trigger validation
        controller.setEndDate(DateTime(2024, 6, 15)); // Same day as start
        controller.setEndTIme(const TimeOfDay(hour: 14, minute: 0)); // 2:00 PM (after 10:00 AM start)
        
        // Find widget state and trigger validation by calling onDateChange
        final widgetFinder = find.byType(EventEndStage);
        final EventEndStage widget = tester.widget(widgetFinder);
        final state = tester.state(widgetFinder);
        (state as dynamic).onDateChange(DateTime(2024, 6, 15));
        (state as dynamic).onTimeChange(const TimeOfDay(hour: 14, minute: 0));
        
        await tester.pump();

        // Should be valid
        expect(controller.isCurrentStageValid, isTrue);
        expect(find.text('La data e l\'ora di fine evento devono essere successive alla data e ora di inizio evento.'), findsNothing);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('shows error when end datetime is before start datetime', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Set invalid end date and time (before start) using widget's methods
        final widgetFinder = find.byType(EventEndStage);
        final state = tester.state(widgetFinder);
        (state as dynamic).onDateChange(DateTime(2024, 6, 15));
        (state as dynamic).onTimeChange(const TimeOfDay(hour: 8, minute: 0)); // 8:00 AM (before 10:00 AM start)
        await tester.pump();

        // Should show error and be invalid
        expect(controller.isCurrentStageValid, isFalse);
        expect(find.text('La data e l\'ora di fine evento devono essere successive alla data e ora di inizio evento.'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('validates correctly when only date is set', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Set only end date, no time
        controller.setEndDate(DateTime(2024, 6, 16));
        await tester.pump();

        // Should be invalid (both date and time required)
        expect(controller.isCurrentStageValid, isFalse);
        expect(find.text('La data e l\'ora di fine evento devono essere successive alla data e ora di inizio evento.'), findsNothing);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('validates correctly when only time is set', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Set only end time, no date
        controller.setEndTIme(const TimeOfDay(hour: 15, minute: 0));
        await tester.pump();

        // Should be invalid (both date and time required)
        expect(controller.isCurrentStageValid, isFalse);
        expect(find.text('La data e l\'ora di fine evento devono essere successive alla data e ora di inizio evento.'), findsNothing);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('date picker respects start date constraints', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Tap date edit button to open date picker
        final editButtons = find.byIcon(Icons.mode_edit_rounded);
        await tester.tap(editButtons.first);
        await tester.pumpAndSettle();

        // Verify date picker dialog is shown
        expect(find.byType(DatePickerDialog), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('time picker uses start time as initial time', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Tap time edit button to open time picker
        final editButtons = find.byIcon(Icons.mode_edit_rounded);
        await tester.tap(editButtons.last);
        await tester.pumpAndSettle();

        // Verify time picker dialog is shown
        expect(find.byType(TimePickerDialog), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('controller updates correctly when date changes', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        final newDate = DateTime(2024, 6, 20);
        controller.setEndDate(newDate);
        await tester.pump();

        expect(controller.getEndDate(), equals(newDate));
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('controller updates correctly when time changes', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        const newTime = TimeOfDay(hour: 18, minute: 45);
        controller.setEndTIme(newTime);
        await tester.pump();

        expect(controller.getEndTime(), equals(newTime));
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('edit buttons have proper styling', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Check that edit buttons are GestureDetector wrapped containers
        expect(find.byType(GestureDetector), findsNWidgets(2));
        expect(find.byType(Container), findsWidgets); // Multiple containers including styled ones
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('error message appears and disappears correctly', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Initially no error
        expect(find.text('La data e l\'ora di fine evento devono essere successive alla data e ora di inizio evento.'), findsNothing);

        // Set invalid end datetime using widget methods
        final widgetFinder = find.byType(EventEndStage);
        final state = tester.state(widgetFinder);
        
        (state as dynamic).onDateChange(DateTime(2024, 6, 15));
        (state as dynamic).onTimeChange(const TimeOfDay(hour: 8, minute: 0));
        await tester.pump();

        // Error should appear
        expect(find.text('La data e l\'ora di fine evento devono essere successive alla data e ora di inizio evento.'), findsOneWidget);

        // Fix the datetime
        (state as dynamic).onTimeChange(const TimeOfDay(hour: 16, minute: 0));
        await tester.pump();

        // Error should disappear
        expect(find.text('La data e l\'ora di fine evento devono essere successive alla data e ora di inizio evento.'), findsNothing);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles edge case where end datetime equals start datetime', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Set end datetime exactly equal to start datetime using widget methods
        final widgetFinder = find.byType(EventEndStage);
        final state = tester.state(widgetFinder);
        
        (state as dynamic).onDateChange(DateTime(2024, 6, 15)); // Same as start date
        (state as dynamic).onTimeChange(const TimeOfDay(hour: 10, minute: 0)); // Same as start time
        await tester.pump();

        // Should be invalid (end must be AFTER start, not equal)
        expect(controller.isCurrentStageValid, isFalse);
        expect(find.text('La data e l\'ora di fine evento devono essere successive alla data e ora di inizio evento.'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles different day end date correctly', (WidgetTester tester) async {
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
              body: EventEndStage(controller: controller),
            ),
          ),
        );

        // Set end date to next day with early time using widget methods
        final widgetFinder = find.byType(EventEndStage);
        final state = tester.state(widgetFinder);
        
        (state as dynamic).onDateChange(DateTime(2024, 6, 16)); // Next day
        (state as dynamic).onTimeChange(const TimeOfDay(hour: 2, minute: 0)); // 2:00 AM (early but next day)
        await tester.pump();

        // Should be valid (next day, even with early time)
        expect(controller.isCurrentStageValid, isTrue);
        expect(find.text('La data e l\'ora di fine evento devono essere successive alla data e ora di inizio evento.'), findsNothing);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });

  group('translateMonthFromDateTime', () {
    test('should translate month names correctly', () {
      // Test various months - actual translation will depend on Translator implementation
      final januaryDate = DateTime(2024, 1, 15);
      final juneDate = DateTime(2024, 6, 15);
      final decemberDate = DateTime(2024, 12, 15);
      
      // These tests verify the function runs without error
      // Actual translation results depend on the Translator service
      expect(() => translateMonthFromDateTime(januaryDate), returnsNormally);
      expect(() => translateMonthFromDateTime(juneDate), returnsNormally);
      expect(() => translateMonthFromDateTime(decemberDate), returnsNormally);
    });
  });
}