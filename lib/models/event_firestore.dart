import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/user_model.dart';

import '../services/firebase/references.dart';

class EventFirestore {

  final FirebaseReferencesService _referencesService =
  FirebaseReferencesService.getInstance();

  late CollectionReference _eventsCR;

  Future<List<EventModel>> retrieveEvents() async {

    return [];
  }

  /*EventFirestore() {

    _eventsCR = _referencesService.getHostEventsReference(UserModel.uid);
  }

  Future<void> storeEvent(EventModel event) {


  }*/
}