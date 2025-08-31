import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/selector.dart';

void main() {
  testWidgets('SelectorStyle displays items and calls onValueChange', (WidgetTester tester) async {
    // Create a mock function for onValueChange
    String? selectedValue;
    void onValueChange(String value) {
      selectedValue = value;
    }

    // Create the items for the selector.
    final items = {
      'item1': 'Item 1',
      'item2': 'Item 2',
    };

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SelectorStyle<String>(
            items,
            null,
            onValueChange: onValueChange,
          ),
        ),
      ),
    );

    // Tap the selector to open the dropdown.
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    // Tap the first item.
    await tester.tap(find.text('Item 1').last);
    await tester.pumpAndSettle();

    // Verify that our onValueChange callback was called.
    expect(selectedValue, 'item1');
  });
}
