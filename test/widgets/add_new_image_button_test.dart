
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/utilities/utils.dart';

void main() {
  testWidgets('buildAddNewImageButton builds correctly and handles tap', (WidgetTester tester) async {
    final originalDebugPrint = debugPrint;
    List<String> printedMessages = [];
    debugPrint = (String? message, {int? wrapWidth}) => printedMessages.add(message!);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return buildAddNewImageButton(context, 200, 10, 100);
            },
          ),
        ),
      ),
    );

    expect(find.byType(DottedBorder), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(printedMessages, equals(['Si dovrebbe aggiungere la funzionalità per caricare immagine']));

    debugPrint = originalDebugPrint;
  });
}
