import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';

class MySquaredIconButton extends StatelessWidget {
  final bool isEnable;
  final IconData icon;
  final Color activeColor;
  final Color disabledColor;
  final void Function() onTap;

  const MySquaredIconButton(
      {required this.activeColor,
      required this.disabledColor,
      required this.icon,
      required this.isEnable,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    AppConfig _appConfig = AppConfig(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: _appConfig.getHeight() * 0.8),
      child: GestureDetector(
        onTap: isEnable ? onTap : null,
        child: Container(
          padding: EdgeInsets.all(_appConfig.isTablet() ? 15 : 10),
          decoration: BoxDecoration(
              color: isEnable ? activeColor : disabledColor,
              borderRadius: BorderRadius.circular(
                  _appConfig.getWidth() * 2), // Bordi arrotondati
              border: Border.all(
                  color: _appConfig.getTheme().scaffoldBackgroundColor)),
          child: Icon(
            size: _appConfig.isTablet() ? 40 : 25,
            icon,
            color: _appConfig
                .getTheme()
                .scaffoldBackgroundColor, // Dimensione dell'icona
          ),
        ),
      ),
    );
  }
}
