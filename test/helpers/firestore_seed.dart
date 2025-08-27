import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<FakeFirebaseFirestore> seedEvents({required String uid}) async {
  final db = FakeFirebaseFirestore();

  await db.collection('events').doc('e1').set({
    'start': Timestamp.fromDate(DateTime.now().add(const Duration(days: 3))),
    'creationDate': Timestamp.fromDate(DateTime.now()),
    'creatorUid': uid,
    'title': 'Event 1',
  });
  await db.collection('events').doc('e1')
    .collection('participants').doc(uid).set({});

  await db.collection('events').doc('e2').set({
    'start': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
    'creationDate': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
    'creatorUid': uid,
    'title': 'Past Event',
  });

  return db;
}
