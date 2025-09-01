import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/services/firebase/firebase_storage.dart';
import 'package:mgs_app2/utilities/app_config.dart';

import '../../models/image_model.dart';

class MyProfilePicture extends StatelessWidget {
  const MyProfilePicture({
    super.key,
    required this.appConfig,
    required this.borderRadius,
    required this.borderThickness,
    required this.dimension,
  });

  final AppConfig appConfig;
  final double dimension;
  final double borderThickness;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final FirebaseStorageService storageService = FirebaseStorageService();

    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(borderRadius)),
        border: borderThickness == 0 ? Border.all(
          color: appConfig
              .getTheme()
              .scaffoldBackgroundColor,
          width: 0,
        ) : Border.all(
          color: appConfig
              .getTheme()
              .primaryColor,
          width: borderThickness,
        ),
      ),
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(borderRadius),
        child: UserModel.profilePic == null ||
            UserModel.profilePic!.downloadUrl == null
            ? FutureBuilder(
            future: storageService.getUserProfileImage(UserModel.uid),
            builder:
                (BuildContext context, AsyncSnapshot<ImageModel?> snap) {
              if (snap.connectionState != ConnectionState.done ||
                  snap.data == null) {
                print(UserModel.uid);
                return Image.asset(
                  'assets/images/male.jpg',
                  fit: BoxFit.cover,
                );
              }

              UserModel.profilePic = snap.data;

              return CachedNetworkImage(
                imageUrl: UserModel.profilePic!.downloadUrl!,
                fit: BoxFit.cover,
                memCacheWidth: dimension.toInt() + 50,
                memCacheHeight: dimension.toInt() + 50,
                placeholder: (context, url) =>
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.saturation,
                      ),
                      child: Image.asset(
                        'assets/images/male.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                errorWidget: (context, url, error) =>
                    Image.asset(
                      'assets/images/male.jpg',
                      fit: BoxFit.cover,
                    ),
              );
            })
            : CachedNetworkImage(
          imageUrl: UserModel.profilePic!.downloadUrl!,
          fit: BoxFit.cover,
          memCacheWidth: dimension.toInt() + 50,
          memCacheHeight: dimension.toInt() + 50,
          placeholder: (context, url) =>
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.saturation,
                ),
                child: Image.asset(
                  'assets/images/male.jpg',
                  fit: BoxFit.cover,
                ),
              ),
          errorWidget: (context, url, error) =>
              Image.asset(
                'assets/images/male.jpg',
                fit: BoxFit.cover,
              ),
        ),
      ),
    );
  }
}
