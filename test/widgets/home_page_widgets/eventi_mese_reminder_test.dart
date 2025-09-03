import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/widgets/home_page_widgets/eventi_mese_reminder.dart';
import '../../test_helpers.dart';

void main() {
  group('EventiDelMeseReminder', () {
    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      UserModel.uid = 'test-uid';
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: EventiDelMeseReminder(),
        ),
      );
    }

    testWidgets('renders correctly with basic structure', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(EventiDelMeseReminder), findsOneWidget);
      expect(find.byType(FutureBuilder<List<EventModel>>), findsOneWidget);
    });

    testWidgets('shows empty state when no events are available', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
    });

    testWidgets('widget builds without throwing exceptions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      expect(tester.takeException(), isNull);
      expect(find.byType(EventiDelMeseReminder), findsOneWidget);
    });
  });
}