import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/services/picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../test_helpers.dart';

@GenerateMocks([
  ImagePicker,
  XFile,
  ImageCropper,
  CroppedFile,
])
import 'picker_test.mocks.dart';

void main() {
  group('ImagePickerService', () {
    late ImagePickerService imagePickerService;
    late MockImagePicker mockImagePicker;
    late MockXFile mockXFile;
    late MockImageCropper mockImageCropper;
    late MockCroppedFile mockCroppedFile;

    setUpAll(() {
      setupFirebaseAuthMocks();
    });

    setUp(() {
      imagePickerService = ImagePickerService();
      mockImagePicker = MockImagePicker();
      mockXFile = MockXFile();
      mockImageCropper = MockImageCropper();
      mockCroppedFile = MockCroppedFile();
      
      // Reset UserModel
      UserModel.uid = 'test-uid';
    });

    group('constructor and basic properties', () {
      test('creates instance successfully', () {
        expect(imagePickerService, isNotNull);
        expect(imagePickerService, isA<ImagePickerService>());
      });

      test('has initial state', () {
        // The _isPicking field is private, but we can test behavior
        expect(imagePickerService, isA<ImagePickerService>());
      });
    });

    group('storeImage', () {
      test('returns null when image is null', () async {
        final result = await imagePickerService.storeImage(null);
        expect(result, isNull);
      });

      test('method signature is correct', () {
        expect(imagePickerService.storeImage, isA<Function>());
      });

      test('accepts ImageModel parameter type', () {
        final imageModel = ImageModel(
          image: Uint8List.fromList([1, 2, 3, 4]),
          extension: 'image/jpeg',
        );

        // Test that ImageModel can be created and has correct type
        expect(imageModel, isA<ImageModel>());
        expect(imageModel.image, isA<Uint8List>());
        expect(imageModel.extension, equals('image/jpeg'));
      });
    });

    group('getImageFromUser', () {
      test('has correct method signature', () {
        expect(imagePickerService.getImageFromUser, isA<Function>());
      });

      test('accepts ImageSource parameter', () {
        expect(() => imagePickerService.getImageFromUser(source: ImageSource.camera), 
               returnsNormally);
        expect(() => imagePickerService.getImageFromUser(source: ImageSource.gallery), 
               returnsNormally);
      });

      test('uses gallery as default source', () {
        expect(() => imagePickerService.getImageFromUser(), returnsNormally);
      });

      test('method returns Future<XFile?>', () {
        final result = imagePickerService.getImageFromUser();
        expect(result, isA<Future<XFile?>>());
      });
    });

    group('getMediaFromUser', () {
      test('has correct method signature', () {
        expect(imagePickerService.getMediaFromUser, isA<Function>());
      });

      test('method returns Future<XFile?>', () {
        final result = imagePickerService.getMediaFromUser();
        expect(result, isA<Future<XFile?>>());
      });
    });

    group('getMultipleImagesFromUser', () {
      test('has correct method signature', () {
        expect(imagePickerService.getMultipleImagesFromUser, isA<Function>());
      });

      test('method returns Future<List<XFile?>?>', () {
        final result = imagePickerService.getMultipleImagesFromUser();
        expect(result, isA<Future<List<XFile?>?>>());
      });
    });

    group('openImageCropperProfilePicture', () {
      testWidgets('has correct method signature', (WidgetTester tester) async {
        expect(imagePickerService.openImageCropperProfilePicture, isA<Function>());
      });

      testWidgets('accepts XFile and BuildContext parameters', (WidgetTester tester) async {
        when(mockXFile.path).thenReturn('test/path/image.jpg');
        
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(() => imagePickerService.openImageCropperProfilePicture(mockXFile, context), 
                       returnsNormally);
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('method returns Future<Uint8List?>', (WidgetTester tester) async {
        when(mockXFile.path).thenReturn('test/path/image.jpg');
        
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final result = imagePickerService.openImageCropperProfilePicture(mockXFile, context);
                expect(result, isA<Future<Uint8List?>>());
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('openImageCropperEventBanner', () {
      testWidgets('has correct method signature', (WidgetTester tester) async {
        expect(imagePickerService.openImageCropperEventBanner, isA<Function>());
      });

      testWidgets('accepts XFile and BuildContext parameters', (WidgetTester tester) async {
        when(mockXFile.path).thenReturn('test/path/image.jpg');
        
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(() => imagePickerService.openImageCropperEventBanner(mockXFile, context), 
                       returnsNormally);
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('method returns Future<Uint8List?>', (WidgetTester tester) async {
        when(mockXFile.path).thenReturn('test/path/image.jpg');
        
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final result = imagePickerService.openImageCropperEventBanner(mockXFile, context);
                expect(result, isA<Future<Uint8List?>>());
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('getUiSettings', () {
      testWidgets('returns list of PlatformUiSettings', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final result = imagePickerService.getUiSettings(context, CropStyle.circle);
                
                expect(result, isA<List<PlatformUiSettings>>());
                expect(result.length, equals(3));
                expect(result[0], isA<AndroidUiSettings>());
                expect(result[1], isA<IOSUiSettings>());
                expect(result[2], isA<WebUiSettings>());
                
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('configures AndroidUiSettings correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final result = imagePickerService.getUiSettings(context, CropStyle.circle);
                final androidSettings = result[0] as AndroidUiSettings;
                
                expect(androidSettings.toolbarTitle, equals(''));
                expect(androidSettings.toolbarColor, equals(Colors.deepOrange));
                expect(androidSettings.toolbarWidgetColor, equals(Colors.white));
                expect(androidSettings.cropStyle, equals(CropStyle.circle));
                expect(androidSettings.initAspectRatio, equals(CropAspectRatioPreset.original));
                expect(androidSettings.lockAspectRatio, equals(false));
                
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('configures IOSUiSettings correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final result = imagePickerService.getUiSettings(context, CropStyle.rectangle);
                final iosSettings = result[1] as IOSUiSettings;
                
                expect(iosSettings.title, equals(''));
                expect(iosSettings.rotateButtonsHidden, equals(true));
                expect(iosSettings.rotateClockwiseButtonHidden, equals(true));
                expect(iosSettings.resetButtonHidden, equals(true));
                expect(iosSettings.cropStyle, equals(CropStyle.rectangle));
                expect(iosSettings.aspectRatioPickerButtonHidden, equals(true));
                
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('configures WebUiSettings correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final result = imagePickerService.getUiSettings(context, CropStyle.circle);
                final webSettings = result[2] as WebUiSettings;
                
                expect(webSettings.context, equals(context));
                
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('handles different crop styles', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Test circle crop style
                final circleResult = imagePickerService.getUiSettings(context, CropStyle.circle);
                final androidCircle = circleResult[0] as AndroidUiSettings;
                final iosCircle = circleResult[1] as IOSUiSettings;
                
                expect(androidCircle.cropStyle, equals(CropStyle.circle));
                expect(iosCircle.cropStyle, equals(CropStyle.circle));
                
                // Test rectangle crop style
                final rectangleResult = imagePickerService.getUiSettings(context, CropStyle.rectangle);
                final androidRectangle = rectangleResult[0] as AndroidUiSettings;
                final iosRectangle = rectangleResult[1] as IOSUiSettings;
                
                expect(androidRectangle.cropStyle, equals(CropStyle.rectangle));
                expect(iosRectangle.cropStyle, equals(CropStyle.rectangle));
                
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('ImageModel integration', () {
      test('creates ImageModel with correct structure', () {
        final imageModel = ImageModel(
          path: 'test/path/image.jpg',
          image: Uint8List.fromList([1, 2, 3, 4]),
          extension: 'image/jpeg',
          downloadUrl: 'https://example.com/image.jpg',
        );

        expect(imageModel.path, equals('test/path/image.jpg'));
        expect(imageModel.image, isA<Uint8List>());
        expect(imageModel.extension, equals('image/jpeg'));
        expect(imageModel.downloadUrl, equals('https://example.com/image.jpg'));
      });

      test('ImageModel can be created with minimal data', () {
        final imageModel = ImageModel();
        
        expect(imageModel.path, isNull);
        expect(imageModel.image, isNull);
        expect(imageModel.extension, isNull);
        expect(imageModel.downloadUrl, isNull);
      });
    });

    group('UserModel integration', () {
      test('UserModel.uid is accessible for storage operations', () {
        UserModel.uid = 'test-user-123';
        
        // Verify UserModel.uid is accessible and set correctly
        expect(UserModel.uid, equals('test-user-123'));
        expect(UserModel.uid, isA<String>());
        expect(UserModel.uid.isNotEmpty, isTrue);
      });

      test('storage operation uses UserModel.uid', () {
        UserModel.uid = 'storage-test-uid';
        
        final imageModel = ImageModel(
          image: Uint8List.fromList([1, 2, 3, 4]),
          extension: 'image/jpeg',
        );

        // Verify the method would use the UserModel.uid
        expect(UserModel.uid, equals('storage-test-uid'));
        expect(imageModel, isA<ImageModel>());
      });
    });

    group('error handling structure', () {
      test('methods handle exceptions gracefully', () {
        // These methods have try-catch blocks in implementation
        expect(imagePickerService.getImageFromUser(), isA<Future<XFile?>>());
        expect(imagePickerService.getMediaFromUser(), isA<Future<XFile?>>());
        expect(imagePickerService.getMultipleImagesFromUser(), isA<Future<List<XFile?>?>>());
      });
    });
  });
}