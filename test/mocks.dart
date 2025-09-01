import 'package:mockito/annotations.dart';
import 'package:mgs_app2/services/firebase/firebase_storage.dart';
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/services/functions/firebase_function_caller.dart';

@GenerateMocks([FirebaseStorageService, EventFirestore, FirebaseFunctionCaller])
void main() {}