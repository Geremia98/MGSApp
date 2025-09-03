import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/selector_for_personal_screen.dart';

void main() {
  testWidgets('SelectorForPersonalScreen displays items and calls onValueChange', (WidgetTester tester) async {
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
          body: SelectorForPersonalScreen<String>(
            items,
            null,
            onValueChange: onValueChange,
            title: 'Test Title',
            isEnable: true,
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
