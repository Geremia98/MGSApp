import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/text_form_field_for_personal_screen.dart';
import 'package:mgs_app2/utilities/app_config.dart';

void main() {
  testWidgets('buildMyTextFormField displays label and can be edited', (WidgetTester tester) async {
    // Create a TextEditingController.
    final controller = TextEditingController();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return buildMyTextFormField(
                AppConfig(context),
                labelText: 'Test Label',
                controller: controller,
              );
            }
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
