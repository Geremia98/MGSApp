import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/widgets/image_upload.dart';

Future<ImageModel> createTestImage() async {
  final Uint8List bytes = Uint8List.fromList(
    <int>[
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
      0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
      0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
      0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
    ],
  );
  return ImageModel(
    image: bytes,
    path: 'path',
    extension: 'extension',
  );
}


void main() {
  testWidgets('ImageUploadCard displays add image button when no initial image is provided', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImageUploadCard(),
        ),
      ),
    );

    // Verify that the add image button is displayed.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('ImageUploadCard displays initial image when provided', (WidgetTester tester) async {
    // Create a dummy image.
    final image = await createTestImage();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImageUploadCard(
            initialImage: image,
          ),
        ),
      ),
    );

    // Verify that the image is displayed.
    expect(find.byType(Image), findsOneWidget);
  });
}
