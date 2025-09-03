import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/button.dart';

void main() {
  testWidgets('PrimaryButton displays label and calls onPressed', (WidgetTester tester) async {
    // Create a mock function for onPressed
    bool pressed = false;
    void onPressed() {
      pressed = true;
    }

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Test Button',
            onPressed: onPressed,
          ),
        ),
      ),
    );

    // Verify that our button has the correct label.
    expect(find.text('Test Button'), findsOneWidget);

    // Tap the button and trigger a frame.
    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    // Verify that our onPressed callback was called.
    expect(pressed, isTrue);
  });

  testWidgets('PrimaryButton is disabled when onPressed is null', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Test Button',
            onPressed: null,
          ),
        ),
      ),
    );

    // The button should be disabled.
    final button = tester.widget<ButtonText>(find.byType(ButtonText));
    expect(button.isEnabled, isFalse);
  });
}