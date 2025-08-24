import 'package:flutter/cupertino.dart';
import 'package:mgs_app2/models/user_model.dart';
import 'package:mgs_app2/utilities/app_config.dart';

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
            ? Image.asset(
                'assets/images/male.jpg',
                fit: BoxFit.cover,
              )
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
