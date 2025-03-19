import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_references.dart';


class FirebaseReferencesService {
  CollectionReference<Map<String, dynamic>> usersCR = FirebaseFirestore.instance.collection(firestoreUsersCollection);
  CollectionReference<Map<String, dynamic>> hostsCR = FirebaseFirestore.instance.collection(firestoreHostsCollection);
  CollectionReference<Map<String, dynamic>> locationsCR = FirebaseFirestore.instance.collection(firestoreLocationsCollection);
  CollectionReference<Map<String, dynamic>> eventsCR = FirebaseFirestore.instance.collection(firestoreEventsCollection);

  static FirebaseReferencesService? _instance;

  static FirebaseReferencesService getInstance() {
    return _instance ??= FirebaseReferencesService();
  }


}
