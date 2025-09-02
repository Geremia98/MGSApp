import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/personal_page_widgets/my_big_async_button.dart';
import 'package:mgs_app2/utilities/app_config.dart';

void main() {
  testWidgets('MyBigAsyncButton displays text and calls onPressedAsync', (WidgetTester tester) async {
    // Create a mock function for onPressedAsync
    bool pressed = false;
    Future<void> onPressedAsync() async {
      pressed = true;
    }

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return MyBigAsyncButton(
                appConfig: AppConfig(context),
                onPressedAsync: onPressedAsync,
                buttonText: 'Test Button',
              );
            }
          ),
        ),
      ),
    );

    // Verify that our button has the correct text.
    expect(find.text('Test Button'), findsOneWidget);

    // Tap the button and trigger a frame.
    await tester.tap(find.byType(MyBigAsyncButton));
    await tester.pump();

    // Verify that our onPressedAsync callback was called.
    expect(pressed, isTrue);
  });

  testWidgets('MyBigAsyncButton displays loading indicator', (WidgetTester tester) async {
    // Create a mock function for onPressedAsync that never completes.
    Future<void> onPressedAsync() async {
      await Future.delayed(const Duration(seconds: 1));
    }

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return MyBigAsyncButton(
                appConfig: AppConfig(context),
                onPressedAsync: onPressedAsync,
                buttonText: 'Test Button',
              );
            }
          ),
        ),
      ),
    );

    // Tap the button.
    await tester.tap(find.byType(MyBigAsyncButton));
    await tester.pump();

    // Verify that the loading indicator is displayed.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the future to complete.
    await tester.pumpAndSettle();
  });
}
