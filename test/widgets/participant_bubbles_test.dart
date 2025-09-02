import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/participant_bubbles.dart';

void main() {
  testWidgets('ParticipantBubbles displays "0 partecipanti" when there are no participants', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ParticipantBubbles(participants: []),
        ),
      ),
    );

    // Verify that the widget displays "0 partecipanti".
    expect(find.text('0 partecipanti'), findsOneWidget);
  });

  testWidgets('ParticipantBubbles displays one bubble for one participant', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ParticipantBubbles(participants: ['user1']),
        ),
      ),
    );

    // Verify that the widget displays one bubble.
    expect(find.byWidgetPredicate((widget) => widget is Positioned), findsNWidgets(1));
  });

  testWidgets('ParticipantBubbles displays two bubbles for two participants', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ParticipantBubbles(participants: ['user1', 'user2']),
        ),
      ),
    );

    // Verify that the widget displays two bubbles.
    expect(find.byWidgetPredicate((widget) => widget is Positioned), findsNWidgets(2));
  });

  testWidgets('ParticipantBubbles displays three bubbles for three or more participants', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ParticipantBubbles(participants: ['user1', 'user2', 'user3']),
        ),
      ),
    );

    // Verify that the widget displays three bubbles.
    expect(find.byWidgetPredicate((widget) => widget is Positioned), findsNWidgets(3));
    expect(find.text('+1'), findsOneWidget);
  });
}
