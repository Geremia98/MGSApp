import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/screens/main_screens/credit_card_screen.dart';
import 'package:mgs_app2/widgets/button.dart';

void main() {
  group('CreditCardScreen', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CreditCardScreen(),
        ),
      );

      await tester.pump();

      expect(find.byType(CreditCardScreen), findsOneWidget);
    });

    testWidgets('finds CardFormField', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CreditCardScreen(),
        ),
      );

      await tester.pump();

      expect(find.byType(CardFormField), findsOneWidget);
    });

    testWidgets('finds Conferma button and taps it', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CreditCardScreen(),
        ),
      );

      await tester.pump();

      final button = find.widgetWithText(ButtonText, 'Conferma');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();
    });

    testWidgets('finds back button and taps it', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CreditCardScreen(),
        ),
      );

      await tester.pump();

      final backButton = find.byIcon(Icons.arrow_back_rounded);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pump();
    });
  });
}
