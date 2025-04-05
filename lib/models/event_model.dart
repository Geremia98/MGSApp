import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/services/firebase/firestore/firestore_users_fields.dart';

import '../services/firebase/firestore/firestore_events_fields.dart';

class EventModel {
  final String creatorUid;
  final String id;
  final String title;
  final String desc;
  final String location;
  final double price;
  final ImageModel? image;
  final DateTime? start;
  final DateTime? end;

  final String targetCountry;
  final String targetAge;
  final bool isJustForMales;
  final String targetIspettoria;
  final String targetGruppo;

  EventModel({
    this.creatorUid = '',
    this.id = '',
    this.location = '',
    this.title = '',
    this.desc = '',
    this.price = 0,
    this.image,
    required this.start,
    required this.end,

    this.targetCountry = '',
    this.targetAge = '',
    this.targetIspettoria = '',
    this.targetGruppo = '',
    this.isJustForMales = false,
  });

  Map<String, dynamic> toPayload() {
    return {
      firestoreEventTitleField: title,
      firestoreEventDescriptionField: desc,
      firestoreEventLocationField: location,
      firestoreEventStartField: start,
      firestoreEventEndField: end,
      firestoreEventPriceField: price,
      firestoreEventCreatorUid: creatorUid,
      firestoreEventTargetAgeField: targetAge,
      firestoreEventTargetCountryField: targetCountry,
      firestoreEventTargetGruppoField: targetGruppo, 
      firestoreEventTargetIspettoriaField: targetIspettoria,
      firestoreEventTargetSexField: isJustForMales,
    };
  }

  factory EventModel.fromFirestore(
      String id, Map<String, dynamic> data, ImageModel? banner) {
    return EventModel(
      id: id,
      title: data.containsKey(firestoreEventTitleField)
          ? data[firestoreEventTitleField]
          : '',
      creatorUid: data.containsKey(firestoreEventCreatorUid)
          ? data[firestoreEventCreatorUid]
          : '',
      desc: data.containsKey(firestoreEventDescriptionField)
          ? data[firestoreEventDescriptionField]
          : '',
      location: data.containsKey(firestoreEventLocationField)
          ? data[firestoreEventLocationField]
          : '',
      start: data.containsKey(firestoreEventStartField)
          ? (data[firestoreEventStartField] as Timestamp).toDate()
          : DateTime(1900),
      end: data.containsKey(firestoreEventEndField)
          ? (data[firestoreEventEndField] as Timestamp).toDate()
          : DateTime(1900),
      price: data.containsKey(firestoreEventPriceField)
          ? double.tryParse(data[firestoreEventPriceField].toString()) ?? 0
          : 0,
      image: banner,
      isJustForMales: data.containsKey(firestoreEventTargetSexField)
          ? data[firestoreEventTargetSexField]
          :false,
      targetAge: data.containsKey(firestoreEventTargetAgeField)
          ? data[firestoreEventTargetAgeField]
          : '',
      targetCountry: data.containsKey(firestoreEventTargetCountryField)
          ? data[firestoreEventTargetCountryField]
          : '',
      targetGruppo: data.containsKey(firestoreEventTargetGruppoField)
          ? data[firestoreEventTargetGruppoField]
          : '',
      targetIspettoria: data.containsKey(firestoreUsersIspettoriaField)
          ? data[firestoreUsersIspettoriaField]
          : '',
    );
  }
}
