import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/services/functions/function_response.dart';
import 'package:mgs_app2/services/functions/response_type.dart';

void main() {
  group('FunctionResponse', () {
    group('constructor and basic properties', () {
      test('creates success response correctly', () {
        final response = FunctionResponse(ResponseType.success, {
          'payload': {'data': 'test'}
        });
        
        expect(response, isNotNull);
        expect(response, isA<FunctionResponse>());
        expect(response.getType(), equals(ResponseType.success));
        expect(response.hasError(), isFalse);
      });

      test('creates error response correctly', () {
        final response = FunctionResponse(ResponseType.error, {
          'code': 'TEST_ERROR',
          'message': 'Test error message'
        });
        
        expect(response, isNotNull);
        expect(response, isA<FunctionResponse>());
        expect(response.getType(), equals(ResponseType.error));
        expect(response.hasError(), isTrue);
      });
    });

    group('getResponse method', () {
      test('returns the original response map', () {
        final responseMap = {'key': 'value', 'number': 42};
        final response = FunctionResponse(ResponseType.success, responseMap);
        
        final result = response.getResponse();
        
        expect(result, equals(responseMap));
        expect(result, isA<Map<String, dynamic>>());
      });

      test('returns response correctly', () {
        final responseMap = {'key': 'value'};
        final response = FunctionResponse(ResponseType.success, responseMap);
        
        final result = response.getResponse();
        
        expect(result, containsPair('key', 'value'));
        expect(result, isA<Map<String, dynamic>>());
      });
    });

    group('getType method', () {
      test('returns correct response type for success', () {
        final response = FunctionResponse(ResponseType.success, {});
        expect(response.getType(), equals(ResponseType.success));
      });

      test('returns correct response type for error', () {
        final response = FunctionResponse(ResponseType.error, {});
        expect(response.getType(), equals(ResponseType.error));
      });
    });

    group('hasError method', () {
      test('returns false for success response', () {
        final response = FunctionResponse(ResponseType.success, {});
        expect(response.hasError(), isFalse);
      });

      test('returns true for error response', () {
        final response = FunctionResponse(ResponseType.error, {});
        expect(response.hasError(), isTrue);
      });
    });

    group('getSuccessResponse method', () {
      test('returns success payload as Map', () {
        final payload = {'userId': '123', 'name': 'Test User'};
        final response = FunctionResponse(ResponseType.success, {
          'payload': payload
        });
        
        final result = response.getSuccessResponse();
        
        expect(result, isA<Map<String, dynamic>>());
        expect(result, equals(payload));
      });

      test('handles complex nested payload', () {
        final payload = {
          'user': {
            'id': '123',
            'profile': {
              'name': 'Test',
              'age': 25
            }
          },
          'items': [1, 2, 3]
        };
        final response = FunctionResponse(ResponseType.success, {
          'payload': payload
        });
        
        final result = response.getSuccessResponse();
        
        expect(result['user']['id'], equals('123'));
        expect(result['user']['profile']['name'], equals('Test'));
        expect(result['items'], equals([1, 2, 3]));
      });

      test('creates independent copy of payload', () {
        final payload = {'mutable': 'value'};
        final response = FunctionResponse(ResponseType.success, {
          'payload': payload
        });
        
        final result = response.getSuccessResponse();
        result['mutable'] = 'changed';
        
        expect(payload['mutable'], equals('value'));
      });
    });

    group('getSuccessStringResponse method', () {
      test('returns string payload correctly', () {
        const stringPayload = 'Hello, World!';
        final response = FunctionResponse(ResponseType.success, {
          'payload': stringPayload
        });
        
        final result = response.getSuccessStringResponse();
        
        expect(result, isA<String>());
        expect(result, equals(stringPayload));
      });

      test('handles empty string payload', () {
        final response = FunctionResponse(ResponseType.success, {
          'payload': ''
        });
        
        final result = response.getSuccessStringResponse();
        
        expect(result, equals(''));
      });

      test('handles numeric string payload', () {
        final response = FunctionResponse(ResponseType.success, {
          'payload': '12345'
        });
        
        final result = response.getSuccessStringResponse();
        
        expect(result, equals('12345'));
        expect(result, isA<String>());
      });
    });

    group('getSuccessListResponse method', () {
      test('returns list payload correctly', () {
        final listPayload = ['item1', 'item2', 'item3'];
        final response = FunctionResponse(ResponseType.success, {
          'payload': listPayload
        });
        
        final result = response.getSuccessListResponse();
        
        expect(result, isA<List<Object?>>());
        expect(result, equals(listPayload));
      });

      test('handles empty list payload', () {
        final response = FunctionResponse(ResponseType.success, {
          'payload': []
        });
        
        final result = response.getSuccessListResponse();
        
        expect(result, isEmpty);
        expect(result, isA<List<Object?>>());
      });

      test('handles mixed type list payload', () {
        final listPayload = ['string', 42, true, null, {'key': 'value'}];
        final response = FunctionResponse(ResponseType.success, {
          'payload': listPayload
        });
        
        final result = response.getSuccessListResponse();
        
        expect(result, hasLength(5));
        expect(result[0], equals('string'));
        expect(result[1], equals(42));
        expect(result[2], equals(true));
        expect(result[3], isNull);
        expect(result[4], isA<Map>());
      });

      test('creates independent copy of list', () {
        final listPayload = ['original'];
        final response = FunctionResponse(ResponseType.success, {
          'payload': listPayload
        });
        
        final result = response.getSuccessListResponse();
        result.add('added');
        
        expect(listPayload, hasLength(1));
        expect(result, hasLength(2));
      });
    });

    group('getErrorMessage method', () {
      test('returns error code as string for error response', () {
        final response = FunctionResponse(ResponseType.error, {
          'code': 404,
          'message': 'Not found'
        });
        
        final result = response.getErrorMessage();
        
        expect(result, equals('404'));
      });

      test('returns empty string for success response', () {
        final response = FunctionResponse(ResponseType.success, {
          'payload': {'data': 'test'}
        });
        
        final result = response.getErrorMessage();
        
        expect(result, equals(''));
      });

      test('handles string error codes', () {
        final response = FunctionResponse(ResponseType.error, {
          'code': 'VALIDATION_ERROR',
          'message': 'Invalid input'
        });
        
        final result = response.getErrorMessage();
        
        expect(result, equals('VALIDATION_ERROR'));
      });

      test('handles numeric error codes', () {
        final response = FunctionResponse(ResponseType.error, {
          'code': 500,
          'message': 'Server error'
        });
        
        final result = response.getErrorMessage();
        
        expect(result, equals('500'));
      });

      test('handles null error code', () {
        final response = FunctionResponse(ResponseType.error, {
          'code': null,
          'message': 'Error message'
        });
        
        final result = response.getErrorMessage();
        
        expect(result, equals('null'));
      });
    });

    group('edge cases and error handling', () {
      test('handles missing payload in success response', () {
        final response = FunctionResponse(ResponseType.success, {});
        
        expect(() => response.getSuccessResponse(), throwsA(isA<TypeError>()));
      });

      test('handles missing code in error response', () {
        final response = FunctionResponse(ResponseType.error, {
          'message': 'Error without code'
        });
        
        final result = response.getErrorMessage();
        
        expect(result, equals('null'));
      });

      test('handles empty response map', () {
        final successResponse = FunctionResponse(ResponseType.success, {});
        final errorResponse = FunctionResponse(ResponseType.error, {});
        
        expect(successResponse.getResponse(), isEmpty);
        expect(errorResponse.getResponse(), isEmpty);
        expect(errorResponse.getErrorMessage(), equals('null'));
      });
    });
  });
}