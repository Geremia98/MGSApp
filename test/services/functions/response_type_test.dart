import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/services/functions/response_type.dart';

void main() {
  group('ResponseType', () {
    test('has correct enum values', () {
      expect(ResponseType.values, hasLength(2));
      expect(ResponseType.values, contains(ResponseType.success));
      expect(ResponseType.values, contains(ResponseType.error));
    });

    test('success enum value properties', () {
      expect(ResponseType.success, isA<ResponseType>());
      expect(ResponseType.success.toString(), equals('ResponseType.success'));
      expect(ResponseType.success.index, equals(0));
    });

    test('error enum value properties', () {
      expect(ResponseType.error, isA<ResponseType>());
      expect(ResponseType.error.toString(), equals('ResponseType.error'));
      expect(ResponseType.error.index, equals(1));
    });

    test('enum values are distinct', () {
      expect(ResponseType.success, isNot(equals(ResponseType.error)));
      expect(ResponseType.success != ResponseType.error, isTrue);
    });

    test('can be used in switch statements', () {
      String result = '';
      switch (ResponseType.success) {
        case ResponseType.success:
          result = 'success';
          break;
        case ResponseType.error:
          result = 'error';
          break;
      }
      expect(result, equals('success'));
    });

    test('can be compared with equality', () {
      const type1 = ResponseType.success;
      const type2 = ResponseType.success;
      const type3 = ResponseType.error;

      expect(type1 == type2, isTrue);
      expect(type1 == type3, isFalse);
      expect(type2 != type3, isTrue);
    });

    test('maintains enum ordering', () {
      expect(ResponseType.success.index < ResponseType.error.index, isTrue);
    });
  });
}