import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/main_screens/all_events_screen.dart';
import 'package:mgs_app2/services/local/favorite_service.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/utilities/my_colors.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:mgs_app2/widgets/participant_bubbles.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_helpers.dart';
import 'all_events_screen_test.mocks.dart';

@GenerateMocks([EventFirestore, FavoritesService])
void main() {
  group('AllEventsScreen Coverage Tests', () {
    late MockEventFirestore mockEventFirestore;
    late MockFavoritesService mockFavoritesService;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      UserModel.uid = 'test-uid';
      mockEventFirestore = MockEventFirestore();
      mockFavoritesService = MockFavoritesService();
    });

    Widget createTestWidget({
      Future<List<EventModel>>? futureEvents,
      String titolo = 'Test Events',
      bool isManage = false,
      EventFirestore? eventFirestore,
      FavoritesService? favoritesService,
    }) {
      return MaterialApp(
        theme: ThemeData(
          extensions: const <ThemeExtension<dynamic>>[
            CustomColors.light,
          ],
        ),
        home: AllEventsScreen(
          futureEvents: futureEvents ?? Future.value(<EventModel>[]),
          titolo: titolo,
          isManage: isManage,
          eventFirestore: eventFirestore,
          favoritesService: favoritesService,
        ),
      );
    }

    EventModel createMockEvent({
      String? id,
      String? title,
      DateTime? start,
      DateTime? end,
      String? location,
      bool isFavourite = false,
      List<String>? participants,
      ImageModel? image,
    }) {
      return EventModel(
        id: id ?? 'event-${DateTime.now().millisecondsSinceEpoch}',
        title: title ?? 'Test Event',
        desc: 'Test Description',
        start: start ?? DateTime.now().add(const Duration(days: 1)),
        end: end ?? DateTime.now().add(const Duration(days: 1, hours: 2)),
        location: location ?? 'Test Location',
        isFavourite: isFavourite,
        participants: participants ?? ['user1', 'user2'],
        image: image,
      );
    }

    testWidgets('renders correctly with events', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        
        final events = [
          createMockEvent(title: 'Test Event 1'),
          createMockEvent(title: 'Test Event 2'),
        ];

        await tester.pumpWidget(createTestWidget(futureEvents: Future.value(events)));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(AllEventsScreen), findsOneWidget);
        expect(find.text('Test Event 1'), findsOneWidget);
        expect(find.text('Test Event 2'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    // Test for month filter logic (lines 176-184)
    testWidgets('triggers month filter code path', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        
        final now = DateTime.now();
        final thisMonth = DateTime(now.year, now.month, 15);
        final nextMonth = DateTime(now.year, now.month + 1, 15);
        
        final events = [
          createMockEvent(title: 'This Month Event', start: thisMonth),
          createMockEvent(title: 'Next Month Event', start: nextMonth),
        ];

        await tester.pumpWidget(createTestWidget(futureEvents: Future.value(events)));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Both events should be visible initially
        expect(find.text('This Month Event'), findsOneWidget);
        expect(find.text('Next Month Event'), findsOneWidget);

        // Try to find and tap the month filter button
        final monthFilter = find.widgetWithText(FilterButton, 'Questo mese');
        if (monthFilter.evaluate().isNotEmpty) {
          await tester.ensureVisible(monthFilter);
          await tester.tap(monthFilter, warnIfMissed: false);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
        }
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    // Test mobile layout by setting smaller screen size
    testWidgets('renders mobile layout', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));

        final events = [
          createMockEvent(title: 'Mobile Event'),
        ];

        await tester.pumpWidget(createTestWidget(futureEvents: Future.value(events)));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Should render the event
        expect(find.text('Mobile Event'), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    // Test management mode (this should trigger lines 647-708)
    testWidgets('shows management mode UI', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        
        final event = createMockEvent(title: 'Manageable Event');

        await tester.pumpWidget(createTestWidget(
          futureEvents: Future.value([event]),
          isManage: true,
          eventFirestore: mockEventFirestore,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Manageable Event'), findsOneWidget);
        // In management mode, should show more options icon
        expect(find.byIcon(Icons.more_vert), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    // Test event card rendering with various UI elements (lines 709-859)
    testWidgets('renders event card UI elements', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));

        final event = createMockEvent(
          title: 'UI Elements Test',
          location: 'Test Location',
          start: DateTime(2024, 1, 15, 14, 30),
        );

        await tester.pumpWidget(createTestWidget(futureEvents: Future.value([event])));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // These should render UI elements from the event cards
        expect(find.text('UI Elements Test'), findsOneWidget);
        expect(find.text('Test Location'), findsOneWidget);
        expect(find.byIcon(Icons.place_outlined), findsOneWidget);
        expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
        expect(find.byType(Image), findsWidgets);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });


    // Simple navigation test (lines 304-313)
    testWidgets('handles event tap', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));

        final event = createMockEvent(title: 'Tappable Event');

        await tester.pumpWidget(createTestWidget(futureEvents: Future.value([event])));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Try to tap the event
        await tester.tap(find.text('Tappable Event'), warnIfMissed: false);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Should not crash
        expect(find.byType(AllEventsScreen), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}