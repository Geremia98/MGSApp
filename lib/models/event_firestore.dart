import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/services/firebase/firebase_storage.dart';
import 'package:mgs_app2/services/firebase/firestore/firestore_events_fields.dart';

import '../services/firebase/references.dart';

class EventFirestore {

  final FirebaseReferencesService _referencesService =
  FirebaseReferencesService.getInstance();

  late CollectionReference eventsCR;

  EventFirestore() {
    eventsCR = _referencesService.eventsCR;
  }

  Future<List<EventModel>> retrieveEvents() async {

    List<EventModel> events = [];
    FirebaseStorageService storageService = FirebaseStorageService();

    try {
      QuerySnapshot snap = await eventsCR.get();

      for (QueryDocumentSnapshot doc in snap.docs) {

        ImageModel? image = await storageService.getEventBannerImage(doc.id);
        events.add(EventModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>, image));

      }

      return events;

    } catch (error) {
      if (kDebugMode) {
        print('error while fetching events: $error');
      }
      return [];
    }
  }

  Future<List<EventModel>> retrievePersonalEvents() async {

    List<EventModel> events = [];
    FirebaseStorageService storageService = FirebaseStorageService();

    try {
      QuerySnapshot snap = await eventsCR.where(firestoreEventCreatorUid, isEqualTo: UserModel.uid).get();

      for (QueryDocumentSnapshot doc in snap.docs) {

        ImageModel? image = await storageService.getEventBannerImage(doc.id);
        events.add(EventModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>, image));

      }

      return events;

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

      FirebaseStorageService storageService = FirebaseStorageService();

      if (event.image != null) {
        storageService.storeEventBannerImage(ref.id, event.image!);
      }

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