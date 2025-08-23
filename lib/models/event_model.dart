import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/services/firebase/firestore/firestore_users_fields.dart';

import '../services/firebase/firestore/firestore_events_fields.dart';

enum EventTargetGender {
  male,
  female,
  both,
}

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
  final DateTime? creationDate;

  final String targetCountry;
  final int? minTargetAge;
  final int? maxTargetAge;
  final EventTargetGender? targetGender;
  final String targetIspettoria;
  final String targetGruppo;

  final List<String> participants;

  EventModel({
    this.creatorUid = '',
    this.id = '',
    this.location = '',
    this.title = '',
    this.desc = '',
    this.price = 0,
    this.image,
    this.creationDate,
    required this.start,
    required this.end,
    this.targetCountry = '',
    this.minTargetAge,
    this.maxTargetAge,
    this.targetIspettoria = '',
    this.targetGruppo = '',
    this.targetGender = EventTargetGender.both,
    this.participants = const [],
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
      firestoreEventCreationDate: DateTime.now(),
      firestoreEventTarget: {
        firestoreEventMinTargetAgeField: minTargetAge,
        firestoreEventMaxTargetAgeField: maxTargetAge,
        firestoreEventTargetCountryField: targetCountry,
        firestoreEventTargetGruppoField: targetGruppo,
        firestoreEventTargetIspettoriaField: targetIspettoria,
        firestoreEventTargetSexField: targetGender != null ? targetGender!.name : EventTargetGender.both,
      }
    };
  }

  factory EventModel.fromFirestore(
      String id, Map<String, dynamic> data, ImageModel? banner, List<String> participants) {

    final Map<String, dynamic> target = data[firestoreEventTarget] ?? {};

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
      creationDate: data.containsKey(firestoreEventCreationDate)
          ? (data[firestoreEventCreationDate] as Timestamp).toDate()
          : DateTime(1900),
      end: data.containsKey(firestoreEventEndField)
          ? (data[firestoreEventEndField] as Timestamp).toDate()
          : DateTime(1900),
      price: data.containsKey(firestoreEventPriceField)
          ? double.tryParse(data[firestoreEventPriceField].toString()) ?? 0
          : 0,
      image: banner,
      targetGender: target.containsKey(firestoreEventTargetSexField)
          ? EventTargetGender.values.firstWhere((value) => value.name == target[firestoreEventTargetSexField])
          : EventTargetGender.both,
      minTargetAge: target.containsKey(firestoreEventMinTargetAgeField)
          ? int.tryParse(target[firestoreEventMinTargetAgeField].toString() ?? '')
          : null,
      maxTargetAge: target.containsKey(firestoreEventMaxTargetAgeField)
          ? int.tryParse(target[firestoreEventMaxTargetAgeField].toString() ?? '')
          : null,
      targetCountry: target.containsKey(firestoreEventTargetCountryField)
          ? target[firestoreEventTargetCountryField]
          : '',
      targetGruppo: target.containsKey(firestoreEventTargetGruppoField)
          ? target[firestoreEventTargetGruppoField]
          : '',
      targetIspettoria: target.containsKey(firestoreUsersIspettoriaField)
          ? target[firestoreUsersIspettoriaField]
          : '',
      participants: participants,
    );
  }
}
