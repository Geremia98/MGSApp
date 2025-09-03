import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/button.dart';

void main() {
  testWidgets('ButtonIcon displays icon and calls onTap', (WidgetTester tester) async {
    // Create a mock function for onTap
    bool tapped = false;
    void onTap() {
      tapped = true;
    }

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonIcon(
            icon: Icons.add,
            onTap: onTap,
          ),
        ),
      ),
    );

    // Verify that our button has the correct icon.
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the button and trigger a frame.
    await tester.tap(find.byType(ButtonIcon));
    await tester.pump();

    // Verify that our onTap callback was called.
    expect(tapped, isTrue);
  });

  testWidgets('ButtonIcon is disabled when isEnabled is false', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonIcon(
            icon: Icons.add,
            onTap: () {},
            isEnabled: false,
          ),
        ),
      ),
    );

    // The button should be disabled.
    final button = tester.widget<ButtonIcon>(find.byType(ButtonIcon));
    expect(button.isEnabled, isFalse);

    // Verify that onTap is not called
    bool tapped = false;
    final buttonFinder = find.byType(ButtonIcon);
    await tester.tap(buttonFinder);
    await tester.pump();
    expect(tapped, isFalse);
  });

  testWidgets('ButtonIcon shows loading indicator when isLoading is true', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ButtonIcon(
            icon: Icons.add,
            onTap: () {},
            isLoading: true,
          ),
        ),
      ),
    );

    // Verify that the loading indicator is shown.
    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
  });
}
