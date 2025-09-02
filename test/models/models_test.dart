
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/models/faq_couple.dart';
import 'package:mgs_app2/models/image_model.dart';

void main() {
  group('Models', () {
    group('FAQCouple', () {
      test('FAQCouple can be instantiated', () {
        const faq = FAQCouple(question: 'q', answer: 'a');
        expect(faq.question, 'q');
        expect(faq.answer, 'a');
      });
    });

    group('ImageModel', () {
      test('ImageModel can be instantiated', () {
        final image = Uint8List.fromList([1, 2, 3]);
        final model = ImageModel(
          image: image,
          path: '/path',
          extension: '.jpg',
          downloadUrl: '/url',
        );

        expect(model.image, image);
        expect(model.path, '/path');
        expect(model.extension, '.jpg');
        expect(model.downloadUrl, '/url');
      });

      test('ImageModel toPayload returns correct map', () {
        final image = Uint8List.fromList([1, 2, 3]);
        final model = ImageModel(
          image: image,
          extension: '.jpg',
        );

        final payload = model.toPayload();

        expect(payload['image'], 'AQID');
        expect(payload['extension'], '.jpg');
      });

      test('ImageModel base64Image returns correct string', () {
        final image = Uint8List.fromList([1, 2, 3]);
        final model = ImageModel(image: image);

        expect(model.base64Image, 'AQID');
      });

      test('ImageModel decodeImage returns correct Uint8List', () {
        final image = Uint8List.fromList([1, 2, 3]);
        final model = ImageModel(image: image);

        expect(model.decodeImage(), image);
      });
    });
  });
}
