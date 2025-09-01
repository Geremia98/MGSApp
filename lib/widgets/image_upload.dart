import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../models/image_model.dart';
import '../services/picker.dart';
import '../utilities/app_config.dart';

enum ImageType {
  profilePicture,
  eventBanner,
}


BoxDecoration profilePictureDecoration(BuildContext context) {
  final AppConfig appConfig = AppConfig(context);
  return BoxDecoration(
    color: appConfig.getTheme().cardColor,
    shape: BoxShape.circle,
    //boxShadow: boxShadowCard,
  );
}

BoxDecoration eventBannerImageDecoration(BuildContext context) {
  final AppConfig appConfig = AppConfig(context);
  return BoxDecoration(
    color: appConfig.getTheme().cardColor,
    /*borderRadius: BorderRadius.circular(borderRadiusCard),
    boxShadow: boxShadowCard,*/
  );
}



class ImageUploadCard extends StatefulWidget {
  final void Function(ImageModel? image)? onImagePicked;
  final ImageType imageType;
  final ImageModel? initialImage;
  final bool keepLatestImageShown;
  final double width;
  final double height;

  final ImagePickerService? service;

  const ImageUploadCard({
    this.width = 100,
    this.height = 100,
    this.imageType = ImageType.eventBanner,
    this.onImagePicked,
    this.initialImage,
    this.keepLatestImageShown = true,
    this.service,
    super.key,
  });

  @override
  State<ImageUploadCard> createState() => _ImageUploadCardState();
}

class _ImageUploadCardState extends State<ImageUploadCard> {
  late final ImagePickerService service;
  late AppConfig appConfig;
  XFile? image;
  ImageModel? croppedImage;
  late double width;
  late double height;

  late bool keepLatestImageShown;
  late ImageType imageType;
  late void Function(ImageModel? image)? onImagePicked;

  @override
  void initState() {
    service = widget.service ?? ImagePickerService();
    croppedImage = widget.initialImage;
    imageType = widget.imageType;
    onImagePicked = widget.onImagePicked;
    keepLatestImageShown = widget.keepLatestImageShown;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appConfig = AppConfig(context);

    late BoxDecoration decoration;

    height = widget.height;
    width = widget.width;

    switch (imageType) {
      case ImageType.profilePicture:
        {
          decoration = profilePictureDecoration(context);
          //height = 180;
          //width = 180;
          break;
        }
      case ImageType.eventBanner:
        {
          decoration = eventBannerImageDecoration(context);
          //height = 180;
          //width = 300;
          break;
        }
    }

    print(croppedImage == null);
    return GestureDetector(
      onTap: getImage,
      child: croppedImage == null || !keepLatestImageShown
            ? buildAddImage()
            : buildImage(),
    );
  }

  Future<void> getImage() async {
    XFile? image = await service.getImageFromUser();

    if (image == null) {
      if (kDebugMode) {
        print('picked image value is null');
      }
      return;
    }

    Uint8List? imageCropped;

    switch (imageType) {
      case ImageType.profilePicture:
        {
          imageCropped =
          await service.openImageCropperProfilePicture(image, context);
          break;
        }
      case ImageType.eventBanner:
        {
          imageCropped =
          await service.openImageCropperEventBanner(image, context);
          break;
        }
    }

    if (imageCropped == null) {
      if (kDebugMode) {
        print('image cropper value is null');
      }
      return;
    }

    String? mimeType = lookupMimeType(image!.path, headerBytes: await image.readAsBytes());
    setState(() {

      this.image = image;
      croppedImage = ImageModel(
        image: imageCropped!,
        path: image!.path,
        extension: mimeType,
      );

    });

    if (onImagePicked != null) {
      onImagePicked!(croppedImage);
    }
  }

  Widget buildAddImage() {
    return DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(imageType == ImageType.profilePicture ? 10000 : 20),
          dashPattern: [10, 10],
          color: Colors.grey.withOpacity(0.2),
          strokeWidth: 2.5,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: height * 0.2,
                  height: height * 0.2,
                  decoration: BoxDecoration(
                    color: appConfig.getTheme().primaryColor,
                    borderRadius:
                    BorderRadius.all(Radius.circular(width * 0.2)),
                  ),
                  child: Icon(
                    Icons.add,
                    color: appConfig.getTheme().scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget buildImage() {
    if (croppedImage == null) {
      return Container();
    }

    late double radius;

    switch (imageType) {
      case ImageType.profilePicture:
        {
          radius = 1000;
          break;
        }
      case ImageType.eventBanner:
        {
          radius = 20;
          break;
        }
    }

    return Container(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        // Adjust the border radius as needed
        child: Stack(
          children: [
            Image.memory(
              croppedImage!.image!,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Icon(
                Icons.edit,
                color: appConfig.getTheme().scaffoldBackgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}