import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/user_model.dart';

import '../services/firebase/references.dart';

class EventFirestore {

  final FirebaseReferencesService _referencesService =
  FirebaseReferencesService.getInstance();

  late CollectionReference eventsCR;

  EventFirestore() {
    eventsCR = _referencesService.eventsCR;
  }

  Future<List<EventModel>> retrieveEvents() async {
    try {
      QuerySnapshot snap = await eventsCR.get();

      return snap.docs.map((QueryDocumentSnapshot doc) =>
          EventModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

    } catch (error) {
      if (kDebugMode) {
        print('error while fetching events: $error');
      }
      return [];
    }
  }

  Future<String> addEvent(EventModel event) async {

    try {
      DocumentReference ref = await eventsCR.add(
        event.toPayload()
      );

      return ref.id;

    } catch (error) {
      if (kDebugMode) {
        print('error while fetching events: $error');
      }
      return '';
    }
  }


/*EventFirestore() {

    _eventsCR = _referencesService.getHostEventsReference(UserModel.uid);
  }

  Future<void> storeEvent(EventModel event) {


  }*/
}