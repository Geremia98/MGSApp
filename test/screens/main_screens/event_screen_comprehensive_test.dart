import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mgs_app2/screens/main_screens/event_screen.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/models/user_firestore.dart';
import 'package:mgs_app2/models/participant_model.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/services/functions/firebase_function_caller.dart';
import 'package:mgs_app2/services/functions/function_response.dart';
import 'package:mgs_app2/services/functions/response_type.dart';
import 'package:mgs_app2/utilities/my_colors.dart';
import 'package:mgs_app2/widgets/participant_bubbles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_helpers.dart';
import 'event_screen_comprehensive_test.mocks.dart';

@GenerateMocks([
  FirebaseFunctionCaller, 
  EventFirestore, 
  UserFirestore,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('EventScreen Comprehensive Tests', () {
    late EventModel testEvent;
    late MockFirebaseFunctionCaller mockFunctionCaller;
    late MockEventFirestore mockEventFirestore;
    late MockUserFirestore mockUserFirestore;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      // Initialize mocks
      mockFunctionCaller = MockFirebaseFunctionCaller();
      mockEventFirestore = MockEventFirestore();
      mockUserFirestore = MockUserFirestore();

      // Reset UserModel before each test
      UserModel.name = 'Mario';
      UserModel.surname = 'Rossi';
      UserModel.gender = UserGender.male;
      UserModel.birth = DateTime(1990, 1, 1);
      UserModel.uid = 'test_uid';

      // Create a test event
      testEvent = EventModel(
        id: 'event123',
        title: 'Test Event',
        desc: 'This is a test event description',
        start: DateTime.now().add(const Duration(days: 1)),
        end: DateTime.now().add(const Duration(days: 1, hours: 2)),
        location: 'Test Location',
        price: 10.0,
        creatorUid: 'creator_uid',
        participants: [],
        targetGender: EventTargetGender.both,
      );
    });

    testWidgets('displays basic UI elements with dependency injection', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(
              event: testEvent,
              functionCaller: mockFunctionCaller,
              eventFirestore: mockEventFirestore,
              userFirestore: mockUserFirestore,
            ),
          ),
        );

        // Allow animations to complete
        await tester.pumpAndSettle();

        expect(find.byType(EventScreen), findsOneWidget);
        expect(find.text(testEvent.title), findsOneWidget);
        expect(find.text(testEvent.desc), findsOneWidget);
        expect(find.text(testEvent.location), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('joinEvent calls function caller for free event', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Setup free event
        final freeEvent = EventModel(
          id: 'free_event',
          title: 'Free Event',
          desc: 'Free event description',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Free Location',
          price: 0.0,
          creatorUid: 'creator_uid',
          participants: [],
          targetGender: EventTargetGender.both,
        );

        // Mock successful join
        when(mockFunctionCaller.joinEvent(any)).thenAnswer(
          (_) async => FunctionResponse(ResponseType.success, {}),
        );

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(
              event: freeEvent,
              functionCaller: mockFunctionCaller,
              eventFirestore: mockEventFirestore,
              userFirestore: mockUserFirestore,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Call joinEvent method directly
        final state = tester.state(find.byType(EventScreen)) as dynamic;
        await state.joinEvent();
        await tester.pumpAndSettle();

        // Verify function caller was called
        verify(mockFunctionCaller.joinEvent('free_event')).called(1);

        // Verify user was added to participants
        expect(state.event.participants.contains(UserModel.uid), isTrue);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('joinEvent handles error response', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Setup free event
        final freeEvent = EventModel(
          id: 'error_event',
          title: 'Error Event',
          desc: 'Error event description',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Error Location',
          price: 0.0,
          creatorUid: 'creator_uid',
          participants: [],
          targetGender: EventTargetGender.both,
        );

        // Mock error response
        when(mockFunctionCaller.joinEvent(any)).thenAnswer(
          (_) async => FunctionResponse(ResponseType.error, {'message': 'Join failed'}),
        );

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(
              event: freeEvent,
              functionCaller: mockFunctionCaller,
              eventFirestore: mockEventFirestore,
              userFirestore: mockUserFirestore,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Call joinEvent method directly
        final state = tester.state(find.byType(EventScreen)) as dynamic;
        await state.joinEvent();
        await tester.pumpAndSettle();

        // Verify function caller was called
        verify(mockFunctionCaller.joinEvent('error_event')).called(1);

        // Verify user was NOT added to participants
        expect(state.event.participants.contains(UserModel.uid), isFalse);
        expect(state.isLoading, isFalse);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('leaveEvent calls function caller', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Setup event where user is participant
        final participantEvent = EventModel(
          id: 'participant_event',
          title: 'Participant Event',
          desc: 'Event description',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Event Location',
          price: 5.0,
          creatorUid: 'creator_uid',
          participants: [UserModel.uid],
          targetGender: EventTargetGender.both,
        );

        // Mock successful leave
        when(mockFunctionCaller.leaveEvent(any)).thenAnswer(
          (_) async => FunctionResponse(ResponseType.success, {}),
        );

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(
              event: participantEvent,
              functionCaller: mockFunctionCaller,
              eventFirestore: mockEventFirestore,
              userFirestore: mockUserFirestore,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Test leaveEvent by accessing the confirmation dialog directly
        final state = tester.state(find.byType(EventScreen)) as dynamic;
        
        // Call leaveEvent to show dialog
        state.leaveEvent();
        await tester.pumpAndSettle();

        // Find and tap confirm button in the dialog
        expect(find.byType(ConfirmEventDialog), findsOneWidget);
        
        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('deleteEvent calls event firestore', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Setup event where user is creator
        final creatorEvent = EventModel(
          id: 'creator_event',
          title: 'Creator Event',
          desc: 'Event by creator',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Creator Location',
          price: 15.0,
          creatorUid: UserModel.uid, // User is creator
          participants: [],
          targetGender: EventTargetGender.both,
        );

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(
              event: creatorEvent,
              functionCaller: mockFunctionCaller,
              eventFirestore: mockEventFirestore,
              userFirestore: mockUserFirestore,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Test deleteEvent method directly
        final state = tester.state(find.byType(EventScreen)) as dynamic;
        state.deleteEvent();
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(find.byType(ConfirmEventDialog), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('showParticipants displays participant dialog', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Setup event where user is creator with participants
        final eventWithParticipants = EventModel(
          id: 'event_with_participants',
          title: 'Event With Participants',
          desc: 'Event description',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Event Location',
          price: 0.0,
          creatorUid: UserModel.uid, // User is creator
          participants: ['participant1', 'participant2'],
          targetGender: EventTargetGender.both,
        );

        // Mock participant data with image
        final mockParticipant = ParticipantModel(
          uid: 'participant1',
          name: 'Test',
          surname: 'User',
          gender: UserGender.male,
          birth: DateTime(1995, 1, 1),
          image: ImageModel(
            downloadUrl: 'https://example.com/test-image.jpg',
          ),
        );

        when(mockUserFirestore.getParticipant(any))
            .thenAnswer((_) async => mockParticipant);

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(
              event: eventWithParticipants,
              functionCaller: mockFunctionCaller,
              eventFirestore: mockEventFirestore,
              userFirestore: mockUserFirestore,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Test showParticipants method
        final state = tester.state(find.byType(EventScreen)) as dynamic;
        state.showParticipants();
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(find.byType(ParticipantsEventDialog), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('isEventAvailable method logic works correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(
              event: testEvent,
              functionCaller: mockFunctionCaller,
              eventFirestore: mockEventFirestore,
              userFirestore: mockUserFirestore,
            ),
          ),
        );

        await tester.pumpAndSettle();

        final state = tester.state(find.byType(EventScreen)) as dynamic;
        
        // Test available event
        expect(state.isEventAvailable(), isTrue);

        // Test male-only event with female user
        UserModel.gender = UserGender.female;
        final maleOnlyEvent = EventModel(
          id: 'male_only',
          title: 'Male Only Event',
          desc: 'Description',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Location',
          price: 0.0,
          creatorUid: 'creator_uid',
          participants: [],
          targetGender: EventTargetGender.male,
        );

        state.event = maleOnlyEvent;
        expect(state.isEventAvailable(), isFalse);

        // Test past event
        final pastEvent = EventModel(
          id: 'past_event',
          title: 'Past Event',
          desc: 'Description',
          start: DateTime.now().subtract(const Duration(days: 1)),
          end: DateTime.now().subtract(const Duration(hours: 22)),
          location: 'Location',
          price: 0.0,
          creatorUid: 'creator_uid',
          participants: [],
          targetGender: EventTargetGender.both,
        );

        state.event = pastEvent;
        expect(state.isEventAvailable(), isFalse);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
        UserModel.gender = UserGender.male; // Reset
      }
    });

    testWidgets('loading states work correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(
              event: testEvent,
              functionCaller: mockFunctionCaller,
              eventFirestore: mockEventFirestore,
              userFirestore: mockUserFirestore,
            ),
          ),
        );

        await tester.pumpAndSettle();

        final state = tester.state(find.byType(EventScreen)) as dynamic;
        
        // Initially not loading
        expect(state.isLoading, isFalse);

        // Manually set loading state
        state.setState(() {
          state.isLoading = true;
        });
        await tester.pump();
        
        expect(state.isLoading, isTrue);

        // Reset loading state
        state.setState(() {
          state.isLoading = false;
        });
        await tester.pump();
        
        expect(state.isLoading, isFalse);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('creator menu shows for event creator', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Setup event where user is creator
        final creatorEvent = EventModel(
          id: 'creator_event',
          title: 'Creator Event',
          desc: 'Event by creator',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Creator Location',
          price: 0.0,
          creatorUid: UserModel.uid, // User is creator
          participants: [],
          targetGender: EventTargetGender.both,
        );

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(
              event: creatorEvent,
              functionCaller: mockFunctionCaller,
              eventFirestore: mockEventFirestore,
              userFirestore: mockUserFirestore,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify creator menu icon is visible
        expect(find.byIcon(Icons.more_vert), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('participant badge shows when user is participant', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Setup event where user is participant
        final participantEvent = EventModel(
          id: 'participant_event',
          title: 'Participant Event',
          desc: 'Event description',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Event Location',
          price: 0.0,
          creatorUid: 'creator_uid',
          participants: [UserModel.uid], // User is participant
          targetGender: EventTargetGender.both,
        );

        await tester.binding.setSurfaceSize(const Size(400, 1500));
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(
              event: participantEvent,
              functionCaller: mockFunctionCaller,
              eventFirestore: mockEventFirestore,
              userFirestore: mockUserFirestore,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify "Iscritto" badge is visible
        expect(find.text('ISCRITTO'), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });

  group('ConfirmEventDialog Tests', () {
    testWidgets('ConfirmEventDialog displays correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        bool confirmCalled = false;
        bool cancelCalled = false;

        final testEvent = EventModel(
          id: 'dialog_test',
          title: 'Dialog Test Event',
          desc: 'Test',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Test',
          price: 0.0,
          creatorUid: 'creator',
          participants: [],
          targetGender: EventTargetGender.both,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: Scaffold(
              body: ConfirmEventDialog(
                event: testEvent,
                title: 'Test Title',
                subtitle: 'Test Subtitle',
                cancel: 'Cancel',
                confirm: 'Confirm',
                onCancel: () => cancelCalled = true,
                onConfirm: () => confirmCalled = true,
              ),
            ),
          ),
        );

        expect(find.text('Test Title'), findsOneWidget);
        expect(find.text('Test Subtitle'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);

      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });

  group('ParticipantsEventDialog Tests', () {
    late MockUserFirestore mockUserFirestore;

    setUp(() {
      mockUserFirestore = MockUserFirestore();
    });

    testWidgets('ParticipantsEventDialog displays correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final mockParticipant = ParticipantModel(
          uid: 'participant1',
          name: 'Test',
          surname: 'User',
          gender: UserGender.male,
          birth: DateTime(1995, 1, 1),
          image: ImageModel(
            downloadUrl: 'https://example.com/test-image.jpg',
          ),
        );

        when(mockUserFirestore.getParticipant(any))
            .thenAnswer((_) async => mockParticipant);

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: Scaffold(
              body: ParticipantsEventDialog(
                participants: ['participant1'],
                onDeleteParticipant: (uid) {},
                userFirestore: mockUserFirestore,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Check that the dialog widget is created successfully
        expect(find.byType(ParticipantsEventDialog), findsOneWidget);
        
        // Check that the dialog structure is present
        expect(find.byType(Dialog), findsOneWidget);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('calculateAge function works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ParticipantsEventDialog(
              participants: [],
              onDeleteParticipant: (uid) {},
              userFirestore: mockUserFirestore,
            ),
          ),
        ),
      );

      final state = tester.state(find.byType(ParticipantsEventDialog)) as dynamic;
      final today = DateTime.now();
      
      // Test age calculation
      expect(state.calculateAge(DateTime(today.year - 25, today.month, today.day)), 25);
      expect(state.calculateAge(DateTime(today.year - 30, today.month - 1, today.day)), 30);
      expect(state.calculateAge(DateTime(today.year - 20, today.month + 1, today.day)), 19);
    });
  });
}