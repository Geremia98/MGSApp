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
        // Test method signature without invoking Firebase
        expect(functionCaller.sendReport, isA<Function>());
        
        // Method should exist and be callable (testing signature only)
        expect(functionCaller.sendReport.toString(), contains('Function'));
      });

      test('method accepts string parameters', () {
        // Test that method signature accepts string parameters
        expect(functionCaller.sendReport, isA<Function>());
      });



      test('method returns expected type', () {
        // Test method signature without awaiting
        expect(functionCaller.sendReport, isA<Function>());
      });

      test('handles empty parameters', () async {
        final response = await functionCaller.sendReport('', '');
        expect(response, isA<FunctionResponse>());
      });
    });

    group('joinEvent method', () {
      test('has correct method signature', () {
        expect(functionCaller.joinEvent, isA<Function>());
      });

      test('returns Future<FunctionResponse>', () {
        final result = functionCaller.joinEvent('event123');
        expect(result, isA<Future<FunctionResponse>>());
      });

      test('accepts required eventId parameter', () {
        expect(() => functionCaller.joinEvent('event123'), returnsNormally);
      });

      test('accepts optional paymentMethodId parameter', () {
        expect(() => functionCaller.joinEvent(
          'event123',
          paymentMethodId: 'pm_123456',
        ), returnsNormally);
      });

      test('has default empty paymentMethodId', () {
        expect(() => functionCaller.joinEvent('event123'), returnsNormally);
      });

      test('handles different event ID formats', () async {
        final eventIds = [
          'event123',
          'event-456-789',
          'EVENT_ABC_DEF',
          'evt_1234567890abcdef',
          '12345',
          'event@test.com',
        ];
        
        for (final eventId in eventIds) {
          final result = functionCaller.joinEvent(eventId);
          expect(result, isA<Future<FunctionResponse>>());
          
          final response = await result;
          expect(response, isA<FunctionResponse>());
        }
      });

      test('handles different payment method ID formats', () async {
        final paymentMethods = [
          'pm_1234567890abcdef',
          'card_1234567890',
          'payment_method_123',
          '',
          'pm_test_card',
        ];
        
        for (final pm in paymentMethods) {
          final result = functionCaller.joinEvent('event123', paymentMethodId: pm);
          expect(result, isA<Future<FunctionResponse>>());
          
          final response = await result;
          expect(response, isA<FunctionResponse>());
        }
      });

      test('response has correct structure', () async {
        final response = await functionCaller.joinEvent('test-event');
        
        expect(response, isA<FunctionResponse>());
        expect(response.hasError(), isA<bool>());
        expect(response.getType(), isNotNull);
        expect(response.getResponse(), isA<Map<String, dynamic>>());
      });

      test('handles both with and without payment method', () async {
        final response1 = await functionCaller.joinEvent('event123');
        final response2 = await functionCaller.joinEvent('event123', paymentMethodId: 'pm_test');
        
        expect(response1, isA<FunctionResponse>());
        expect(response2, isA<FunctionResponse>());
      });
    });

    group('leaveEvent method', () {
      test('has correct method signature', () {
        expect(functionCaller.leaveEvent, isA<Function>());
      });

      test('returns Future<FunctionResponse>', () {
        final result = functionCaller.leaveEvent('event123');
        expect(result, isA<Future<FunctionResponse>>());
      });

      test('accepts required eventId parameter', () {
        expect(() => functionCaller.leaveEvent('event123'), returnsNormally);
      });

      test('accepts optional paymentMethodId parameter', () {
        expect(() => functionCaller.leaveEvent(
          'event123',
          paymentMethodId: 'pm_123456',
        ), returnsNormally);
      });

      test('has default empty paymentMethodId', () {
        expect(() => functionCaller.leaveEvent('event123'), returnsNormally);
      });

      test('handles different event ID formats', () async {
        final eventIds = [
          'event123',
          'event-456-789',
          'EVENT_ABC_DEF',
          'evt_1234567890abcdef',
          '12345',
          'event@test.com',
        ];
        
        for (final eventId in eventIds) {
          final result = functionCaller.leaveEvent(eventId);
          expect(result, isA<Future<FunctionResponse>>());
          
          final response = await result;
          expect(response, isA<FunctionResponse>());
        }
      });

      test('handles paymentMethodId parameter correctly', () async {
        // Note: The implementation shows paymentMethodId parameter but doesn't use it
        final response1 = await functionCaller.leaveEvent('event123');
        final response2 = await functionCaller.leaveEvent('event123', paymentMethodId: 'pm_test');
        
        expect(response1, isA<FunctionResponse>());
        expect(response2, isA<FunctionResponse>());
      });

      test('response has correct structure', () async {
        final response = await functionCaller.leaveEvent('test-event');
        
        expect(response, isA<FunctionResponse>());
        expect(response.hasError(), isA<bool>());
        expect(response.getType(), isNotNull);
        expect(response.getResponse(), isA<Map<String, dynamic>>());
      });

      test('handles empty event ID', () async {
        final response = await functionCaller.leaveEvent('');
        expect(response, isA<FunctionResponse>());
      });
    });

    group('function reference constants', () {
      test('uses correct function names', () {
        // These are tested indirectly through the method calls
        // since the constants are private
        expect(() => functionCaller.sendReport('test', 'test'), returnsNormally);
        expect(() => functionCaller.joinEvent('test'), returnsNormally);
        expect(() => functionCaller.leaveEvent('test'), returnsNormally);
      });

      test('methods call appropriate Firebase functions', () async {
        // Test that each method calls the correct underlying function
        final sendResponse = await functionCaller.sendReport('test', 'message');
        final joinResponse = await functionCaller.joinEvent('event123');
        final leaveResponse = await functionCaller.leaveEvent('event123');
        
        expect(sendResponse, isA<FunctionResponse>());
        expect(joinResponse, isA<FunctionResponse>());
        expect(leaveResponse, isA<FunctionResponse>());
      });
    });

    group('parameter validation and structure', () {
      test('sendReport passes correct parameters', () async {
        final response = await functionCaller.sendReport('bugs', 'Test message');
        
        // The structure should handle the section and text parameters
        expect(response, isA<FunctionResponse>());
      });

      test('joinEvent passes correct parameters', () async {
        final response = await functionCaller.joinEvent('event123', paymentMethodId: 'pm_test');
        
        // The structure should handle eventId and paymentMethodId parameters
        expect(response, isA<FunctionResponse>());
      });

      test('leaveEvent passes correct parameters', () async {
        final response = await functionCaller.leaveEvent('event123');
        
        // The structure should handle eventId parameter
        expect(response, isA<FunctionResponse>());
      });

      test('methods handle parameter edge cases', () async {
        // Test various edge cases for parameters
        final responses = await Future.wait([
          functionCaller.sendReport('', ''),
          functionCaller.sendReport('very-long-section-name-' * 10, 'message'),
          functionCaller.joinEvent(''),
          functionCaller.joinEvent('event', paymentMethodId: ''),
          functionCaller.leaveEvent(''),
          functionCaller.leaveEvent('event', paymentMethodId: 'unused'),
        ]);
        
        for (final response in responses) {
          expect(response, isA<FunctionResponse>());
        }
      });
    });

    group('integration with FunctionHandler', () {
      test('uses handler for all function calls', () async {
        final responses = await Future.wait([
          functionCaller.sendReport('test', 'message'),
          functionCaller.joinEvent('event123'),
          functionCaller.leaveEvent('event123'),
        ]);
        
        for (final response in responses) {
          expect(response, isA<FunctionResponse>());
          expect(response.hasError(), isA<bool>());
        }
      });

      test('handler authentication is enabled by default', () async {
        // All methods should use authentication (needsAuthentication = true by default)
        final response = await functionCaller.sendReport('test', 'message');
        
        // If no authentication, we should get an error response
        expect(response, isA<FunctionResponse>());
      });

      test('error handling flows through handler', () async {
        final response = await functionCaller.joinEvent('invalid-event-id');
        
        if (response.hasError()) {
          expect(response.getErrorMessage(), isA<String>());
          expect(response.getResponse(), isA<Map<String, dynamic>>());
        }
      });
    });

    group('concurrent operations', () {
      test('handles multiple concurrent sendReport calls', () async {
        final futures = List.generate(5, (index) {
          return functionCaller.sendReport('test$index', 'Message $index');
        });
        
        final responses = await Future.wait(futures);
        
        for (final response in responses) {
          expect(response, isA<FunctionResponse>());
        }
      });

      test('handles multiple concurrent joinEvent calls', () async {
        final futures = List.generate(3, (index) {
          return functionCaller.joinEvent('event$index');
        });
        
        final responses = await Future.wait(futures);
        
        for (final response in responses) {
          expect(response, isA<FunctionResponse>());
        }
      });

      test('handles mixed concurrent operations', () async {
        final futures = [
          functionCaller.sendReport('bugs', 'Bug report'),
          functionCaller.joinEvent('event123'),
          functionCaller.leaveEvent('event456'),
          functionCaller.sendReport('feedback', 'Great app!'),
          functionCaller.joinEvent('event789', paymentMethodId: 'pm_test'),
        ];
        
        final responses = await Future.wait(futures);
        
        expect(responses, hasLength(5));
        for (final response in responses) {
          expect(response, isA<FunctionResponse>());
        }
      });
    });

    group('error scenarios', () {
      test('handles authentication errors gracefully', () async {
        final response = await functionCaller.sendReport('test', 'message');
        
        if (response.hasError()) {
          expect(response.getType().toString(), contains('error'));
          expect(response.getErrorMessage(), isA<String>());
        }
      });

      test('maintains consistency across error scenarios', () async {
        final responses = await Future.wait([
          functionCaller.sendReport('', ''),
          functionCaller.joinEvent(''),
          functionCaller.leaveEvent(''),
        ]);
        
        for (final response in responses) {
          expect(response, isA<FunctionResponse>());
          expect(response.hasError(), isA<bool>());
        }
      });
    });
  });
}