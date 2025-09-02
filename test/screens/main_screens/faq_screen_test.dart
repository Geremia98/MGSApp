
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/screens/main_screens/faq_screen.dart';

void main() {
  group('FAQScreen', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FAQScreen(),
        ),
      );

      expect(find.text('FAQ'), findsOneWidget);
      expect(find.byType(FAQList), findsOneWidget);
      expect(find.text('Quello che cerchi non c\'è?'), findsOneWidget);
      expect(find.text('Mandaci una mail'), findsOneWidget);
    });

    testWidgets('tapping back button pops navigator', (WidgetTester tester) async {
      final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const FAQScreen(),
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

      expect(find.byType(FAQScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(FAQScreen), findsNothing);
    });
  });
}
