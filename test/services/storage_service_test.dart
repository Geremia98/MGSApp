import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/services/firebase/firebase_storage.dart';
import 'package:mgs_app2/services/firebase/storage_wrapper.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'storage_service_test.mocks.dart';

@GenerateMocks([FirebaseStorageWrapper, Reference])
void main() {
  group('FirebaseStorageService', () {
    // For happy paths, we use the fake implementation from firebase_storage_mocks
    late MockFirebaseStorage mockSuccessStorage;
    late FirebaseStorageService successStorageService;

    // For error paths, we use a mockito mock of our wrapper
    late MockFirebaseStorageWrapper mockErrorStorageWrapper;
    late MockReference mockReference;
    late FirebaseStorageService errorStorageService;

    setUp(() {
      // Setup for success cases
      mockSuccessStorage = MockFirebaseStorage();
      successStorageService = FirebaseStorageService(
          storage: FirebaseStorageWrapper(storage: mockSuccessStorage));

      // Setup for error cases
      mockErrorStorageWrapper = MockFirebaseStorageWrapper();
      mockReference = MockReference();
      errorStorageService = FirebaseStorageService(storage: mockErrorStorageWrapper);

      // Stub the mock wrapper to always return a mock reference
      when(mockErrorStorageWrapper.ref(any)).thenReturn(mockReference);
      when(mockErrorStorageWrapper.ref()).thenReturn(mockReference);
      when(mockReference.child(any)).thenReturn(mockReference);
    });

    group('storeEventBannerImage', () {
      test('successfully uploads data to the correct path', () async {
        const eventId = 'test-event';
        final image = ImageModel(
          image: Uint8List.fromList([1, 2, 3]),
          extension: 'image/png',
        );
        final expectedPath = 'events/test-event/banner.png';

        final success = await successStorageService.storeEventBannerImage(eventId, image);

        expect(success, isTrue);
        final data = await mockSuccessStorage.ref(expectedPath).getData();
        expect(data, equals(image.image));
      });

      test('returns false on a storage exception', () async {
        // Arrange
        when(mockReference.putData(any))
            .thenThrow(FirebaseException(plugin: 'storage'));
        const eventId = 'test-event';
        final image = ImageModel(
          image: Uint8List.fromList([1, 2, 3]),
          extension: 'image/png',
        );

        // Act
        final success = await errorStorageService.storeEventBannerImage(eventId, image);

        // Assert
        expect(success, isFalse);
      });

      // Other failure cases (null data, bad extension) are simple logic, no need to change
    });

    group('getEventBannerImage', () {
      test('returns ImageModel on success', () async {
        const eventId = 'test-event';
        final path = 'events/$eventId/banner.png';
        await mockSuccessStorage.ref(path).putData(Uint8List.fromList([1, 2, 3]));

        final imageModel = await successStorageService.getEventBannerImage(eventId);

        expect(imageModel, isNotNull);
        expect(imageModel!.downloadUrl, isNotEmpty);
      });

      test('returns null on a storage exception', () async {
        // Arrange
        when(mockReference.listAll())
            .thenThrow(FirebaseException(plugin: 'storage'));

        // Act
        final imageModel = await errorStorageService.getEventBannerImage('test-event');

        // Assert
        expect(imageModel, isNull);
      });
    });

    group('getUserProfileImage', () {
      test('returns ImageModel on success', () async {
        const userId = 'test-user';
        final path = 'users/${userId}_profile.png';
        await mockSuccessStorage.ref().child(path).putData(Uint8List.fromList([1, 2, 3]));

        final imageModel = await successStorageService.getUserProfileImage(userId);

        expect(imageModel, isNotNull);
        expect(imageModel!.downloadUrl, isNotEmpty);
      });

      test('returns null on a storage exception', () async {
        // Arrange
        when(mockReference.listAll())
            .thenThrow(FirebaseException(plugin: 'storage'));

        // Act
        final imageModel = await errorStorageService.getUserProfileImage('test-user');

        // Assert
        expect(imageModel, isNull);
      });
    });
  });
}