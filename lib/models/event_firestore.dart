import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/services/firebase/firebase_storage.dart';
import 'package:mgs_app2/services/firebase/firestore/firestore_events_fields.dart';
import 'package:mgs_app2/services/local/favorite_service.dart';

import '../services/firebase/references.dart';

class EventFirestore {
  final FirebaseReferencesService _referencesService =
      FirebaseReferencesService.getInstance();

  late CollectionReference eventsCR;

  EventFirestore() {
    eventsCR = _referencesService.eventsCR;
  }

  Future<List<EventModel>> retrieveUserJoinedEvents({
    bool onlyFuture = false,
  }) async {
    List<EventModel> events = [];
    FirebaseStorageService storageService = FirebaseStorageService();

    try {
      // Prendo tutti gli eventi (puoi ottimizzare con query più complesse se necessario)
      QuerySnapshot snap =
          await eventsCR.orderBy('start', descending: true).get();

      for (QueryDocumentSnapshot doc in snap.docs) {
        // Controllo se esiste un documento con id == uid nella subcollection participants
        DocumentSnapshot participantDoc = await eventsCR
            .doc(doc.id)
            .collection('participants')
            .doc(UserModel.uid)
            .get();

        if (participantDoc.exists) {
          // Filtro per eventi futuri se richiesto
          if (onlyFuture) {
            final data = doc.data() as Map<String, dynamic>;
            final Timestamp? startDate =
                data['start']; // o 'eventDate' a seconda del tuo schema

            if (startDate != null &&
                startDate.toDate().isBefore(DateTime.now())) {
              continue; // evento già passato, lo salto
            }
          }

          ImageModel? image = await storageService.getEventBannerImage(doc.id);
          List<String> participants = await retrieveParticipantsUid(doc.id);

          final FavoritesService favoritesService = FavoritesService();
          bool isFavourite = await favoritesService.isFavorite(doc.id);

          events.add(EventModel.fromFirestore(
            doc.id,
            doc.data() as Map<String, dynamic>,
            image,
            participants,
            isFavourite,
          ));
        }
      }

      return events;
    } catch (error) {
      if (kDebugMode) {
        print('error while fetching user events: $error');
      }
      return [];
    }
  }

  Future<List<EventModel>> retrieveEvents() async {
    List<EventModel> events = [];
    FirebaseStorageService storageService = FirebaseStorageService();

    try {
      QuerySnapshot snap = await eventsCR
          /*.where('target.targetGender', whereIn: ['both', UserModel.gender.name])
            .where('target.targetCountry', isEqualTo: UserModel.country)
            .where('target.targetGruppo', isEqualTo: UserModel.group)
            .where('target.targetIspettoria', isEqualTo: UserModel.ispettoria)*/
          .orderBy('start', descending: true)
          .get();

      for (QueryDocumentSnapshot doc in snap.docs) {
        ImageModel? image = await storageService.getEventBannerImage(doc.id);
        List<String> participants = await retrieveParticipantsUid(doc.id);

        final FavoritesService favoritesService = FavoritesService();
        bool isFavourite = await favoritesService.isFavorite(doc.id);

        events.add(EventModel.fromFirestore(
            doc.id, doc.data() as Map<String, dynamic>, image, participants, isFavourite));
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

  Future<List<EventModel>> retrievePersonalEvents({
    bool onlyFuture = false,
  }) async {
    List<EventModel> events = [];
    FirebaseStorageService storageService = FirebaseStorageService();

    try {
      QuerySnapshot snap = await eventsCR
          .where(firestoreEventCreatorUid, isEqualTo: UserModel.uid)
          .orderBy('creationDate', descending: true)
          .get();

      for (QueryDocumentSnapshot doc in snap.docs) {
        if (onlyFuture) {
          final data = doc.data() as Map<String, dynamic>;
          final Timestamp? startDate =
              data['start']; // o 'eventDate' a seconda del tuo schema

          if (startDate != null &&
              startDate.toDate().isBefore(DateTime.now())) {
            continue; // evento già passato, lo salto
          }
        }

        List<String> participants = await retrieveParticipantsUid(doc.id);
        ImageModel? image = await storageService.getEventBannerImage(doc.id);

        final FavoritesService favoritesService = FavoritesService();

        bool isFavourite = await favoritesService.isFavorite(doc.id);

        events.add(EventModel.fromFirestore(
            doc.id, doc.data() as Map<String, dynamic>, image, participants, isFavourite));
      }

      events.addAll(await retrieveUserJoinedEvents(onlyFuture: onlyFuture));

      events.sort((a, b) => b.start!.compareTo(a.start!));

      return events;
    } catch (error) {
      if (kDebugMode) {
        print('error while fetching events: $error');
      }
      return [];
    }
  }

  Future<EventModel?> getEventById(String id) async {
    FirebaseStorageService storageService = FirebaseStorageService();

    try {
      DocumentSnapshot doc = await eventsCR.doc(id).get();

      if (!doc.exists) {
        return null;
      }

      List<String> participants = await retrieveParticipantsUid(doc.id);
      ImageModel? image = await storageService.getEventBannerImage(doc.id);

      final FavoritesService favoritesService = FavoritesService();
      bool isFavourite = await favoritesService.isFavorite(doc.id);

      return EventModel.fromFirestore(
          doc.id, doc.data() as Map<String, dynamic>, image, participants, isFavourite);
    } catch (error) {
      if (kDebugMode) {
        print('error while fetching events: $error');
      }
      return null;
    }
  }

  Future<String> addEvent(EventModel event) async {
    try {
      DocumentReference ref = await eventsCR.add(event.toPayload());

      FirebaseStorageService storageService = FirebaseStorageService();

      if (event.image != null) {
        await storageService.storeEventBannerImage(ref.id, event.image!);
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
