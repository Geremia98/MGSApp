import 'package:flutter/cupertino.dart';
import 'package:mgs_app2/utilities/app_config.dart';

class MyProfilePicture extends StatelessWidget {
  const MyProfilePicture({
    super.key,
    required this.appConfig,
    required this.profileImage,
    required this.borderRadius,
    required this.borderThickness,
    required this.dimension,
  });

  final AppConfig appConfig;
  final String profileImage;
  final double dimension;
  final double borderThickness;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: appConfig.getWidth() * dimension,
      height: appConfig.getWidth() * dimension,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(profileImage),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(
            Radius.circular(appConfig.getWidth() * borderRadius)),
        border: Border.all(
          color: appConfig.getTheme().primaryColor,
          width: appConfig.getWidth() * borderThickness,
        ),
      ),
    );
  }
}