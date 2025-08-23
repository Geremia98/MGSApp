import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mgs_app2/models/image_model.dart';

import '../models/user_model.dart';
import 'firebase/firestore_references.dart';

class ImagePickerService {
  bool _isPicking = false;
  //TODO fix this function
  Future<ImageModel?> storeImage(ImageModel? image) async {
    if (image == null) return null;

    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('$firestoreUsersCollection/${UserModel.uid}');

    //Create a reference to the location you want to upload to in firebase
    /*Reference reference =
        instance.ref().child(User.uid.replaceAll(' ', '_') + "/");*/

    final File file = File(image.path!);
    //Upload the file to firebase
    final UploadTask uploadTask = ref.putFile(file);

    // Waits till the file is uploaded then stores the download url
    final String location =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();

    return ImageModel(
      image: image.image,
      path: image.path,
      downloadUrl: location,
      extension: image.extension,
    );

    //return await _db.addUserImage(location);
  }

  Future<XFile?> getImageFromUser(
      {ImageSource source = ImageSource.gallery}) async {
    if (_isPicking) return null;

    final ImagePicker imagePicker = ImagePicker();
    try {
      _isPicking = true;
      final XFile? image = await imagePicker.pickImage(
        source: source,
      );
      return image;
    } catch (e) {
      return null;
    } finally {
      _isPicking = false;
    }
  }

  Future<XFile?> getMediaFromUser() async {
    if (_isPicking) return null;

    final ImagePicker imagePicker = ImagePicker();
    try {
      _isPicking = true;
      final XFile? media = await imagePicker.pickMedia();
      return media;
    } catch (e) {
      return null;
    } finally {
      _isPicking = false;
    }
  }

  Future<List<XFile?>?> getMultipleImagesFromUser() async {
    if (_isPicking) return null;

    final ImagePicker imagePicker = ImagePicker();
    try {
      _isPicking = true;
      final List<XFile?> media = await imagePicker.pickMultipleMedia();
      return media;
    } catch (e) {
      return null;
    } finally {
      _isPicking = false;
    }
  }

  Future<Uint8List?> openImageCropperProfilePicture(
      XFile imageFile, BuildContext context) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: getUiSettings(context, CropStyle.circle),
    );

    if (croppedFile == null) {
      return null;
    }

    return await croppedFile.readAsBytes();
  }

  Future<Uint8List?> openImageCropperEventBanner(
      XFile imageFile, BuildContext context) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      //cropStyle: CropStyle.rectangle,
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      uiSettings: getUiSettings(context, CropStyle.rectangle),
    );

    if (croppedFile == null) {
      return null;
    }

    return await croppedFile.readAsBytes();
  }

  List<PlatformUiSettings> getUiSettings(
      BuildContext context, CropStyle style) {
    return [
      AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          cropStyle: style,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: '',
        rotateButtonsHidden: true,
        rotateClockwiseButtonHidden: true,
        resetButtonHidden: true,
        cropStyle: style,
        aspectRatioPickerButtonHidden: true,
      ),
      WebUiSettings(
        context: context,
      ),
    ];
  }
}
