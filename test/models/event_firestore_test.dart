import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/event_firestore.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/services/firebase/firebase_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/firestore_seed.dart';
import 'event_firestore_test.mocks.dart';

@GenerateMocks([FirebaseStorageService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group('EventFirestore', () {
    late FakeFirebaseFirestore fakeDb;
    late MockFirebaseStorageService mockStorageService;
    late EventFirestore eventFirestore;
    const String uid = 'test_uid';

    setUp(() async {
      fakeDb = await seedEvents(uid: uid);
      mockStorageService = MockFirebaseStorageService();
      eventFirestore = EventFirestore(
        events: fakeDb.collection('events'),
        storage: mockStorageService,
      );
      // Mock the static uid field on UserModel for the duration of the tests
      UserModel.uid = uid;
      
      // Add events created by other users for retrieveEvents test
      // (retrieveEvents excludes user-created events)
      await fakeDb.collection('events').doc('e_other1').set({
        'start': Timestamp.fromDate(DateTime.now().add(const Duration(days: 5))),
        'creationDate': Timestamp.fromDate(DateTime.now()),
        'creatorUid': 'other_user_1',
        'title': 'Event 1',
      });
      await fakeDb.collection('events').doc('e_other2').set({
        'start': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
        'creationDate': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
        'creatorUid': 'other_user_2', 
        'title': 'Past Event',
      });
    });

    group('retrieveEvents', () {
      test('returns all events from firestore on success', () async {
        // Arrange
        when(mockStorageService.getEventBannerImage(any))
            .thenAnswer((_) async => ImageModel(downloadUrl: 'fake_url'));

        // Act
        final events = await eventFirestore.retrieveEvents();

        // Assert
        expect(events.length, 2);
        expect(events[0].title, 'Event 1');
        expect(events[1].title, 'Past Event');
        verify(mockStorageService.getEventBannerImage('e_other1')).called(1);
        verify(mockStorageService.getEventBannerImage('e_other2')).called(1);
      });

      test('returns empty list on error', () async {
        // Arrange
        when(mockStorageService.getEventBannerImage(any))
            .thenThrow(Exception('Storage Error'));

        // Act
        final events = await eventFirestore.retrieveEvents();

        // Assert
        expect(events, isEmpty);
      });
    });

    group('retrieveParticipantsUid', () {
      test('returns a list of participant UIDs on success', () async {
        // Act
        final participants = await eventFirestore.retrieveParticipantsUid('e1');

        // Assert
        expect(participants.length, 1);
        expect(participants[0], uid);
      });

      // Note: Testing the catch block for this method is difficult with fake_cloud_firestore
      // as it's hard to simulate a failure on a simple .get() call without more complex mocking.
    });

    group('retrieveUserJoinedEvents', () {
      test('returns only events the user has joined', () async {
        // Arrange
        when(mockStorageService.getEventBannerImage(any))
            .thenAnswer((_) async => ImageModel(downloadUrl: 'fake_url'));
        // In the seed, the user has only joined event 'e1'

        // Act
        final events = await eventFirestore.retrieveUserJoinedEvents();

        // Assert
        expect(events.length, 1);
        expect(events[0].id, 'e1');
      });

      test('returns only future events when onlyFuture is true', () async {
        // Arrange
        // Add the user as a participant to the past event 'e2'
        await fakeDb
            .collection('events')
            .doc('e2')
            .collection('participants')
            .doc(uid)
            .set({});
        when(mockStorageService.getEventBannerImage(any))
            .thenAnswer((_) async => ImageModel(downloadUrl: 'fake_url'));

        // Act
        final events =
            await eventFirestore.retrieveUserJoinedEvents(onlyFuture: true);

        // Assert
        // Should only return the future event 'e1' and not the past one 'e2'
        expect(events.length, 1);
        expect(events[0].id, 'e1');
      });

      test('returns empty list on error', () async {
        // Arrange
        when(mockStorageService.getEventBannerImage(any))
            .thenThrow(Exception('Storage Error'));

        // Act
        final events = await eventFirestore.retrieveUserJoinedEvents();

        // Assert
        expect(events, isEmpty);
      });
    });

    group('addEvent', () {
      test('creates a new event and stores image', () async {
        // Arrange
        final now = Timestamp.now();
        final newEvent = EventModel(
          id: 'e3',
          title: 'New Event',
          start: now.toDate(),
          end: now.toDate(),
          image: ImageModel(image: Uint8List(0), extension: 'image/png'),
        );
        when(mockStorageService.storeEventBannerImage(any, any))
            .thenAnswer((_) async => true);

        // Act
        final newEventId = await eventFirestore.addEvent(newEvent);

        // Assert
        expect(newEventId, isNotEmpty);
        final doc = await fakeDb.collection('events').doc(newEventId).get();
        expect(doc.exists, isTrue);
        expect(doc.data()?['title'], 'New Event');
        verify(mockStorageService.storeEventBannerImage(
                newEventId, newEvent.image!))
            .called(1);
      });

      test('creates a new event without an image', () async {
        // Arrange
        final now = Timestamp.now();
        final newEvent = EventModel(
          id: 'e4',
          title: 'Event Without Image',
          start: now.toDate(),
          end: now.toDate(),
        );

        // Act
        final newEventId = await eventFirestore.addEvent(newEvent);

        // Assert
        expect(newEventId, isNotEmpty);
        final doc = await fakeDb.collection('events').doc(newEventId).get();
        expect(doc.exists, isTrue);
        verifyNever(mockStorageService.storeEventBannerImage(any, any));
      });

      test('returns empty string on error', () async {
        // Arrange
        final now = Timestamp.now();
        final newEvent = EventModel(
          id: 'e3',
          title: 'New Event',
          start: now.toDate(),
          end: now.toDate(),
          image: ImageModel(image: Uint8List(0), extension: 'image/png'),
        );
        when(mockStorageService.storeEventBannerImage(any, any))
            .thenThrow(Exception('Storage Error'));

        // Act
        final newEventId = await eventFirestore.addEvent(newEvent);

        // Assert
        expect(newEventId, isEmpty);
      });
    });

    group('retrievePersonalEvents', () {
      test('returns created and joined events, no duplicates', () async {
        // Arrange
        // User created e1, e2. User joined e1. Let's add a new event created by someone else that the user joined.
        await fakeDb.collection('events').doc('e5').set({
          'creatorUid': 'another_user',
          'title': 'Another Event',
          'start': Timestamp.now(),
        });
        await fakeDb
            .collection('events')
            .doc('e5')
            .collection('participants')
            .doc(uid)
            .set({});

        when(mockStorageService.getEventBannerImage(any))
            .thenAnswer((_) async => ImageModel(downloadUrl: 'fake_url'));

        // Act
        final events = await eventFirestore.retrievePersonalEvents();

        // Assert
        // Should return e1, e2 (created) and e5 (joined)
        final eventIds = events.map((e) => e.id).toSet();
        expect(eventIds.length, 3);
        expect(eventIds, containsAll(['e1', 'e2', 'e5']));
      });

      test('returns only future events when onlyFuture is true', () async {
        // Arrange
        // Add user as participant to a past event, to ensure it gets filtered out.
        await fakeDb
            .collection('events')
            .doc('e2')
            .collection('participants')
            .doc(uid)
            .set({});
        when(mockStorageService.getEventBannerImage(any))
            .thenAnswer((_) async => ImageModel(downloadUrl: 'fake_url'));

        // Act
        final events = await eventFirestore.retrievePersonalEvents(onlyFuture: true);

        // Assert
        // Seed has one future (e1) and one past (e2) event created by the user.
        // The user has also joined the past event e2.
        // The method should only return the future event e1.
        expect(events.length, 1);
        expect(events[0].id, 'e1');
      });

       test('returns empty list on error', () async {
        // Arrange
        when(mockStorageService.getEventBannerImage(any))
            .thenThrow(Exception('Storage Error'));

        // Act
        final events = await eventFirestore.retrievePersonalEvents();

        // Assert
        expect(events, isEmpty);
      });
    });
  });
}