import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_date_picker.dart';

void main() {
  testWidgets('MyDatePicker displays title and date and calls onPressed', (WidgetTester tester) async {
    // Create a mock function for onPressed
    bool pressed = false;
    void onPressed() {
      pressed = true;
    }

    // Create a date for the picker.
    final date = DateTime(2000, 1, 1);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyDatePicker(
            title: 'Test Title',
            birthday: date,
            onPressed: onPressed,
            isEnable: true,
          ),
        ),
      ),
    );

    // Verify that our widget has the correct title and date.
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('1 / 1 / 2000'), findsOneWidget);

    // Tap the edit button.
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    // Verify that our onPressed callback was called.
    expect(pressed, isTrue);
  });
}
