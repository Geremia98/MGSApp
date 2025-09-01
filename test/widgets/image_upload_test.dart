
import 'dart:convert';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/widgets/image_upload.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ImageUploadCard', () {
    testWidgets('shows add image button when no initial image is provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: ImageUploadCard(),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows initial image when provided', (WidgetTester tester) async {
      final imageModel = ImageModel(
        image: base64Decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII='),
        path: 'test_path',
        extension: 'png',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: ImageUploadCard(
                initialImage: imageModel,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('uses correct decoration for ImageType.profilePicture', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: ImageUploadCard(
                imageType: ImageType.profilePicture,
              ),
            ),
          ),
        ),
      );

      final DottedBorder dottedBorder = tester.widget(find.byType(DottedBorder));
      expect(dottedBorder.radius, Radius.circular(10000));
    });

    testWidgets('uses correct decoration for ImageType.eventBanner', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: ImageUploadCard(
                imageType: ImageType.eventBanner,
              ),
            ),
          ),
        ),
      );

      final DottedBorder dottedBorder = tester.widget(find.byType(DottedBorder));
      expect(dottedBorder.radius, Radius.circular(20));
    });
  });
}
