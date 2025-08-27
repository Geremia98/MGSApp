import 'function_handler.dart';
import 'function_request_parser.dart';
import 'function_response.dart';

class FirebaseFunctionCaller {
  final _joinEventFunctionReference = 'joinEvent';
  final _leaveEventFunctionReference = 'leaveEvent';
  final _sendReportFunctionReference = 'sendReport';

  final FunctionHandler handler = FunctionHandler();

  Future<FunctionResponse> sendReport(
      String section,
      String text) {
    return handler.callFunction(_sendReportFunctionReference, {
      'section': section,
      'text': text,
    });
  }

  Future<FunctionResponse> joinEvent(
    String eventId, {
    String paymentMethodId = '',
  }) {
    return handler.callFunction(_joinEventFunctionReference, {
      'eventId': eventId,
      'paymentMethodId': paymentMethodId,
    });
  }

  Future<FunctionResponse> leaveEvent(
      String eventId, {
        String paymentMethodId = '',
      }) {
    return handler.callFunction(_leaveEventFunctionReference, {
      'eventId': eventId,
    });
  }
}
