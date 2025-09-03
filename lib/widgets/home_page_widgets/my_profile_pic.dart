import 'package:flutter/cupertino.dart';
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
    this.storageService,
  });

  final AppConfig appConfig;
  final double dimension;
  final double borderThickness;
  final double borderRadius;
  final FirebaseStorageService? storageService;

  @override
  Widget build(BuildContext context) {
    final FirebaseStorageService storage = storageService ?? FirebaseStorageService();

    return Container(
      width: appConfig.getWidth() * dimension,
      height: appConfig.getWidth() * dimension,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(appConfig.getWidth() * borderRadius)),
        border: Border.all(
          color: appConfig.getTheme().primaryColor,
          width: appConfig.getWidth() * borderThickness,
        ),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(appConfig.getWidth() * borderRadius),
        child: UserModel.profilePic == null ||
                UserModel.profilePic!.downloadUrl == null
            ? FutureBuilder(
                future: storage.getUserProfileImage(UserModel.uid),
                builder:
                    (BuildContext context, AsyncSnapshot<ImageModel?> snap) {
                  if (snap.connectionState != ConnectionState.done || snap.data == null) {
                    print(UserModel.uid);
                    return Image.asset(
                      'assets/images/male.jpg',
                      fit: BoxFit.cover,
                    );
                  }

                  print("set profile pic");


                  UserModel.profilePic = snap.data;

                  return Image.network(
                    UserModel.profilePic!.downloadUrl!,
                    fit: BoxFit.cover,
                    cacheHeight: 50,
                    cacheWidth: 50,
                  );
                })
            : Image.network(
                UserModel.profilePic!.downloadUrl!,
                fit: BoxFit.cover,
                cacheHeight: 50,
                cacheWidth: 50,
              ),
      ),
    );
  }
}
