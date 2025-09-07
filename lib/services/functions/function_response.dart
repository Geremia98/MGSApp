import 'package:mgs_app2/services/functions/response_type.dart';

class FunctionResponse {
  final ResponseType _responseType;
  final Map<String, dynamic> _response;

  FunctionResponse(this._responseType, this._response);

  Map<String, dynamic> getResponse() => _response;

  ResponseType getType() => _responseType;

  bool hasError() => _responseType == ResponseType.error;

  Map<String, dynamic> getSuccessResponse() => Map<String, dynamic>.from(_response['payload'] as Map<Object?, Object?>);

  String getSuccessStringResponse() => _response['payload'] as String;

  List<Object?> getSuccessListResponse() => List<Object?>.from(_response['payload']);

  String getErrorMessage() {

    if (_responseType != ResponseType.error) {
      return '';
    }

    return _response['message'].toString();

  }
}


