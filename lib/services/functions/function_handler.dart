import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mgs_app2/services/functions/response_type.dart';

import 'function_errors.dart';
import 'function_response.dart';

class FunctionHandler {
  FunctionErrors errors = FunctionErrors();

  Future<FunctionResponse> callFunction(
    String functionName,
    Map<String, dynamic> req, {
    bool needsAuthentication = true,
  }) async {
    // Verifica se l'utente è autenticato
    final user = FirebaseAuth.instance.currentUser;
    if (user == null && needsAuthentication) {
      return FunctionResponse(ResponseType.error, {
        'code': errors.genericError,
        'message': 'User is not authenticated.',
      });
    }

    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable(functionName);

    req['idToken'] = await user?.getIdToken() ?? '';


    try {
      final HttpsCallableResult<Map<String, dynamic>> resp =
          await callable.call(req);

      final Map<String, dynamic> bodyResponse = resp.data;

      if (bodyResponse.containsKey('error')) {
        return FunctionResponse(ResponseType.error, {
          'code': bodyResponse['error']['code'],
          'message': bodyResponse['error']['message'],
        });
      }

      return FunctionResponse(ResponseType.success, {
        'payload': bodyResponse['success'],
      });
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        print(
            "error while calling $functionName firebase function: ${e.code} | ${e.message}");
      }

      return FunctionResponse(ResponseType.error, {
        'code': errors.genericError,
        'message': '',
      });
    }
  }
}
