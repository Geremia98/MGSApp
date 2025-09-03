import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/participant_bubbles.dart';
import '../test_helpers.dart';

void main() {
  group('ParticipantBubbles', () {
    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    testWidgets('creates successfully without participants', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParticipantBubbles(participants: []),
          ),
        ),
      );

      expect(find.byType(ParticipantBubbles), findsOneWidget);
    });

    testWidgets('creates successfully with participants', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParticipantBubbles(participants: ['user1', 'user2']),
          ),
        ),
      );

      expect(find.byType(ParticipantBubbles), findsOneWidget);
    });

    testWidgets('is a StatefulWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParticipantBubbles(participants: []),
          ),
        ),
      );

      final widget = tester.widget<ParticipantBubbles>(find.byType(ParticipantBubbles));
      expect(widget, isA<StatefulWidget>());
    });

    testWidgets('accepts empty participant list', (WidgetTester tester) async {
      const widget = ParticipantBubbles(participants: []);
      expect(widget.participants, isEmpty);
      expect(widget.showText, isTrue);
    });

    testWidgets('accepts participant list with items', (WidgetTester tester) async {
      const participants = ['user1', 'user2', 'user3'];
      const widget = ParticipantBubbles(participants: participants);
      expect(widget.participants, equals(participants));
      expect(widget.participants.length, equals(3));
    });

    testWidgets('accepts optional showText parameter', (WidgetTester tester) async {
      const widget1 = ParticipantBubbles(participants: [], showText: true);
      const widget2 = ParticipantBubbles(participants: [], showText: false);
      
      expect(widget1.showText, isTrue);
      expect(widget2.showText, isFalse);
    });

    testWidgets('has default showText value of true', (WidgetTester tester) async {
      const widget = ParticipantBubbles(participants: []);
      expect(widget.showText, isTrue);
    });

    testWidgets('can be instantiated with key', (WidgetTester tester) async {
      const key = Key('test-key');
      const widget = ParticipantBubbles(key: key, participants: []);
      expect(widget.key, equals(key));
    });

    testWidgets('renders without overflow on different screen sizes', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParticipantBubbles(participants: ['user1', 'user2', 'user3']),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('handles large participant lists', (WidgetTester tester) async {
      final participants = List.generate(10, (index) => 'user$index');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ParticipantBubbles(participants: participants),
          ),
        ),
      );

      expect(find.byType(ParticipantBubbles), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('maintains state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParticipantBubbles(participants: ['user1', 'user2']),
          ),
        ),
      );

      final state = tester.state(find.byType(ParticipantBubbles));
      expect(state, isNotNull);
      expect(state, isA<State<ParticipantBubbles>>());
    });

    testWidgets('renders properly in different container layouts', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                ParticipantBubbles(participants: ['user1']),
                ParticipantBubbles(participants: ['user1', 'user2']),
                ParticipantBubbles(participants: ['user1', 'user2', 'user3']),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ParticipantBubbles), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });
  });
}
