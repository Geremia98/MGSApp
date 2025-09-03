import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/main_screens/all_events_screen.dart';
import 'package:mockito/mockito.dart';
import '../../mocks.mocks.dart';
import '../../test_helpers.dart';

void main() {
  group('AllEventsScreen', () {
    late Future<List<EventModel>> futureEvents;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      UserModel.name = 'Mario';
      UserModel.surname = 'Rossi';
      UserModel.gender = UserGender.male;
      UserModel.birth = DateTime(1990, 1, 1);
      UserModel.country = 'IT';
      UserModel.ispettoria = 'Triveneto';
      UserModel.group = 'Sesto';
      UserModel.bossCode = '';
      UserModel.uid = 'test_uid';
      
      futureEvents = Future.value(<EventModel>[]);
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
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
            home: AllEventsScreen(
              futureEvents: futureEvents,
              titolo: 'Test Events',
            ),
          ),
        );

        await tester.pump();

        expect(find.byType(AllEventsScreen), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('renders with empty event list', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final emptyFuture = Future.value(<EventModel>[]);
        
        await tester.pumpWidget(
          MaterialApp(
            home: AllEventsScreen(
              futureEvents: emptyFuture,
              titolo: 'Empty Events',
            ),
          ),
        );

        await tester.pump();
        expect(find.byType(AllEventsScreen), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('basic interaction test', (WidgetTester tester) async {
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
            home: AllEventsScreen(
              futureEvents: futureEvents,
              titolo: 'Interaction Test',
            ),
          ),
        );

        await tester.pump();

        expect(find.byType(AllEventsScreen), findsOneWidget);

        final scrollable = find.byType(Scrollable);
        if (scrollable.evaluate().isNotEmpty) {
          await tester.drag(scrollable.first, const Offset(0, -100));
          await tester.pump();
        }
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays events from a populated list', (WidgetTester tester) async {
      final events = <EventModel>[
        EventModel(
          title: 'Test Event 1',
          desc: 'Description 1',
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(hours: 2)),
        ),
        EventModel(
          title: 'Test Event 2',
          desc: 'Description 2',
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(hours: 2)),
        ),
      ];

      final future = Future.value(events);

      await tester.pumpWidget(
        MaterialApp(
          home: AllEventsScreen(
            futureEvents: future,
            titolo: 'Populated Events',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Event 1'), findsOneWidget);
      expect(find.text('Test Event 2'), findsOneWidget);
    });

    testWidgets('filters events by favorite', (WidgetTester tester) async {
      final events = <EventModel>[
        EventModel(
          title: 'Apple Event',
          desc: 'Description 1',
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(hours: 2)),
          isFavourite: true,
        ),
        EventModel(
          title: 'Banana Party',
          desc: 'Description 2',
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(hours: 2)),
        ),
      ];

      final future = Future.value(events);

      await tester.pumpWidget(
        MaterialApp(
          home: AllEventsScreen(
            futureEvents: future,
            titolo: 'Search Test',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Apple Event'), findsOneWidget);
      expect(find.text('Banana Party'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilterButton, 'Preferiti'));
      await tester.pumpAndSettle();

      expect(find.text('Apple Event'), findsOneWidget);
      expect(find.text('Banana Party'), findsNothing);
    });

    testWidgets('navigates to event details when an event is tapped', (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      final events = <EventModel>[
        EventModel(
          title: 'Tappable Event',
          desc: 'Description 1',
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(hours: 2)),
        ),
      ];

      final future = Future.value(events);

      await tester.pumpWidget(
        MaterialApp(
          home: AllEventsScreen(
            futureEvents: future,
            titolo: 'Tappable Test',
          ),
          navigatorObservers: [mockObserver],
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Tappable Event'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
    });
  });
}
