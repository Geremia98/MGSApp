
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/snackbar.dart';

void main() {
  testWidgets('showSnackBar displays a SnackBar', (WidgetTester tester) async {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    const String snackBarText = 'Hello, SnackBar!';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  final snackBarStyle = SnackBarStyle(context, scaffoldKey);
                  snackBarStyle.showSnackBar(snackBarText);
                },
                child: const Text('Show SnackBar'),
              );
            },
          ),
        ),
      ),
    );

    // Tap the button to show the SnackBar.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Pump to allow the SnackBar to build.

    // The SnackBar is displayed for a certain duration, so we need to pumpAndSettle
    // to wait for it to appear and then disappear.
    // However, since we just want to verify it appears, one pump is enough.
    await tester.pump(const Duration(seconds: 1));


    // Verify that the SnackBar is displayed with the correct text.
    expect(find.text(snackBarText), findsOneWidget);
  });
}

