import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';

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
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(appConfig.getWidth() * 1.5),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(appConfig.getWidth() * 2), // Bordi arrotondati
            border: getCustomBorder(
              appConfig: appConfig,
              width: appConfig.getWidth() * 0.07,
            ),
          ),
          child: Icon(
            size: appConfig.getWidth() * 6.5,
            icon, // Dimensione dell'icona
          ),
        ),
      ),
    );
  }
}