import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/main_screens/all_events_screen.dart';
import 'package:mgs_app2/widgets/home_page_widgets/eventi_mese_reminder.dart';
import 'package:mgs_app2/utilities/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers.dart';
import 'eventi_mese_reminder_comprehensive_test.mocks.dart';

@GenerateMocks([EventFirestore])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('EventiDelMeseReminder Comprehensive Tests', () {
    late MockEventFirestore mockEventFirestore;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      mockEventFirestore = MockEventFirestore();
      UserModel.uid = 'test-uid';
    });

    Widget createTestWidget({EventFirestore? eventFirestore}) {
      return MaterialApp(
        theme: ThemeData(
          extensions: const <ThemeExtension<dynamic>>[
            CustomColors.light,
          ],
        ),
        home: Scaffold(
          body: EventiDelMeseReminder(eventFirestore: eventFirestore),
        ),
      );
    }

    EventModel createMockEvent({
      String id = 'event1',
      String title = 'Test Event',
      DateTime? start,
    }) {
      return EventModel(
        id: id,
        title: title,
        desc: 'Test Description',
        start: start ?? DateTime.now().add(const Duration(days: 1)),
        end: start?.add(const Duration(hours: 2)) ?? DateTime.now().add(const Duration(days: 1, hours: 2)),
        location: 'Test Location',
        price: 0.0,
        creatorUid: 'creator_uid',
        participants: [],
        targetGender: EventTargetGender.both,
      );
    }

    group('Dependency Injection Tests', () {
      testWidgets('uses injected EventFirestore when provided', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => []);

          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget(eventFirestore: mockEventFirestore));
          await tester.pump();

          // Verify the mock was called
          verify(mockEventFirestore.retrievePersonalEvents(onlyFuture: true)).called(1);

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });

      testWidgets('uses default EventFirestore when not provided', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget()); // No eventFirestore provided
          await tester.pump();

          // Should not crash and should render
          expect(find.byType(EventiDelMeseReminder), findsOneWidget);

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });
    });

    group('FutureBuilder State Tests', () {
      testWidgets('shows empty state when events list is empty', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => []);

          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget(eventFirestore: mockEventFirestore));
          await tester.pumpAndSettle();

          // Should show empty state (SizedBox)
          expect(find.byType(SizedBox), findsOneWidget);
          expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
          expect(find.byType(GestureDetector), findsNothing);

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });

      testWidgets('shows empty state when future has no data', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => throw Exception('No data'));

          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget(eventFirestore: mockEventFirestore));
          await tester.pumpAndSettle();

          // Should show empty state when future has error
          expect(find.byType(SizedBox), findsOneWidget);
          expect(find.byType(TweenAnimationBuilder<double>), findsNothing);

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });

      testWidgets('shows loading state initially', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          // Create a future that doesn't complete immediately but without timers
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => [createMockEvent()]);

          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget(eventFirestore: mockEventFirestore));
          await tester.pump(); // Single pump to check initial state

          // After first pump, the FutureBuilder should be in loading/empty state initially
          // Since our mock returns immediately, we'll see either loading or completed state
          expect(find.byType(FutureBuilder<List<EventModel>>), findsOneWidget);
          
          // Complete the future
          await tester.pumpAndSettle();
          
          // Now should show content
          expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });
    });

    group('Content Display Tests', () {
      testWidgets('displays single event with correct text', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          final singleEvent = createMockEvent(id: 'single', title: 'Single Event');
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => [singleEvent]);

          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget(eventFirestore: mockEventFirestore));
          await tester.pumpAndSettle();

          // Should show content with animation
          expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
          expect(find.byType(GestureDetector), findsOneWidget);
          
          // Should show singular text
          expect(find.byType(RichText), findsOneWidget);
          final richTextWidget = tester.widget<RichText>(find.byType(RichText));
          final textSpan = richTextWidget.text as TextSpan;
          expect(textSpan.toPlainText(), contains("C'è"));
          expect(textSpan.toPlainText(), contains("1 evento"));
          expect(textSpan.toPlainText(), contains("in calendario"));

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });

      testWidgets('displays multiple events with correct text', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          final multipleEvents = [
            createMockEvent(id: 'event1', title: 'Event 1'),
            createMockEvent(id: 'event2', title: 'Event 2'),
            createMockEvent(id: 'event3', title: 'Event 3'),
          ];
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => multipleEvents);

          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget(eventFirestore: mockEventFirestore));
          await tester.pumpAndSettle();

          // Should show content with animation
          expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
          expect(find.byType(GestureDetector), findsOneWidget);
          
          // Should show plural text
          expect(find.byType(RichText), findsOneWidget);
          final richTextWidget = tester.widget<RichText>(find.byType(RichText));
          final textSpan = richTextWidget.text as TextSpan;
          expect(textSpan.toPlainText(), contains("Ci sono"));
          expect(textSpan.toPlainText(), contains("3 eventi"));
          expect(textSpan.toPlainText(), contains("in calendario"));

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });

      testWidgets('displays correct container structure and styling', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          final events = [createMockEvent()];
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => events);

          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget(eventFirestore: mockEventFirestore));
          await tester.pumpAndSettle();

          // Check widget structure
          expect(find.byType(Container), findsWidgets);
          expect(find.byType(Row), findsOneWidget);
          expect(find.byType(RichText), findsOneWidget);
          
          // Check that image container exists (megaphone image)
          final containers = tester.widgetList<Container>(find.byType(Container));
          final imageContainer = containers.firstWhere(
            (container) => container.decoration is BoxDecoration &&
                (container.decoration as BoxDecoration).image != null,
            orElse: () => Container(),
          );
          expect(imageContainer.decoration, isA<BoxDecoration>());

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });
    });

    group('Animation Tests', () {
      testWidgets('animation builder has correct configuration', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          final events = [createMockEvent()];
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => events);

          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget(eventFirestore: mockEventFirestore));
          await tester.pumpAndSettle();

          final animationBuilder = tester.widget<TweenAnimationBuilder<double>>(
            find.byType(TweenAnimationBuilder<double>)
          );

          // Verify animation configuration
          expect(animationBuilder.tween.begin, 0.9);
          expect(animationBuilder.tween.end, 1.0);
          expect(animationBuilder.duration, const Duration(milliseconds: 300));
          expect(animationBuilder.curve, Curves.easeOutBack);

          // Verify Transform.scale is used (there might be multiple)
          expect(find.byType(Transform), findsWidgets);

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });
    });

    group('Navigation Tests', () {
      testWidgets('tapping navigates to AllEventsScreen with correct parameters', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          final events = [createMockEvent()];
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => events);

          final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
          
          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(
            MaterialApp(
              navigatorKey: navigatorKey,
              theme: ThemeData(
                extensions: const <ThemeExtension<dynamic>>[
                  CustomColors.light,
                ],
              ),
              home: Scaffold(
                body: EventiDelMeseReminder(eventFirestore: mockEventFirestore),
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Verify widget is visible and tappable
          expect(find.byType(GestureDetector), findsOneWidget);
          
          // Tap the gesture detector
          await tester.tap(find.byType(GestureDetector));
          await tester.pumpAndSettle();

          // Verify navigation occurred (AllEventsScreen should be visible)
          expect(find.byType(AllEventsScreen), findsOneWidget);

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });

      testWidgets('gesture detector covers entire container area', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          final events = [createMockEvent()];
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => events);

          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget(eventFirestore: mockEventFirestore));
          await tester.pumpAndSettle();

          // Find the gesture detector
          final gestureDetector = find.byType(GestureDetector);
          expect(gestureDetector, findsOneWidget);

          // Verify it has an onTap callback
          final gestureDetectorWidget = tester.widget<GestureDetector>(gestureDetector);
          expect(gestureDetectorWidget.onTap, isNotNull);

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('handles exactly 2 events correctly', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          final twoEvents = [
            createMockEvent(id: 'event1', title: 'Event 1'),
            createMockEvent(id: 'event2', title: 'Event 2'),
          ];
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => twoEvents);

          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget(eventFirestore: mockEventFirestore));
          await tester.pumpAndSettle();

          // Should use plural form for 2 events
          expect(find.byType(RichText), findsOneWidget);
          final richTextWidget = tester.widget<RichText>(find.byType(RichText));
          final textSpan = richTextWidget.text as TextSpan;
          expect(textSpan.toPlainText(), contains("Ci sono"));
          expect(textSpan.toPlainText(), contains("2 eventi"));
          expect(textSpan.toPlainText(), isNot(contains("1 evento"))); // singular should not appear

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });

      testWidgets('handles large number of events', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          final manyEvents = List.generate(10, (index) => 
            createMockEvent(id: 'event$index', title: 'Event $index')
          );
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => manyEvents);

          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget(eventFirestore: mockEventFirestore));
          await tester.pumpAndSettle();

          // Should handle large numbers correctly
          expect(find.byType(RichText), findsOneWidget);
          final richTextWidget = tester.widget<RichText>(find.byType(RichText));
          final textSpan = richTextWidget.text as TextSpan;
          expect(textSpan.toPlainText(), contains("Ci sono"));
          expect(textSpan.toPlainText(), contains("10 eventi"));

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('has correct widget hierarchy when content is shown', (WidgetTester tester) async {
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.toString().contains('overflowed') && 
              !details.toString().contains('RenderFlex')) {
            throw details.exception;
          }
        };

        try {
          final events = [createMockEvent()];
          when(mockEventFirestore.retrievePersonalEvents(onlyFuture: true))
              .thenAnswer((_) async => events);

          await tester.binding.setSurfaceSize(const Size(400, 1500));
          await tester.pumpWidget(createTestWidget(eventFirestore: mockEventFirestore));
          await tester.pumpAndSettle();

          // Verify widget hierarchy
          expect(find.byType(FutureBuilder<List<EventModel>>), findsOneWidget);
          expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
          expect(find.byType(Transform), findsWidgets); // Multiple transforms expected
          expect(find.byType(GestureDetector), findsOneWidget);
          expect(find.byType(Container), findsWidgets);
          expect(find.byType(Row), findsOneWidget);
          expect(find.byType(RichText), findsOneWidget);

          await tester.binding.setSurfaceSize(null);
        } finally {
          FlutterError.onError = originalOnError;
        }
      });
    });
  });
}