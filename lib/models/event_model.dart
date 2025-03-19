import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mgs_app2/models/image_model.dart';

import '../services/firebase/firestore/firestore_events_fields.dart';

class EventModel {
  final String id;
  final String title;
  final String desc;
  final String location;
  final double price;
  final ImageModel? image;
  final DateTime? start;
  final DateTime? end;

  EventModel({
    this.id = '',
    this.location = '',
    this.title = '',
    this.desc = '',
    this.price = 0,
    this.image,
    required this.start,
    required this.end,
  });

  factory EventModel.fromFirestore(String id, Map<String, dynamic> data) {
    return EventModel(
      id: id,
      title: data.containsKey(firestoreEventTitleField)
          ? data[firestoreEventTitleField]
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
    );
  }
}
