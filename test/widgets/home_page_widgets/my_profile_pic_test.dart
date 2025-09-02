import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_profile_pic.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mockito/mockito.dart';
import '../../mocks.mocks.dart';

void main() {
  testWidgets('MyProfilePicture displays placeholder when no image is available', (WidgetTester tester) async {
    // Create a mock FirebaseStorageService.
    final mockStorageService = MockFirebaseStorageService();

    // When getUserProfileImage is called, return null.
    when(mockStorageService.getUserProfileImage(any)).thenAnswer((_) async => null);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return MyProfilePicture(
                appConfig: AppConfig(context),
                dimension: 100,
                borderRadius: 10,
                borderThickness: 1,
                storageService: mockStorageService,
              );
            }
          ),
        ),
      ),
    );

    // The widget will show a placeholder image.
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('MyProfilePicture displays image from network', (WidgetTester tester) async {
    // Create a mock FirebaseStorageService.
    final mockStorageService = MockFirebaseStorageService();

    // Create a dummy image.
    final image = ImageModel(
      image: null,
      path: 'path',
      extension: 'extension',
      downloadUrl: 'https://pudim.com.br/pudim.jpg',
    );

    // When getUserProfileImage is called, return the dummy image.
    when(mockStorageService.getUserProfileImage(any)).thenAnswer((_) async => image);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return MyProfilePicture(
                appConfig: AppConfig(context),
                dimension: 100,
                borderRadius: 10,
                borderThickness: 1,
                storageService: mockStorageService,
              );
            }
          ),
        ),
      ),
    );
    
    await tester.pumpAndSettle();

    // The widget will show the network image.
    expect(find.byType(Image), findsOneWidget);
  });
}
