import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/main_screens/personal_screen.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/theme_colors.dart';
import 'package:mgs_app2/widgets/home_page_widgets/my_profile_pic.dart';

class SortOfAppBar extends StatelessWidget {
  const SortOfAppBar(
      {super.key,
      required this.iconData,
      required this.profileImage,
      required this.appConfig,
      required this.globalKey});

  final String profileImage;
  final AppConfig appConfig;
  final IconData iconData;
  final GlobalKey<ScaffoldState> globalKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => {
            debugPrint('bottone menu premuto'),
            globalKey.currentState!.openDrawer()
          },
          child: Container(
            padding: EdgeInsets.all(appConfig.getWidth() * 1.2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  appConfig.getWidth() * 1.8), // Bordi arrotondati
              border: getCustomBorder(
                width: appConfig.getWidth() * bigRoutingButtonBorderThickness,
                appConfig: appConfig,
              ),
            ),
            child: Icon(
              iconData, // Icona simile a quella mostrata
              size: appConfig.getWidth() * 8, // Dimensione dell'icona
            ),
          ),
        ),
        const Expanded(
            child: SizedBox(
          width: 10,
        )),
        GestureDetector(
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonalScreen()),
              ),
          child: MyProfilePicture(
            appConfig: appConfig, 
            profileImage: profileImage,
            borderThickness: homeScreenProfilePicBorderThickness,
            borderRadius: homeScreenProfilePicBorderRadius,
            dimension: homeScreenProfilePicDimension,
          ),
        ),
      ],
    );
  }
}


