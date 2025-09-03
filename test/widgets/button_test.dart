import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/button.dart';

void main() {
  group('ButtonIcon', () {
    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonIcon(
              icon: Icons.add,
              onTap: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    });

    testWidgets('does not call onTap when isEnabled is false', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonIcon(
              icon: Icons.add,
              onTap: () {
                tapped = true;
              },
              isEnabled: false,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ButtonIcon));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('calls onTap when isEnabled is true', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonIcon(
              icon: Icons.add,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ButtonIcon));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('renders the correct icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonIcon(
              icon: Icons.add,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  group('ButtonText', () {
    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonText(
              text: 'Test',
              onTap: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    });

    testWidgets('does not call onTap when isEnabled is false', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonText(
              text: 'Test',
              onTap: () {
                tapped = true;
              },
              isEnabled: false,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ButtonText));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('calls onTap when isEnabled is true', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonText(
              text: 'Test',
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ButtonText));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('renders the correct text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonText(
              text: 'Test',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });
  });

  group('ButtonTextAsTextField', () {
    testWidgets('does not call onTap when isLoading is true', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ButtonTextAsTextField(
                onTap: () {
                  tapped = true;
                },
                isLoading: true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.descendant(of: find.byType(ButtonTextAsTextField), matching: find.byType(GestureDetector)));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('shows error message when hasError is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonTextAsTextField(
              onTap: () {},
              hasError: true,
              error: 'Error',
            ),
          ),
        ),
      );

      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('displays value when it is not null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonTextAsTextField(
              onTap: () {},
              value: 'Value',
            ),
          ),
        ),
      );

      expect(find.text('Value'), findsOneWidget);
    });

    testWidgets('displays hint when value is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonTextAsTextField(
              onTap: () {},
              hint: 'Hint',
            ),
          ),
        ),
      );

      expect(find.text('Hint'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ButtonTextAsTextField(
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.descendant(of: find.byType(ButtonTextAsTextField), matching: find.byType(GestureDetector)));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}