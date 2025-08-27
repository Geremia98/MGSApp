import 'dart:typed_data';

import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/services/firebase/firebase_storage.dart';

void main() {
  group('FirebaseStorageService', () {
    late MockFirebaseStorage mockStorage;
    late FirebaseStorageService storageService;

    setUp(() {
      mockStorage = MockFirebaseStorage();
      storageService = FirebaseStorageService(storage: mockStorage);
    });

    group('storeEventBannerImage', () {
      test('successfully uploads data to the correct path', () async {
        // Arrange
        const eventId = 'test-event';
        final image = ImageModel(
          image: Uint8List.fromList([1, 2, 3]),
          extension: 'image/png',
        );
        final expectedPath = 'events/test-event/banner.png';

        // Act
        final success = await storageService.storeEventBannerImage(eventId, image);

        // Assert
        expect(success, isTrue);
        final data = await mockStorage.ref().child(expectedPath).getData();
        expect(data, equals(image.image));
      });

      test('returns false if image extension is not found', () async {
        // Arrange
        const eventId = 'test-event';
        final image = ImageModel(
          image: Uint8List.fromList([1, 2, 3]),
          extension: 'image/unsupported', // Invalid extension
        );

        // Act
        final success = await storageService.storeEventBannerImage(eventId, image);

        // Assert
        expect(success, isFalse);
      });

      test('returns false if image data is null', () async {
        // Arrange
        const eventId = 'test-event';
        final image = ImageModel(
          image: null, // Null image data
          extension: 'image/png',
        );

        // Act
        final success = await storageService.storeEventBannerImage(eventId, image);

        // Assert
        expect(success, isFalse);
      });
    });

    group('getEventBannerImage', () {
      test('returns ImageModel on success', () async {
        // Arrange
        const eventId = 'test-event';
        final path = 'events/$eventId/banner.png';
        final data = Uint8List.fromList([1, 2, 3]);
        await mockStorage.ref().child(path).putData(data);

        // Act
        final imageModel = await storageService.getEventBannerImage(eventId);

        // Assert
        expect(imageModel, isNotNull);
        expect(imageModel!.downloadUrl, isNotEmpty);
      });

      test('returns null if no image exists', () async {
        // Arrange
        const eventId = 'non-existent-event';

        // Act
        final imageModel = await storageService.getEventBannerImage(eventId);

        // Assert
        expect(imageModel, isNull);
      });
    });

     group('getUserProfileImage', () {
      test('returns ImageModel on success', () async {
        // Arrange
        const userId = 'test-user';
        final path = 'users/$userId/profile.jpg';
        final data = Uint8List.fromList([4, 5, 6]);
        await mockStorage.ref().child(path).putData(data);

        // Act
        final imageModel = await storageService.getUserProfileImage(userId);

        // Assert
        expect(imageModel, isNotNull);
        expect(imageModel!.downloadUrl, isNotEmpty);
      });

      test('returns null if no image exists', () async {
        // Arrange
        const userId = 'non-existent-user';

        // Act
        final imageModel = await storageService.getUserProfileImage(userId);

        // Assert
        expect(imageModel, isNull);
      });
    });

  });
}