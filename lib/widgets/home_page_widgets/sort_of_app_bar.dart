import 'package:flutter/material.dart';
import 'package:mgs_app2/models/image_model.dart';
import 'package:mgs_app2/screens/main_screens/personal_screen.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_profile_pic.dart';

class SortOfAppBar extends StatelessWidget {
  const SortOfAppBar(
      {super.key,
      required this.iconData,
      required this.appConfig,
      required this.globalKey});

  final AppConfig appConfig;
  final IconData iconData;
  final GlobalKey<ScaffoldState> globalKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => {globalKey.currentState!.openDrawer()},
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  appConfig.getWidth() * 1.8), // Bordi arrotondati
              border: getCustomBorder(
                width: 0.5,
                appConfig: appConfig,
              ),
            ),
            child: Icon(
              iconData, // Icona simile a quella mostrata
              size: appConfig.getWidth() * 8, // Dimensione dell'icona
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PersonalScreen()),
          ),
          child: MyProfilePicture(
            appConfig: appConfig,
            borderThickness: 0.5,
            borderRadius: appConfig.getWidth() * 1.8,
            dimension: 45,
          ),
        ),
      ],
    );
  }
}
