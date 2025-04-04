
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mgs_app2/models/event_model.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mime/mime.dart';


class FirebaseStorageService {
  Future<ImageModel?> getEventBannerImage(
    String eventId,
  ) async {

    // Get reference to your Firebase Storage bucket
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child(
        'events/$eventId/banner/');
    // List all items with the given prefix
    try {
      ListResult result = await reference.listAll();

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

  Future<bool> storeEventBannerImage(
      String eventId,
      ImageModel banner,
      ) async {

    // Get reference to your Firebase Storage bucket
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child(
        'events/$eventId/banner/');
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
