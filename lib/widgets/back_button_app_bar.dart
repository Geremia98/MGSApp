import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';
import 'package:mgs_app2/utilities/theme_colors.dart';

class BackButtonAppBar extends StatelessWidget {
  const BackButtonAppBar(
      {super.key,
      required this.iconData,
      required this.appConfig,});

  final AppConfig appConfig;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(
                context,
              ),
          child: Container(
            padding: EdgeInsets.all(appConfig.getWidth() * 1.2),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(appConfig.getWidth() * 1.8), // Bordi arrotondati
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
      ],
    );
  }
}