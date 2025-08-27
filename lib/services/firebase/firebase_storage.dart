import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mime/mime.dart';

class FirebaseStorageService {
  FirebaseStorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;
  final FirebaseStorage _storage;

  Future<ImageModel?> getEventBannerImage(
    String eventId,
  ) async {
    // Get reference to your Firebase Storage bucket
    Reference reference = _storage.ref().child('events/$eventId/');
    // List all items with the given prefix
    try {
      ListResult result = await reference.listAll();

      print(result.items.length);

      Map<String, String> downloadUrls = {};

      for (Reference item in result.items) {
        return ImageModel(downloadUrl: await item.getDownloadURL());
      }

      return null;
    } catch (e) {
      print('Error fetching banner images: $e');
    }

    return null;
  }

  Future<ImageModel?> getUserProfileImage(
    String userUid,
  ) async {
    // Get reference to your Firebase Storage bucket
    Reference reference = _storage.ref().child('users/$userUid/');
    // List all items with the given prefix
    try {
      ListResult result = await reference.listAll();

      print(result.items.length);

      Map<String, String> downloadUrls = {};

      for (Reference item in result.items) {
        return ImageModel(downloadUrl: await item.getDownloadURL());
      }

      return null;
    } catch (e) {
      print('Error fetching banner images: $e');
    }

    return null;
  }

  String? getExtensionFromMimeType(String? mimeType) {
    if (mimeType == null) {
      return null;
    }

    const mimeMap = {
      'image/jpeg': 'jpg',
      'image/png': 'png',
      'image/gif': 'gif',
      'image/webp': 'webp',
      'image/bmp': 'bmp',
      'image/svg+xml': 'svg',
      'image/tiff': 'tiff',
      'image/x-icon': 'ico',
      'video/mp4': 'mp4',
      'video/x-msvideo': 'avi',
      'video/mpeg': 'mpeg',
      'video/quicktime': 'mov',
      'video/webm': 'webm',
      'audio/mpeg': 'mp3',
      'audio/wav': 'wav',
      'audio/ogg': 'ogg',
      'audio/webm': 'weba',
      'application/pdf': 'pdf',
      'application/zip': 'zip',
      'application/json': 'json',
      'text/plain': 'txt',
      'text/html': 'html',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document': 'docx',
      'application/msword': 'doc',
      'application/vnd.ms-excel': 'xls',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': 'xlsx',
    };

    return mimeMap[mimeType];
  }

  Future<bool> storeEventBannerImage(
    String eventId,
    ImageModel banner,
  ) async {
    // Get reference to your Firebase Storage bucket

    final String? extension = getExtensionFromMimeType(banner.extension);

    if (extension == null) {
      if (kDebugMode) {
        print("image extension from mime not found");
      }
      return false;
    }
    Reference reference = _storage.ref().child('events/$eventId/banner.$extension');
    // List all items with the given prefix

    if (banner.image == null) {
      return false;
    }
    try {
      await reference.putData(banner.image!);

      return true;
    } catch (e) {
      print('Error fetching banner images: $e');
    }

    return false;
  }
}