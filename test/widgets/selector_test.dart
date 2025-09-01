import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/selector.dart';

void main() {
  group('SelectorStyle', () {
    final Map<String, String> items = {
      'key1': 'Value 1',
      'key2': 'Value 2',
      'key3': 'Value 3',
    };

    testWidgets('displays title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectorStyle<String>(
              items,
              null,
              title: 'Test Title',
              onValueChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('displays hint text when no value is selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectorStyle<String>(
              items,
              null,
              hintText: 'Select a value',
              onValueChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('Select a value'), findsOneWidget);
    });

    testWidgets('displays initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectorStyle<String>(
              items,
              'key2',
              onValueChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('Value 2'), findsOneWidget);
    });

    testWidgets('onValueChange is called when a new value is selected', (WidgetTester tester) async {
      String? selectedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectorStyle<String>(
              items,
              'key1',
              onValueChange: (value) {
                selectedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Value 2').last);
      await tester.pumpAndSettle();

      expect(selectedValue, 'key2');
    });

    testWidgets('dropdown opens when openOnCreate is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectorStyle<String>(
              items,
              null,
              openOnCreate: true,
              onValueChange: (value) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Value 1'), findsOneWidget);
    });

    testWidgets('widget is disabled when isEnable is false', (WidgetTester tester) async {
      String? selectedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectorStyle<String>(
              items,
              'key1',
              isEnable: false,
              onValueChange: (value) {
                selectedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      expect(find.text('Value 2'), findsNothing);
      expect(selectedValue, isNull);
    });

    testWidgets('correctly disables items in the dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectorStyle<String>(
              items,
              'key1',
              disabledItems: ['key2'],
              itemWidget: (key) {
                return DropdownMenuItem<String>(
                  key: ValueKey(key),
                  value: key,
                  enabled: key != 'key2',
                  child: Text(items[key]!),
                );
              },
              onValueChange: (value) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      final dropdownItem = tester.widget<DropdownMenuItem<String>>(find.byKey(const ValueKey('key2')));
      expect(dropdownItem.enabled, isFalse);
    });

    testWidgets('renders custom item widget when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectorStyle<String>(
              items,
              'key1',
              itemWidget: (key) {
                return DropdownMenuItem<String>(
                  key: ValueKey(key),
                  value: key,
                  child: Text('Custom: ${items[key]}'),
                );
              },
              onValueChange: (value) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      expect(find.text('Custom: Value 2'), findsOneWidget);
    });

    testWidgets('updates value when widget is updated with a new initialValue', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectorStyle<String>(
              items,
              'key1',
              onValueChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('Value 1'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectorStyle<String>(
              items,
              'key2',
              onValueChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('Value 2'), findsOneWidget);
    });
  });
}