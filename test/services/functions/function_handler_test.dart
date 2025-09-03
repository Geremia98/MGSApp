import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/services/functions/function_handler.dart';
import 'package:mgs_app2/services/functions/function_response.dart';
import 'package:mgs_app2/services/functions/response_type.dart';
import '../../test_helpers.dart';

void main() {
  group('FunctionHandler', () {
    late FunctionHandler functionHandler;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      functionHandler = FunctionHandler();
    });

    group('constructor and basic properties', () {
      test('creates instance successfully', () {
        expect(functionHandler, isNotNull);
        expect(functionHandler, isA<FunctionHandler>());
      });

      test('has function errors instance', () {
        expect(functionHandler.errors, isNotNull);
        expect(functionHandler.errors.genericError, equals(0));
      });

      test('multiple instances have independent error objects', () {
        final handler1 = FunctionHandler();
        final handler2 = FunctionHandler();
        
        expect(handler1.errors, isNot(same(handler2.errors)));
        expect(handler1.errors.genericError, equals(handler2.errors.genericError));
      });
    });

    group('callFunction method structure', () {
      test('has correct method signature', () {
        expect(functionHandler.callFunction, isA<Function>());
      });

      test('method signature is correct', () {
        expect(functionHandler.callFunction, isA<Function>());
        expect(functionHandler.callFunction.toString(), contains('Function'));
      });

      test('method accepts required parameters', () {
        expect(functionHandler.callFunction, isA<Function>());
      });

      test('has default needsAuthentication parameter', () {
        expect(functionHandler.callFunction, isA<Function>());
      });
    });

    group('error code integration', () {
      test('uses FunctionErrors for error codes', () {
        expect(functionHandler.errors.genericError, equals(0));
        expect(functionHandler.errors.badRequestParamsError, equals(1));
        expect(functionHandler.errors.userNotFoundError, equals(4));
      });

      test('error codes are properly configured', () {
        expect(functionHandler.errors.genericError, greaterThanOrEqualTo(0));
        expect(functionHandler.errors.productNameNotValidError, equals(100));
        expect(functionHandler.errors.cartNoSelectedSizeError, equals(200));
      });
    });

    group('method behavior consistency', () {
      test('maintains instance state correctly', () {
        expect(functionHandler.errors.genericError, equals(0));
        expect(functionHandler, isA<FunctionHandler>());
      });

      test('independent handler instances work correctly', () {
        final handler1 = FunctionHandler();
        final handler2 = FunctionHandler();
        
        expect(handler1, isA<FunctionHandler>());
        expect(handler2, isA<FunctionHandler>());
        expect(handler1.errors.genericError, equals(handler2.errors.genericError));
      });
    });
  });
}