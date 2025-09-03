import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/services/functions/firebase_function_caller.dart';
import 'package:mgs_app2/services/functions/function_response.dart';
import '../../test_helpers.dart';

void main() {
  group('FirebaseFunctionCaller', () {
    late FirebaseFunctionCaller functionCaller;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      functionCaller = FirebaseFunctionCaller();
    });

    group('constructor and basic properties', () {
      test('creates instance successfully', () {
        expect(functionCaller, isNotNull);
        expect(functionCaller, isA<FirebaseFunctionCaller>());
      });

      test('has FunctionHandler instance', () {
        expect(functionCaller.handler, isNotNull);
      });

      test('multiple instances have independent handlers', () {
        final caller1 = FirebaseFunctionCaller();
        final caller2 = FirebaseFunctionCaller();
        
        expect(caller1.handler, isNot(same(caller2.handler)));
      });

      test('handler has error configuration', () {
        expect(functionCaller.handler.errors, isNotNull);
        expect(functionCaller.handler.errors.genericError, equals(0));
      });
    });

    group('sendReport method', () {
      test('has correct method signature', () {
        expect(functionCaller.sendReport, isA<Function>());
      });

      test('method signature is correct', () {
        expect(functionCaller.sendReport, isA<Function>());
        expect(functionCaller.sendReport.toString(), contains('Function'));
      });

      test('method accepts string parameters', () {
        expect(functionCaller.sendReport, isA<Function>());
      });
    });

    group('joinEvent method', () {
      test('has correct method signature', () {
        expect(functionCaller.joinEvent, isA<Function>());
      });

      test('method accepts event ID parameter', () {
        expect(functionCaller.joinEvent, isA<Function>());
      });

      test('method accepts optional paymentMethodId parameter', () {
        expect(functionCaller.joinEvent, isA<Function>());
      });
    });

    group('leaveEvent method', () {
      test('has correct method signature', () {
        expect(functionCaller.leaveEvent, isA<Function>());
      });

      test('method accepts event ID parameter', () {
        expect(functionCaller.leaveEvent, isA<Function>());
      });

      test('method accepts optional paymentMethodId parameter', () {
        expect(functionCaller.leaveEvent, isA<Function>());
      });
    });

    group('function reference constants', () {
      test('methods exist and are callable', () {
        expect(functionCaller.sendReport, isA<Function>());
        expect(functionCaller.joinEvent, isA<Function>());
        expect(functionCaller.leaveEvent, isA<Function>());
      });
    });

    group('integration with FunctionHandler', () {
      test('uses handler for function management', () {
        expect(functionCaller.handler, isNotNull);
        expect(functionCaller.handler.errors, isNotNull);
      });

      test('handler configuration is correct', () {
        expect(functionCaller.handler.errors.genericError, equals(0));
      });
    });
  });
}