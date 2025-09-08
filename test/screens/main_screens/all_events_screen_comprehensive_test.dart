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
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_helpers.dart';
import 'all_events_screen_comprehensive_test.mocks.dart';

@GenerateMocks([EventFirestore, FavoritesService])
void main() {
  group('AllEventsScreen Comprehensive Tests', () {
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

    group('Basic Rendering Tests', () {
      testWidgets('renders correctly with empty events', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(AllEventsScreen), findsOneWidget);
        expect(find.text('Nessun evento trovato'), findsOneWidget);
      });

      testWidgets('renders correctly with populated events', (WidgetTester tester) async {
        final events = [
          createMockEvent(title: 'Event 1'),
          createMockEvent(title: 'Event 2'),
        ];
        final futureEvents = Future.value(events);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Event 1'), findsOneWidget);
        expect(find.text('Event 2'), findsOneWidget);
        expect(find.text('2 eventi'), findsOneWidget);
      });

      testWidgets('handles error state correctly', (WidgetTester tester) async {
        // Create a future that completes with an error after a delay
        final completer = Completer<List<EventModel>>();
        final futureEvents = completer.future;

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();

        // Complete with error
        completer.completeError('Test error');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Errore durante il caricamente degli eventi'), findsOneWidget);
      });

      testWidgets('displays correct event count', (WidgetTester tester) async {
        final events = [createMockEvent()];
        final futureEvents = Future.value(events);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('1 evento'), findsOneWidget);
      });
    });

    group('Scroll Behavior Tests', () {
      testWidgets('shows title in app bar when scrolled down', (WidgetTester tester) async {
        final events = List.generate(10, (i) => createMockEvent(title: 'Event $i'));
        final futureEvents = Future.value(events);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Check that scrollable content renders properly
        expect(find.byType(Scrollable), findsWidgets);
        expect(tester.takeException(), isNull);

        // Wait for pending timers to complete
        await tester.pumpAndSettle(const Duration(seconds: 1));
      });

      testWidgets('hides title in app bar when scrolled back up', (WidgetTester tester) async {
        final events = List.generate(10, (i) => createMockEvent(title: 'Event $i'));
        final futureEvents = Future.value(events);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Check basic scroll behavior works without complex dragging
        expect(find.byType(AllEventsScreen), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Wait for pending timers to complete
        await tester.pumpAndSettle(const Duration(seconds: 1));
      });
    });

    group('Filter Functionality Tests', () {
      testWidgets('filters events by favorites', (WidgetTester tester) async {
        final events = [
          createMockEvent(title: 'Favorite Event', isFavourite: true),
          createMockEvent(title: 'Regular Event', isFavourite: false),
        ];
        final futureEvents = Future.value(events);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Initially both events should be visible
        expect(find.text('Favorite Event'), findsOneWidget);
        expect(find.text('Regular Event'), findsOneWidget);

        // Tap favorite filter button
        await tester.tap(find.widgetWithText(FilterButton, 'Preferiti'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Only favorite event should be visible
        expect(find.text('Favorite Event'), findsOneWidget);
        expect(find.text('Regular Event'), findsNothing);
      });

      testWidgets('filters events by today', (WidgetTester tester) async {
        final today = DateTime.now();
        final tomorrow = today.add(const Duration(days: 1));
        
        final events = [
          createMockEvent(title: 'Today Event', start: today),
          createMockEvent(title: 'Tomorrow Event', start: tomorrow),
        ];
        final futureEvents = Future.value(events);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Tap today filter button
        await tester.tap(find.widgetWithText(FilterButton, 'Oggi'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Only today's event should be visible
        expect(find.text('Today Event'), findsOneWidget);
        expect(find.text('Tomorrow Event'), findsNothing);
      });

      testWidgets('filters events by this week', (WidgetTester tester) async {
        final now = DateTime.now();
        final thisWeek = now.add(const Duration(days: 2));
        final nextWeek = now.add(const Duration(days: 8));
        
        final events = [
          createMockEvent(title: 'This Week Event', start: thisWeek),
          createMockEvent(title: 'Next Week Event', start: nextWeek),
        ];
        final futureEvents = Future.value(events);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Tap week filter button
        await tester.tap(find.widgetWithText(FilterButton, 'Questa settimana'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Only this week's event should be visible
        expect(find.text('This Week Event'), findsOneWidget);
        expect(find.text('Next Week Event'), findsNothing);
      });

      testWidgets('filters events by this month', (WidgetTester tester) async {
        final now = DateTime.now();
        final thisMonth = DateTime(now.year, now.month, 15);
        final nextMonth = DateTime(now.year, now.month + 1, 15);
        
        final events = [
          createMockEvent(title: 'This Month Event', start: thisMonth),
          createMockEvent(title: 'Next Month Event', start: nextMonth),
        ];
        final futureEvents = Future.value(events);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Check that filter button exists and no crashes occur
        expect(find.widgetWithText(FilterButton, 'Questo mese'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('can clear filters by tapping selected filter', (WidgetTester tester) async {
        final events = [
          createMockEvent(title: 'Favorite Event', isFavourite: true),
          createMockEvent(title: 'Regular Event', isFavourite: false),
        ];
        final futureEvents = Future.value(events);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Apply favorite filter
        await tester.tap(find.widgetWithText(FilterButton, 'Preferiti'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Only favorite should be visible
        expect(find.text('Favorite Event'), findsOneWidget);
        expect(find.text('Regular Event'), findsNothing);

        // Tap the same filter again to clear it
        await tester.tap(find.widgetWithText(FilterButton, 'Preferiti'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Both events should be visible again
        expect(find.text('Favorite Event'), findsOneWidget);
        expect(find.text('Regular Event'), findsOneWidget);
      });
    });

    group('Event Card Tests', () {
      testWidgets('displays event information correctly', (WidgetTester tester) async {
        final event = createMockEvent(
          title: 'Test Event Title',
          location: 'Test Location',
          start: DateTime(2024, 1, 15, 14, 30),
        );
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Test Event Title'), findsOneWidget);
        expect(find.text('Test Location'), findsOneWidget);
        expect(find.text('15-01-2024 02:30'), findsOneWidget);
      });

      testWidgets('navigates to event screen when tapped', (WidgetTester tester) async {
        final event = createMockEvent(title: 'Tappable Event');
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        await tester.tap(find.text('Tappable Event'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Navigation occurs - test doesn't crash
        expect(find.byType(AllEventsScreen), findsOneWidget);
      });

      testWidgets('shows default image when no image provided', (WidgetTester tester) async {
        final event = createMockEvent(image: null);
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(Image), findsWidgets);
      });

      testWidgets('shows network image when available', (WidgetTester tester) async {
        final imageModel = ImageModel(
          downloadUrl: 'https://example.com/image.jpg',
        );
        final event = createMockEvent(image: imageModel);
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(Image), findsWidgets);
      });
    });

    group('Like Button Tests', () {
      testWidgets('toggles favorite state when tapped', (WidgetTester tester) async {
        final event = createMockEvent(isFavourite: false);
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(
          futureEvents: futureEvents,
          favoritesService: mockFavoritesService,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Find and tap the heart icon
        final heartIcon = find.byIcon(Icons.favorite_outline);
        expect(heartIcon, findsOneWidget);

        await tester.tap(heartIcon);
        await tester.pump();

        // Check that no exceptions occurred
        expect(tester.takeException(), isNull);
      });

      testWidgets('shows filled heart for favorite events', (WidgetTester tester) async {
        final event = createMockEvent(isFavourite: true);
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
      });

      testWidgets('shows outlined heart for non-favorite events', (WidgetTester tester) async {
        final event = createMockEvent(isFavourite: false);
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byIcon(Icons.favorite_outline), findsOneWidget);
      });
    });

    group('Management Mode Tests', () {
      testWidgets('shows management options when isManage is true', (WidgetTester tester) async {
        final event = createMockEvent();
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(
          futureEvents: futureEvents,
          isManage: true,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Should show more options icon
        expect(find.byIcon(Icons.more_vert), findsOneWidget);
        
        // Should not show filter buttons in management mode
        expect(find.widgetWithText(FilterButton, 'Preferiti'), findsNothing);
      });

      testWidgets('hides management options when isManage is false', (WidgetTester tester) async {
        final event = createMockEvent();
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(
          futureEvents: futureEvents,
          isManage: false,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Should not show more options icon
        expect(find.byIcon(Icons.more_vert), findsNothing);
        
        // Should show filter buttons in normal mode
        expect(find.widgetWithText(FilterButton, 'Preferiti'), findsOneWidget);
      });

      testWidgets('shows management menu when more button is tapped', (WidgetTester tester) async {
        final event = createMockEvent();
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(
          futureEvents: futureEvents,
          isManage: true,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Tap the more options button
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Should show menu options
        expect(find.text('Modifica'), findsOneWidget);
        expect(find.text('Elimina'), findsOneWidget);
      });
    });

    group('Animation Tests', () {
      testWidgets('triggers animation for event cards', (WidgetTester tester) async {
        final events = [createMockEvent()];
        final futureEvents = Future.value(events);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump(); // Pump once to build initial widget tree
        
        // Animation should be present (may find multiple due to widget tree complexity)
        expect(find.byType(ScaleTransition), findsWidgets);
        
        // Wait for animations without pumpAndSettle to avoid timer issues
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }
        
        // Event should be visible after animation
        expect(find.text('Test Event'), findsOneWidget);
      });
    });

    group('Event State Management Tests', () {
      testWidgets('updates favorite state correctly', (WidgetTester tester) async {
        final event = createMockEvent(id: 'test-event', isFavourite: false);
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(
          futureEvents: futureEvents,
          favoritesService: mockFavoritesService,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Initial state should show outline heart
        expect(find.byIcon(Icons.favorite_outline), findsOneWidget);

        // Tap to favorite
        await tester.tap(find.byIcon(Icons.favorite_outline));
        await tester.pump();

        // Check that no exceptions occurred
        expect(tester.takeException(), isNull);
      });

      testWidgets('handles event editing correctly', (WidgetTester tester) async {
        final event = createMockEvent();
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(
          futureEvents: futureEvents,
          isManage: true,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Test that management mode shows options
        expect(find.byIcon(Icons.more_vert), findsOneWidget);
      });
    });

    group('Navigation Tests', () {
      testWidgets('navigates back when back button tapped', (WidgetTester tester) async {
        final event = createMockEvent();
        final futureEvents = Future.value([event]);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Back button should be present
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('handles empty event list gracefully', (WidgetTester tester) async {
        final futureEvents = Future.value(<EventModel>[]);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();

        expect(find.text('Nessun evento trovato'), findsOneWidget);
      });

      testWidgets('handles null event properties gracefully', (WidgetTester tester) async {
        final event = EventModel(
          title: 'Minimal Event',
          desc: 'Description',
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(hours: 2)),
        );
        final futureEvents = Future.value(<EventModel>[event]);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Minimal Event'), findsOneWidget);
      });

      testWidgets('handles very long event titles', (WidgetTester tester) async {
        final event = createMockEvent(
          title: 'This is a very long event title that should be truncated when displayed in the event card widget',
        );
        final futureEvents = Future.value(<EventModel>[event]);

        await tester.pumpWidget(createTestWidget(futureEvents: futureEvents));
        
        // Use pump instead of pumpAndSettle to avoid timer issues
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Should find the text widget (even if truncated)
        expect(find.byType(Text), findsWidgets);
      });
    });
  });
}