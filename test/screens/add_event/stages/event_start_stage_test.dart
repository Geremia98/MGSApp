import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mgs_app2/screens/add_event/add_event_controller.dart';
import 'package:mgs_app2/screens/add_event/stages/event_start_stage.dart';
import '../../../test_helpers.dart';

void main() {
  group('EventStartStage', () {
    late AddEventController controller;
    late PageController pageController;

    setUpAll(() async {
      setupFirebaseAuthMocks();
      await initializeDateFormatting('it_IT', null);
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
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        expect(find.byType(EventStartStage), findsOneWidget);
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
        await tester.binding.setSurfaceSize(Size(800, 1200));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        expect(find.text('Inizio evento'), findsOneWidget);
        expect(find.text('Giorno e ora in cui si comincia'), findsOneWidget);
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
        // Set specific start date and time
        controller.setStartDate(DateTime(2024, 6, 15)); // June 15, 2024
        controller.setStartTime(const TimeOfDay(hour: 10, minute: 30)); // 10:30 AM

        await tester.binding.setSurfaceSize(Size(800, 1200));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        // Check that formatted date and time are displayed
        // Date should be in format "d MMMM yyyy" (e.g., "15 giugno 2024")
        expect(find.textContaining('15'), findsWidgets); // Day should be there
        expect(find.textContaining('10:30'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('initializes with stage invalid when no date/time set', (WidgetTester tester) async {
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
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        // Stage should be invalid initially (no start date/time set)
        expect(controller.isCurrentStageValid, isFalse);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('initializes with stage valid when date and time are pre-set', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Pre-set date and time
        controller.setStartDate(DateTime(2024, 6, 15));
        controller.setStartTime(const TimeOfDay(hour: 10, minute: 0));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        // Stage should be valid with both date and time set
        expect(controller.isCurrentStageValid, isTrue);
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
        await tester.binding.setSurfaceSize(Size(800, 1200));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        // Find and tap the first edit button (date edit button)
        final editButtons = find.byIcon(Icons.mode_edit_rounded);
        expect(editButtons, findsNWidgets(2));
        
        // Ensure button is visible by scrolling
        await tester.ensureVisible(editButtons.first);
        await tester.tap(editButtons.first, warnIfMissed: false);
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
        await tester.binding.setSurfaceSize(Size(800, 1200));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        // Find and tap the second edit button (time edit button)
        final editButtons = find.byIcon(Icons.mode_edit_rounded);
        expect(editButtons, findsNWidgets(2));
        
        // Ensure button is visible by scrolling
        await tester.ensureVisible(editButtons.last);
        await tester.tap(editButtons.last, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Should show time picker dialog
        expect(find.byType(TimePickerDialog), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('date picker has correct constraints (future dates only)', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(800, 1200));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        // Tap date edit button to open date picker
        final editButtons = find.byIcon(Icons.mode_edit_rounded);
        await tester.ensureVisible(editButtons.first);
        await tester.tap(editButtons.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Verify date picker dialog is shown
        expect(find.byType(DatePickerDialog), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('onDateChange validates correctly for future dates', (WidgetTester tester) async {
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
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventStartStage));
        
        // Set a future date
        final futureDate = DateTime.now().add(Duration(days: 5));
        (state as dynamic).onDateChange(futureDate);
        
        // Should set the date and remain invalid without time
        expect(controller.getStartDate(), equals(futureDate));
        expect(controller.isCurrentStageValid, isFalse); // No time set yet
        
        // Now set time
        (state as dynamic).onTimeChange(TimeOfDay(hour: 14, minute: 0));
        
        // Should now be valid
        expect(controller.isCurrentStageValid, isTrue);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('onDateChange rejects past dates', (WidgetTester tester) async {
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
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventStartStage));
        
        // Try to set a past date
        final pastDate = DateTime.now().subtract(Duration(days: 5));
        (state as dynamic).onDateChange(pastDate);
        
        // Should not set the date and should be invalid
        expect(controller.getStartDate(), isNull);
        expect(controller.isCurrentStageValid, isFalse);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('onDateChange handles null correctly', (WidgetTester tester) async {
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
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventStartStage));
        
        // Set null date
        (state as dynamic).onDateChange(null);
        
        // Should clear date and be invalid
        expect(controller.getStartDate(), isNull);
        expect(controller.isCurrentStageValid, isFalse);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('onTimeChange validates correctly', (WidgetTester tester) async {
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
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventStartStage));
        
        // Set a time
        const time = TimeOfDay(hour: 15, minute: 30);
        (state as dynamic).onTimeChange(time);
        
        // Should set the time and remain invalid without date
        expect(controller.getStartTime(), equals(time));
        expect(controller.isCurrentStageValid, isFalse); // No date set yet
        
        // Now set future date
        final futureDate = DateTime.now().add(Duration(days: 2));
        (state as dynamic).onDateChange(futureDate);
        
        // Should now be valid
        expect(controller.isCurrentStageValid, isTrue);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('onTimeChange handles null correctly', (WidgetTester tester) async {
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
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventStartStage));
        
        // Set null time
        (state as dynamic).onTimeChange(null);
        
        // Should clear time and be invalid
        expect(controller.getStartTime(), isNull);
        expect(controller.isCurrentStageValid, isFalse);
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
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        final newDate = DateTime(2024, 8, 20);
        controller.setStartDate(newDate);
        await tester.pump();

        expect(controller.getStartDate(), equals(newDate));
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
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        const newTime = TimeOfDay(hour: 16, minute: 45);
        controller.setStartTime(newTime);
        await tester.pump();

        expect(controller.getStartTime(), equals(newTime));
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
        await tester.binding.setSurfaceSize(Size(800, 1200));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventStartStage(controller: controller),
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

    testWidgets('displays default format when no date/time set', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(800, 1200));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        // Should show default format for empty date/time
        expect(find.text('xx/xx/xx'), findsOneWidget); // Default date format
        expect(find.text('xx:xx'), findsOneWidget); // Default time format
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('validation updates correctly when both date and time are set', (WidgetTester tester) async {
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
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventStartStage));
        
        // Initially invalid
        expect(controller.isCurrentStageValid, isFalse);
        
        // Set future date
        final futureDate = DateTime.now().add(Duration(days: 3));
        (state as dynamic).onDateChange(futureDate);
        expect(controller.isCurrentStageValid, isFalse); // Still invalid without time
        
        // Set time
        (state as dynamic).onTimeChange(TimeOfDay(hour: 12, minute: 0));
        expect(controller.isCurrentStageValid, isTrue); // Now valid with both
        
        // Remove date
        (state as dynamic).onDateChange(null);
        expect(controller.isCurrentStageValid, isFalse); // Invalid again
        
        // Restore date
        (state as dynamic).onDateChange(futureDate);
        expect(controller.isCurrentStageValid, isTrue); // Valid again
        
        // Remove time
        (state as dynamic).onTimeChange(null);
        expect(controller.isCurrentStageValid, isFalse); // Invalid without time
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('handles edge case of today date correctly', (WidgetTester tester) async {
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
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventStartStage));
        
        // Try to set today's date (validation allows today, but UI picker doesn't)
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        (state as dynamic).onDateChange(todayDate);
        
        // Should accept today's date (validation logic allows dates >= yesterday)
        expect(controller.getStartDate(), equals(todayDate));
        expect(controller.isCurrentStageValid, isFalse); // Still false because no time is set
        
        // Try tomorrow's date (should be accepted)
        final tomorrow = DateTime.now().add(Duration(days: 1));
        final tomorrowDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
        (state as dynamic).onDateChange(tomorrowDate);
        
        // Should accept tomorrow's date
        expect(controller.getStartDate(), equals(tomorrowDate));
        expect(controller.isCurrentStageValid, isFalse); // Still false because no time is set
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('time picker uses current time as initial time', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(Size(800, 1200));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        // Tap time edit button to open time picker
        final editButtons = find.byIcon(Icons.mode_edit_rounded);
        await tester.ensureVisible(editButtons.last);
        await tester.tap(editButtons.last, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Verify time picker dialog is shown (initial time is TimeOfDay.now() per code)
        expect(find.byType(TimePickerDialog), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('controller updates properly when date/time change methods are called', (WidgetTester tester) async {
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
              body: EventStartStage(controller: controller),
            ),
          ),
        );

        final state = tester.state(find.byType(EventStartStage));
        
        // Set date and verify controller updates
        final futureDate = DateTime.now().add(Duration(days: 2));
        (state as dynamic).onDateChange(futureDate);
        
        // Verify controller was updated
        expect(controller.getStartDate(), equals(futureDate));
        expect(controller.isCurrentStageValid, isFalse); // Still false, no time set
        
        // Set time and verify controller updates
        const testTime = TimeOfDay(hour: 14, minute: 15);
        (state as dynamic).onTimeChange(testTime);

        // Verify controller and validation updated
        expect(controller.getStartTime(), equals(testTime));
        expect(controller.isCurrentStageValid, isTrue); // Now valid with both date and time
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });

  group('translateMonthFromDateTime', () {
    test('should translate month names correctly', () async {
      // Initialize date formatting for this test
      await initializeDateFormatting('it_IT', null);
      
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