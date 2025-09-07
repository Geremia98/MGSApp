
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mgs_app2/utilities/utils.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('it_IT', null);
  });

  group('Utils', () {
    group('Date and Time Formatting', () {
      test('formatDateToDayMonth formats date correctly', () {
        final date = DateTime(2024, 7, 20);
        expect(formatDateToDayMonth(date), '20 luglio');
      });

      test('formatDateFromDateTime formats date correctly', () {
        final date = DateTime(2024, 7, 20);
        expect(formatDateFromDateTime(date), '20 luglio 2024');
      });

      test('formatTimeFromTimeOfDay formats time correctly', () {
        const time = TimeOfDay(hour: 14, minute: 30);
        expect(formatTimeFromTimeOfDay(time), '14:30');
      });

      test('formatTimeFromDateTime formats time correctly', () {
        final date = DateTime(2024, 7, 20, 14, 30);
        expect(formatTimeFromDateTime(date), '14 : 30');
      });

       test('formatTimeFromDateTime formats time correctly with leading zeros', () {
        final date = DateTime(2024, 7, 20, 8, 5);
        expect(formatTimeFromDateTime(date), '08 : 05');
      });

      test('formatTimeFromDateTime formats time correctly with leading zero for hour', () {
        final date = DateTime(2024, 7, 20, 8, 15);
        expect(formatTimeFromDateTime(date), '08 : 15');
      });
    });

    group('String Obfuscation', () {
      test('obscureExceptLast obscures string correctly', () {
        expect(obscureExceptLast('1234567890'), '********90');
      });

      test('obscureExceptLast with custom visible length', () {
        expect(obscureExceptLast('1234567890', visible: 4), '******7890');
      });

      test('obscureExceptLast with short string', () {
        expect(obscureExceptLast('12'), '12');
      });
    });
  });
}
