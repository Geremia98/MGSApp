import 'package:flutter/material.dart';
import 'package:mgs_app2/services/firebase/auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mgs_app2/services/firebase/firebase_storage.dart';
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/services/functions/firebase_function_caller.dart';

@GenerateNiceMocks([MockSpec<FirebaseStorageService>(), MockSpec<EventFirestore>(), MockSpec<FirebaseFunctionCaller>(), MockSpec<NavigatorObserver>(), MockSpec<FirebaseAuthService>(), MockSpec<BuildContext>()])
void main() {}