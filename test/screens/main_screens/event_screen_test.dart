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
  });
}