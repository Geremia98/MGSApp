import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/back_button_app_bar.dart';
import 'package:mgs_app2/utilities/app_config.dart';

void main() {
  testWidgets('BackButtonAppBar displays icon and calls onTap', (WidgetTester tester) async {
    // Create a mock function for onTap
    bool tapped = false;
    void onTap() {
      tapped = true;
    }

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return BackButtonAppBar(
                iconData: Icons.arrow_back,
                appConfig: AppConfig(context),
                onTap: onTap,
              );
            }
          ),
        ),
      ),
    );

    // Verify that our app bar has the correct icon.
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Tap the button and trigger a frame.
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    // Verify that our onTap callback was called.
    expect(tapped, isTrue);
  });
}
