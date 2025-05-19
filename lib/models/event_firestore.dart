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
      QuerySnapshot snap = await eventsCR.orderBy('creationDate', descending: true).get();

      for (QueryDocumentSnapshot doc in snap.docs) {

        ImageModel? image = await storageService.getEventBannerImage(doc.id);
        List<String> participants = await retrieveParticipantsUid(doc.id);


        events.add(EventModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>, image, participants));

      }

      return events;

    } catch (error) {
      if (kDebugMode) {
        print('error while fetching events: $error');
      }
      return [];
    }
  }

  Future<List<String>> retrieveParticipantsUid(String eventId) async {
    try {
      final participantsRef = eventsCR.doc(eventId).collection('participants');
      final snapshot = await participantsRef.get();

      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (error) {
      if (kDebugMode) {
        print('Error while retrieving participants UID: $error');
      }
      return [];
    }
  }

  Future<List<EventModel>> retrievePersonalEvents() async {

    List<EventModel> events = [];
    FirebaseStorageService storageService = FirebaseStorageService();

    try {
      QuerySnapshot snap = await eventsCR.where(firestoreEventCreatorUid, isEqualTo: UserModel.uid).orderBy('creationDate', descending: true).get();

      for (QueryDocumentSnapshot doc in snap.docs) {

        List<String> participants = await retrieveParticipantsUid(doc.id);
        ImageModel? image = await storageService.getEventBannerImage(doc.id);

        events.add(EventModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>, image, participants));

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