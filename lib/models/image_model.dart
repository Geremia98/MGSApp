import 'dart:convert';
import 'dart:typed_data';

class ImageModel {
  final Uint8List? image;
  final String? path;
  final String? extension;

  final String? downloadUrl;

  ImageModel({
    this.image,
    this.path,
    this.extension,
    this.downloadUrl,
  });

  String get base64Image => image != null ? base64Encode(image!) : '';

  Uint8List decodeImage() => base64Decode(base64Image);

  Map<String, dynamic> toPayload() {
    return {
      'image': base64Image,
      'extension': extension,
    };
  }
}
