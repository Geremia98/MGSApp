import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/title.dart';

void main() {
  testWidgets('buildTitle displays title and subtitle', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return buildTitle(
                context,
                title: 'Test Title',
                subtitle: 'Test Subtitle',
              );
            }
          ),
        ),
      ),
    );

    // Verify that our title and subtitle are displayed.
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Subtitle'), findsOneWidget);
  });

  testWidgets('buildTitle displays only title when subtitle is empty', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return buildTitle(
                context,
                title: 'Test Title',
              );
            }
          ),
        ),
      ),
    );

    // Verify that our title is displayed and subtitle is not.
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Subtitle'), findsNothing);
  });
}
