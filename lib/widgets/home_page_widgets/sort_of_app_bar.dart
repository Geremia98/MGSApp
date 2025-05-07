import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/theme_colors.dart';

class SortOfAppBar extends StatelessWidget {
  const SortOfAppBar(
      {super.key,
      required this.width,
      required this.iconData,
      required this.profileImage,
      required this.appConfig,
      required this.globalKey});

  final double width;
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
            padding: EdgeInsets.all(width * 0.01),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(width * 0.02), // Bordi arrotondati
              border: getCustomBorder(
                width: width * bigRoutingButtonBorderThickness,
                appConfig: appConfig,
              ),
            ),
            child: Icon(
              iconData, // Icona simile a quella mostrata
              size: width * 0.08, // Dimensione dell'icona
            ),
          ),
        ),
        const Expanded(
            child: SizedBox(
          width: 10,
        )),
        Container(
          width: width * 0.12,
          height: width * 0.12,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(profileImage),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(width * homeScreenProfilePicRadius)),
            border: Border.all(
              color: Colors.white,
              width: width * 0.001,
            ),
          ),
        ),
      ],
    );
  }
}