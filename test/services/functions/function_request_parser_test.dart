import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/services/functions/function_request_parser.dart';

void main() {
  group('FunctionRequestParser', () {
    group('parseDateTimeToSerializable', () {
      test('converts DateTime to milliseconds since epoch', () {
        final dateTime = DateTime(2023, 12, 25, 10, 30, 45);
        final result = parseDateTimeToSerializable(dateTime);
        
        expect(result, isA<int>());
        expect(result, equals(dateTime.toUtc().millisecondsSinceEpoch));
      });

      test('handles UTC dates correctly', () {
        final utcDate = DateTime.utc(2023, 1, 1, 0, 0, 0);
        final result = parseDateTimeToSerializable(utcDate);
        
        expect(result, equals(utcDate.millisecondsSinceEpoch));
      });

      test('converts local time to UTC before serialization', () {
        final localDate = DateTime(2023, 6, 15, 14, 30, 0);
        final result = parseDateTimeToSerializable(localDate);
        
        expect(result, equals(localDate.toUtc().millisecondsSinceEpoch));
        expect(result, isA<int>());
      });

      test('handles different dates consistently', () {
        final date1 = DateTime(2020, 1, 1);
        final date2 = DateTime(2025, 12, 31);
        
        final result1 = parseDateTimeToSerializable(date1);
        final result2 = parseDateTimeToSerializable(date2);
        
        expect(result1, lessThan(result2));
        expect(result1, isA<int>());
        expect(result2, isA<int>());
      });

      test('produces same result for equivalent dates', () {
        final date1 = DateTime(2023, 5, 10, 12, 0, 0);
        final date2 = DateTime(2023, 5, 10, 12, 0, 0);
        
        final result1 = parseDateTimeToSerializable(date1);
        final result2 = parseDateTimeToSerializable(date2);
        
        expect(result1, equals(result2));
      });

      test('handles epoch date correctly', () {
        final epochDate = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
        final result = parseDateTimeToSerializable(epochDate);
        
        expect(result, equals(0));
      });

      test('handles far future dates', () {
        final futureDate = DateTime(2099, 12, 31, 23, 59, 59);
        final result = parseDateTimeToSerializable(futureDate);
        
        expect(result, isA<int>());
        expect(result, greaterThan(0));
      });
    });

    group('parseRequestDateIntoDateTime', () {
      test('converts request date map to DateTime', () {
        final requestDate = {
          '_seconds': '1703505045',
          '_nanoseconds': '123456789'
        };
        
        final result = parseRequestDateIntoDateTime(requestDate);
        
        expect(result, isA<DateTime>());
        expect(result.millisecondsSinceEpoch, equals(1703505045123));
      });

      test('handles zero nanoseconds correctly', () {
        final requestDate = {
          '_seconds': '1640995200',  // 2022-01-01 00:00:00 UTC
          '_nanoseconds': '0'
        };
        
        final result = parseRequestDateIntoDateTime(requestDate);
        
        expect(result.millisecondsSinceEpoch, equals(1640995200000));
      });

      test('correctly converts nanoseconds to milliseconds', () {
        final requestDate = {
          '_seconds': '1640995200',
          '_nanoseconds': '500000000'  // 500 million nanoseconds = 500 milliseconds
        };
        
        final result = parseRequestDateIntoDateTime(requestDate);
        
        expect(result.millisecondsSinceEpoch, equals(1640995200500));
      });

      test('handles large nanosecond values', () {
        final requestDate = {
          '_seconds': '1640995200',
          '_nanoseconds': '999999999'  // Maximum nanoseconds in a second
        };
        
        final result = parseRequestDateIntoDateTime(requestDate);
        
        expect(result.millisecondsSinceEpoch, equals(1640995200999));
      });

      test('handles string conversion from different object types', () {
        final requestDate = {
          '_seconds': 1640995200,  // Integer instead of string
          '_nanoseconds': 123456789  // Integer instead of string
        };
        
        final result = parseRequestDateIntoDateTime(requestDate);
        
        expect(result, isA<DateTime>());
        expect(result.millisecondsSinceEpoch, equals(1640995200123));
      });

      test('creates correct DateTime from parsed values', () {
        final requestDate = {
          '_seconds': '1672531200',  // 2023-01-01 00:00:00 UTC
          '_nanoseconds': '0'
        };
        
        final result = parseRequestDateIntoDateTime(requestDate);
        final expectedDateTime = DateTime.fromMillisecondsSinceEpoch(1672531200000);
        
        expect(result.millisecondsSinceEpoch, equals(expectedDateTime.millisecondsSinceEpoch));
      });

      test('maintains precision when converting nanoseconds', () {
        final requestDate = {
          '_seconds': '1672531200',
          '_nanoseconds': '123000000'  // Should result in 123 milliseconds
        };
        
        final result = parseRequestDateIntoDateTime(requestDate);
        
        expect(result.millisecondsSinceEpoch % 1000, equals(123));
      });

      test('truncates nanoseconds precision below milliseconds', () {
        final requestDate = {
          '_seconds': '1672531200',
          '_nanoseconds': '123456789'  // Should truncate to 123 milliseconds
        };
        
        final result = parseRequestDateIntoDateTime(requestDate);
        
        expect(result.millisecondsSinceEpoch % 1000, equals(123));
      });
    });

    group('roundtrip conversion', () {
      test('DateTime to serializable and back maintains millisecond precision', () {
        final originalDate = DateTime.utc(2023, 6, 15, 10, 30, 45, 123);
        final serialized = parseDateTimeToSerializable(originalDate);
        final reconstructed = DateTime.fromMillisecondsSinceEpoch(serialized);
        
        expect(reconstructed.millisecondsSinceEpoch, equals(originalDate.millisecondsSinceEpoch));
      });

      test('can convert back and forth between formats', () {
        final originalMillis = 1703505045123;
        final dateTime = DateTime.fromMillisecondsSinceEpoch(originalMillis);
        final serialized = parseDateTimeToSerializable(dateTime);
        
        expect(serialized, equals(originalMillis));
      });
    });
  });
}