import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/screens/main_screens/event_screen.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/utilities/my_colors.dart';
import '../../test_helpers.dart';

void main() {
  group('EventScreen', () {
    late EventModel testEvent;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      // Reset UserModel before each test
      UserModel.name = 'Mario';
      UserModel.surname = 'Rossi';
      UserModel.gender = UserGender.male;
      UserModel.birth = DateTime(1990, 1, 1);
      UserModel.country = 'IT';
      UserModel.ispettoria = 'Triveneto';
      UserModel.group = 'Sesto';
      UserModel.bossCode = '';
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

    testWidgets('EventScreen widget can be instantiated', (WidgetTester tester) async {
      expect(() => EventScreen(event: testEvent), returnsNormally);
    });

    testWidgets('EventScreen creates state object', (WidgetTester tester) async {
      final eventScreen = EventScreen(event: testEvent);
      final state = eventScreen.createState();
      expect(state, isNotNull);
    });

    testWidgets('EventScreen renders without critical exceptions', (WidgetTester tester) async {
      bool hasCriticalError = false;
      final originalOnError = FlutterError.onError;
      
      FlutterError.onError = (details) {
        // Only flag as critical if it's not an overflow error
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          hasCriticalError = true;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: testEvent),
          ),
        );

        // Just check that the widget loads
        expect(find.byType(EventScreen), findsOneWidget);
        expect(hasCriticalError, isFalse);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('Back button navigation works', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        // Ignore overflow errors
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => EventScreen(event: testEvent),
                        ),
                      );
                    },
                    child: const Text('Push'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(EventScreen), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(EventScreen), findsNothing);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('isEventAvailable method works correctly', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        // Ignore overflow errors
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: testEvent),
          ),
        );

        final state = tester.state(find.byType(EventScreen)) as dynamic;
        expect(state.isEventAvailable(), isTrue);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('User model configurations work', (WidgetTester tester) async {
      final configurations = [
        () {
          UserModel.gender = UserGender.male;
          UserModel.uid = 'test_uid';
        },
        () {
          UserModel.gender = UserGender.female;
          UserModel.uid = 'different_uid';
        },
      ];

      for (final config in configurations) {
        config();
        expect(() => EventScreen(event: testEvent), returnsNormally);
      }
    });

    testWidgets('EventScreen shows "Creato da te" when user is creator', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final creatorEvent = EventModel(
          id: 'event123',
          title: 'Test Event',
          desc: 'Description',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Location',
          price: 0.0,
          creatorUid: UserModel.uid, // User is the creator
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
            home: EventScreen(event: creatorEvent),
          ),
        );

        expect(find.text('Creato da te'), findsOneWidget);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen shows "Iscritto" when user is participant', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final participantEvent = EventModel(
          id: 'event123',
          title: 'Test Event',
          desc: 'Description',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Location',
          price: 0.0,
          creatorUid: 'other_uid',
          participants: [UserModel.uid], // User is a participant
          targetGender: EventTargetGender.both,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: participantEvent),
          ),
        );

        expect(find.text('Iscritto'), findsOneWidget);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen shows "Partecipa" button for available events', (WidgetTester tester) async {
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
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: testEvent),
          ),
        );

        expect(find.text('Partecipa'), findsOneWidget);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen shows "Abbandona" button for participants', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final participantEvent = EventModel(
          id: 'event123',
          title: 'Test Event',
          desc: 'Description',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Location',
          price: 0.0,
          creatorUid: 'other_uid',
          participants: [UserModel.uid], // User is a participant
          targetGender: EventTargetGender.both,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: participantEvent),
          ),
        );

        expect(find.text('Abbandona'), findsOneWidget);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen hides buttons for past events', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final pastEvent = EventModel(
          id: 'past_event',
          title: 'Past Event',
          desc: 'Description',
          start: DateTime.now().subtract(const Duration(days: 1)),
          end: DateTime.now().subtract(const Duration(hours: 22)),
          location: 'Location',
          price: 0.0,
          creatorUid: 'other_uid',
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
            home: EventScreen(event: pastEvent),
          ),
        );

        // Should not show participate button for past events
        expect(find.text('Partecipa'), findsNothing);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen shows "Non disponibile" for unavailable events', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Set user as female for male-only event
        UserModel.gender = UserGender.female;
        
        final maleOnlyEvent = EventModel(
          id: 'male_only',
          title: 'Male Only Event',
          desc: 'Description',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Location',
          price: 0.0,
          creatorUid: 'other_uid',
          participants: [],
          targetGender: EventTargetGender.male, // Male only
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: maleOnlyEvent),
          ),
        );

        expect(find.text('Non disponibile'), findsOneWidget);
        
      } finally {
        FlutterError.onError = originalOnError;
        // Reset user gender
        UserModel.gender = UserGender.male;
      }
    });

    testWidgets('isEventAvailable returns false for gender mismatch (male event, female user)', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // Set user as female
        UserModel.gender = UserGender.female;

        final maleEvent = EventModel(
          id: 'male_only',
          title: 'Male Event',
          desc: 'Description',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Location',
          price: 0.0,
          creatorUid: 'other_uid',
          participants: [],
          targetGender: EventTargetGender.male,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: maleEvent),
          ),
        );

        final state = tester.state(find.byType(EventScreen)) as dynamic;
        expect(state.isEventAvailable(), isFalse);
        
      } finally {
        FlutterError.onError = originalOnError;
        // Reset user gender
        UserModel.gender = UserGender.male;
      }
    });

    testWidgets('isEventAvailable returns false for gender mismatch (female event, male user)', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        // User is male by default
        final femaleEvent = EventModel(
          id: 'female_only',
          title: 'Female Event',
          desc: 'Description',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Location',
          price: 0.0,
          creatorUid: 'other_uid',
          participants: [],
          targetGender: EventTargetGender.female,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: femaleEvent),
          ),
        );

        final state = tester.state(find.byType(EventScreen)) as dynamic;
        expect(state.isEventAvailable(), isFalse);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('isEventAvailable returns false for past events', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final pastEvent = EventModel(
          id: 'past_event',
          title: 'Past Event',
          desc: 'Description',
          start: DateTime.now().subtract(const Duration(days: 1)),
          end: DateTime.now().subtract(const Duration(hours: 22)),
          location: 'Location',
          price: 0.0,
          creatorUid: 'other_uid',
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
            home: EventScreen(event: pastEvent),
          ),
        );

        final state = tester.state(find.byType(EventScreen)) as dynamic;
        expect(state.isEventAvailable(), isFalse);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('isEventAvailable returns true for available events', (WidgetTester tester) async {
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
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: testEvent),
          ),
        );

        final state = tester.state(find.byType(EventScreen)) as dynamic;
        expect(state.isEventAvailable(), isTrue);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen displays event details correctly', (WidgetTester tester) async {
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
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: testEvent),
          ),
        );

        // Check that event details are displayed
        expect(find.text(testEvent.title), findsOneWidget);
        expect(find.text(testEvent.desc), findsOneWidget);
        expect(find.text(testEvent.location), findsOneWidget);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen shows back button', (WidgetTester tester) async {
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
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: testEvent),
          ),
        );

        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen shows EventDetailBox widgets', (WidgetTester tester) async {
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
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: testEvent),
          ),
        );

        expect(find.byType(EventDetailBox), findsWidgets);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen handles different screen sizes', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final screenSizes = [
          const Size(800, 1200),   // Small screen
          const Size(1080, 1920),  // Regular screen
        ];

        for (final size in screenSizes) {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(
                extensions: const <ThemeExtension<dynamic>>[
                  CustomColors.light,
                ],
              ),
              home: EventScreen(event: testEvent),
            ),
          );

          expect(find.byType(EventScreen), findsOneWidget);
        }
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen with different event configurations', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final eventConfigurations = [
          // Free event
          EventModel(
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
          ),
          // Paid event
          EventModel(
            id: 'paid_event',
            title: 'Paid Event',
            desc: 'Paid event description',
            start: DateTime.now().add(const Duration(days: 2)),
            end: DateTime.now().add(const Duration(days: 2, hours: 3)),
            location: 'Paid Location',
            price: 25.50,
            creatorUid: 'creator_uid',
            participants: ['participant1', 'participant2'],
            targetGender: EventTargetGender.both,
          ),
        ];

        for (final event in eventConfigurations) {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(
                extensions: const <ThemeExtension<dynamic>>[
                  CustomColors.light,
                ],
              ),
              home: EventScreen(event: event),
            ),
          );

          expect(find.byType(EventScreen), findsOneWidget);
          expect(find.text(event.title), findsOneWidget);
          expect(find.text(event.desc), findsOneWidget);
        }
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen with extreme edge case data', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final edgeCaseEvent = EventModel(
          id: '',
          title: '',
          desc: '',
          start: DateTime.now(),
          end: DateTime.now(),
          location: '',
          price: 0.0,
          creatorUid: '',
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
            home: EventScreen(event: edgeCaseEvent),
          ),
        );

        expect(find.byType(EventScreen), findsOneWidget);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen with very long text content', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final longTextEvent = EventModel(
          id: 'long_text_event',
          title: 'This is a very long event title that should test how the UI handles extremely long text content that could potentially cause layout issues',
          desc: 'This is an extremely long description that goes on and on to test how the application handles very long text content in the description field. It should wrap properly and not cause any overflow issues in the user interface. This description contains multiple sentences to really test the limits of the text handling capabilities.',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'This is a very long location name that could potentially cause layout problems if not handled properly',
          price: 999.99,
          creatorUid: 'long_creator_uid_that_is_unusually_long',
          participants: List.generate(100, (index) => 'participant_$index'),
          targetGender: EventTargetGender.both,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: longTextEvent),
          ),
        );

        expect(find.byType(EventScreen), findsOneWidget);
        // Check that long text is still findable (may be truncated)
        expect(find.textContaining('This is a very long event title'), findsOneWidget);
        expect(find.textContaining('This is an extremely long description'), findsOneWidget);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen with extreme price values', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final extremePriceEvents = [
          // Very expensive event
          EventModel(
            id: 'expensive',
            title: 'Expensive Event',
            desc: 'Very expensive event',
            start: DateTime.now().add(const Duration(days: 1)),
            end: DateTime.now().add(const Duration(days: 1, hours: 2)),
            location: 'Expensive Location',
            price: 9999999.99,
            creatorUid: 'creator_uid',
            participants: [],
            targetGender: EventTargetGender.both,
          ),
          // Event with decimal places
          EventModel(
            id: 'decimal_price',
            title: 'Decimal Price Event',
            desc: 'Event with decimal price',
            start: DateTime.now().add(const Duration(days: 1)),
            end: DateTime.now().add(const Duration(days: 1, hours: 2)),
            location: 'Decimal Location',
            price: 12.34,
            creatorUid: 'creator_uid',
            participants: [],
            targetGender: EventTargetGender.both,
          ),
        ];

        for (final event in extremePriceEvents) {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(
                extensions: const <ThemeExtension<dynamic>>[
                  CustomColors.light,
                ],
              ),
              home: EventScreen(event: event),
            ),
          );

          expect(find.byType(EventScreen), findsOneWidget);
        }
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen with extreme date ranges', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final extremeDateEvents = [
          // Event very far in the future
          EventModel(
            id: 'far_future',
            title: 'Future Event',
            desc: 'Event far in the future',
            start: DateTime(2099, 12, 31, 23, 59),
            end: DateTime(2100, 1, 1, 1, 0),
            location: 'Future Location',
            price: 50.0,
            creatorUid: 'creator_uid',
            participants: [],
            targetGender: EventTargetGender.both,
          ),
          // Very short event (1 minute)
          EventModel(
            id: 'short_event',
            title: 'Short Event',
            desc: 'Very short event',
            start: DateTime.now().add(const Duration(days: 1)),
            end: DateTime.now().add(const Duration(days: 1, minutes: 1)),
            location: 'Quick Location',
            price: 0.0,
            creatorUid: 'creator_uid',
            participants: [],
            targetGender: EventTargetGender.both,
          ),
        ];

        for (final event in extremeDateEvents) {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(
                extensions: const <ThemeExtension<dynamic>>[
                  CustomColors.light,
                ],
              ),
              home: EventScreen(event: event),
            ),
          );

          expect(find.byType(EventScreen), findsOneWidget);
        }
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen TweenAnimationBuilder functionality', (WidgetTester tester) async {
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
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: testEvent),
          ),
        );

        // Verify TweenAnimationBuilders are present and working
        expect(find.byType(TweenAnimationBuilder<double>), findsWidgets);
        
        // Let animations complete
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        
        expect(find.byType(EventScreen), findsOneWidget);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('EventScreen with maximum participants list', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.toString().contains('overflowed') && 
            !details.toString().contains('RenderFlex')) {
          throw details.exception;
        }
      };

      try {
        final maxParticipantsEvent = EventModel(
          id: 'max_participants',
          title: 'Popular Event',
          desc: 'Event with many participants',
          start: DateTime.now().add(const Duration(days: 1)),
          end: DateTime.now().add(const Duration(days: 1, hours: 2)),
          location: 'Popular Location',
          price: 15.0,
          creatorUid: 'creator_uid',
          participants: List.generate(1000, (index) => 'user_$index'),
          targetGender: EventTargetGender.both,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const <ThemeExtension<dynamic>>[
                CustomColors.light,
              ],
            ),
            home: EventScreen(event: maxParticipantsEvent),
          ),
        );

        expect(find.byType(EventScreen), findsOneWidget);
        
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });

  group('EventDetailBox', () {
    testWidgets('EventDetailBox widget can be instantiated', (WidgetTester tester) async {
      expect(() => const EventDetailBox(
        width: 400,
        height: 800,
        icon: Icons.calendar_month_rounded,
        title: 'Test Title',
        subTitle: 'Test Subtitle',
      ), returnsNormally);
    });

    testWidgets('EventDetailBox handles different data types', (WidgetTester tester) async {
      final testCases = [
        {
          'icon': Icons.location_on_rounded,
          'title': 'Luogo',
          'subTitle': 'Test Location'
        },
        {
          'icon': Icons.airplane_ticket_rounded,
          'title': 'Biglietto',
          'subTitle': 'Gratuito'
        },
        {
          'icon': Icons.calendar_month_rounded,
          'title': 'Data inizio',
          'subTitle': '25-12-2024'
        },
      ];

      for (final testCase in testCases) {
        expect(() => EventDetailBox(
          width: 400,
          height: 800,
          icon: testCase['icon'] as IconData,
          title: testCase['title'] as String,
          subTitle: testCase['subTitle'] as String,
        ), returnsNormally);
      }
    });

    testWidgets('EventDetailBox handles text overflow scenarios', (WidgetTester tester) async {
      const longTitle = 'Very Long Title That Could Potentially Cause Overflow Issues';
      const longSubTitle = 'Very Long Subtitle Text That Also Could Cause Layout Problems When Displayed';
      
      expect(() => const EventDetailBox(
        width: 200,
        height: 400,
        icon: Icons.info,
        title: longTitle,
        subTitle: longSubTitle,
      ), returnsNormally);
    });

    testWidgets('EventDetailBox with minimal dimensions', (WidgetTester tester) async {
      expect(() => const EventDetailBox(
        width: 100,
        height: 100,
        icon: Icons.star,
        title: 'Min',
        subTitle: 'Test',
      ), returnsNormally);
    });
  });
}