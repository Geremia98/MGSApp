import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/text_field.dart';

void main() {
  testWidgets('PrimaryTextField displays label and can be edited', (WidgetTester tester) async {
    // Create a TextEditingController.
    final controller = TextEditingController();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryTextField(
            labelText: 'Test Label',
            controller: controller,
          ),
        ),
      ),
    );

    // Verify that our text field has the correct label.
    expect(find.text('Test Label'), findsOneWidget);

    // Enter text into the text field.
    await tester.enterText(find.byType(TextFormField), 'test text');

    // Verify that the controller has the correct text.
    expect(controller.text, 'test text');
  });
}
