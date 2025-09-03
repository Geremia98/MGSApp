import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_squared_icon_button.dart';

void main() {
  testWidgets('MySquaredIconButton displays icon and calls onTap', (WidgetTester tester) async {
    // Create a mock function for onTap
    bool tapped = false;
    void onTap() {
      tapped = true;
    }

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MySquaredIconButton(
            icon: Icons.add,
            onTap: onTap,
            isEnable: true,
            activeColor: Colors.blue,
            disabledColor: Colors.grey,
          ),
        ),
      ),
    );

    // Verify that our button has the correct icon.
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the button and trigger a frame.
    await tester.tap(find.byType(MySquaredIconButton));
    await tester.pump();

    // Verify that our onTap callback was called.
    expect(tapped, isTrue);
  });

  testWidgets('MySquaredIconButton is disabled when isEnable is false', (WidgetTester tester) async {
    // Create a mock function for onTap
    bool tapped = false;
    void onTap() {
      tapped = true;
    }

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MySquaredIconButton(
            icon: Icons.add,
            onTap: onTap,
            isEnable: false,
            activeColor: Colors.blue,
            disabledColor: Colors.grey,
          ),
        ),
      ),
    );

    // The button should be disabled.
    final button = tester.widget<MySquaredIconButton>(find.byType(MySquaredIconButton));
    expect(button.isEnable, isFalse);

    // Verify that onTap is not called
    await tester.tap(find.byType(MySquaredIconButton));
    await tester.pump();
    expect(tapped, isFalse);
  });
}
