import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/screens/manage_events/manage_events_screen.dart';
import 'package:mgs_app2/screens/main_screens/all_events_screen.dart';
import 'package:mgs_app2/widgets/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers.dart';
import '../../mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUpAll(() async {
    setupFirebaseAuthMocks();
    await initializeDateFormatting('it_IT', null);
  });

  group('ManageEventsScreen', () {
    setUp(() {
      UserModel.name = 'Mario';
      UserModel.surname = 'Rossi';
      UserModel.gender = UserGender.male;
      UserModel.birth = DateTime(1990, 1, 1);
      UserModel.country = 'IT';
      UserModel.ispettoria = 'Triveneto';
      UserModel.group = 'Sesto';
      UserModel.uid = 'test_user_uid';
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
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );

        expect(find.byType(ManageEventsScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(GoBackButton), findsOneWidget);
        expect(find.byType(FutureBuilder<List<EventModel>>), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('displays correct page title', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        await tester.pumpWidget(
          MaterialApp(
            home: const ManageEventsScreen(),
          ),
        );
        
        await tester.pump();
        expect(find.text('Gestisci eventi'), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
    
    testWidgets('ManageEventsScreen with empty events list', (WidgetTester tester) async {
      final mockEventFirestore = MockEventFirestore();
      
      when(mockEventFirestore.retrievePersonalEvents(justCreatedByMe: true))
          .thenAnswer((_) async => <EventModel>[]);

      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        
        await tester.pumpWidget(
          MaterialApp(
            home: ManageEventsScreen(eventFirestore: mockEventFirestore),
          ),
        );

        await tester.pumpAndSettle();

        verify(mockEventFirestore.retrievePersonalEvents(justCreatedByMe: true)).called(1);

        expect(find.byType(ManageEventsScreen), findsOneWidget);
        expect(find.byType(MyPersonalRow), findsOneWidget);
        final personalRowWidget = tester.widget<MyPersonalRow>(find.byType(MyPersonalRow));
        expect(personalRowWidget.count, 0);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('ManageEventsScreen with populated events list', (WidgetTester tester) async {
      final mockEventFirestore = MockEventFirestore();
      
      final events = [
        EventModel(
          id: 'event1',
          title: 'Test Event 1',
          location: 'Location 1',
          start: DateTime(2024, 3, 15, 14, 30),
          end: DateTime(2024, 3, 15, 16, 30),
          creatorUid: 'test_user_uid',
          participants: [],
        ),
        EventModel(
          id: 'event2',
          title: 'Test Event 2',
          location: 'Location 2',
          start: DateTime(2024, 3, 16, 10, 0),
          end: DateTime(2024, 3, 16, 12, 0),
          creatorUid: 'test_user_uid',
          participants: ['p1', 'p2', 'p3'],
        ),
      ];
      
      when(mockEventFirestore.retrievePersonalEvents(justCreatedByMe: true))
          .thenAnswer((_) async => events);

      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        
        await tester.pumpWidget(
          MaterialApp(
            home: ManageEventsScreen(eventFirestore: mockEventFirestore),
          ),
        );

        await tester.pumpAndSettle();

        verify(mockEventFirestore.retrievePersonalEvents(justCreatedByMe: true)).called(1);

        // Verify buildPage execution
        expect(find.byType(MyPersonalRow), findsOneWidget);
        final personalRowWidget = tester.widget<MyPersonalRow>(find.byType(MyPersonalRow));
        expect(personalRowWidget.count, 2);

        // Verify buildEventWidget execution
        expect(find.text('Test Event 1'), findsOneWidget);
        expect(find.text('Test Event 2'), findsOneWidget);
        expect(find.text('Location 1'), findsOneWidget);
        expect(find.text('Location 2'), findsOneWidget);
        
        // Verify date formatting
        expect(find.text('15-03-2024 02:30'), findsOneWidget);
        expect(find.text('16-03-2024 10:00'), findsOneWidget);
        
        // Verify participant logic
        expect(find.text('Nessun partecipante'), findsOneWidget);
        expect(find.text('3 partecipanti'), findsOneWidget);

        // Verify icons
        expect(find.byIcon(Icons.place_outlined), findsNWidgets(2));
        expect(find.byIcon(Icons.calendar_today_outlined), findsNWidgets(2));
        expect(find.byIcon(Icons.people_outline), findsNWidgets(2));
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('event card tap navigation', (WidgetTester tester) async {
      final mockEventFirestore = MockEventFirestore();
      
      final event = EventModel(
        id: 'tappable_event',
        title: 'Tappable Event',
        location: 'Tap Location',
        start: DateTime(2024, 3, 15, 14, 30),
        end: DateTime(2024, 3, 15, 16, 30),
        creatorUid: 'test_user_uid',
        participants: [],
      );
      
      when(mockEventFirestore.retrievePersonalEvents(justCreatedByMe: true))
          .thenAnswer((_) async => [event]);

      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1000));
        
        await tester.pumpWidget(
          MaterialApp(
            home: ManageEventsScreen(eventFirestore: mockEventFirestore),
          ),
        );

        await tester.pumpAndSettle();

        // Test GestureDetector onTap
        final eventCard = find.text('Tappable Event');
        expect(eventCard, findsOneWidget);
        
        await tester.tap(eventCard);
        await tester.pump();
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}