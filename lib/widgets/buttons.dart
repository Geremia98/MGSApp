import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/theme_colors.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.appConfig,
  });

  final IconData icon;
  final void Function() onTap;
  final AppConfig appConfig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: appConfig.getHeight() * 0.8),
      child: Container(
        margin: EdgeInsets.only(left: appConfig.getWidth() * 4),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(appConfig.getWidth() * 1),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(appConfig.getWidth() * 2), // Bordi arrotondati
              border: getCustomBorder(
                appConfig: appConfig,
                width: appConfig.getWidth() * 0.07,
              ),
            ),
            child: Icon(
              size: appConfig.getWidth() * 7.5,
              icon, // Dimensione dell'icona
            ),
          ),
        ),
      ),
    );
  }
}