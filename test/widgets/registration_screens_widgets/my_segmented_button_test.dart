import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/registration_screens_widgets/my_segmented_button.dart';

void main() {
  testWidgets('MySegmentedButton displays title and options and calls onValueChange', (WidgetTester tester) async {
    // Create a mock function for onValueChange
    Set<String> selectedValue = {'item1'};
    void onValueChange(Set<String> value) {
      selectedValue = value;
    }

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MySegmentedButton<String>(
            title: 'Test Title',
            leftString: 'Item 1',
            rightString: 'Item 2',
            leftValue: 'item1',
            rightValue: 'item2',
            selected: selectedValue,
            onValueChange: onValueChange,
            isEnable: true,
          ),
        ),
      ),
    );

    // Verify that our widget has the correct title and options.
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);

    // Tap the second option.
    await tester.tap(find.text('Item 2'));
    await tester.pump();

    // Verify that our onValueChange callback was called.
    expect(selectedValue, {'item2'});
  });
}
