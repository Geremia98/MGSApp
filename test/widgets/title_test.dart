
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/title.dart';

void main() {
  group('buildTitle', () {
    testWidgets('displays title and subtitle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return buildTitle(
                  context,
                  title: 'Test Title',
                  subtitle: 'Test Subtitle',
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
    });

    testWidgets('uses correct text style for title when isSection is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return buildTitle(
                  context,
                  title: 'Test Title',
                  isSection: true,
                );
              },
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Test Title'));
      expect(text.style, textStyleSection(tester.element(find.byType(Scaffold))));
    });

    testWidgets('uses correct text style for title when isSection is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return buildTitle(
                  context,
                  title: 'Test Title',
                  isSection: false,
                );
              },
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Test Title'));
      expect(text.style, textStyleTitle(tester.element(find.byType(Scaffold))));
    });

    testWidgets('hides subtitle when it is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return buildTitle(
                  context,
                  title: 'Test Title',
                  subtitle: '',
                );
              },
            ),
          ),
        ),
      );

      expect(find.text(''), findsNothing);
    });
  });
}
