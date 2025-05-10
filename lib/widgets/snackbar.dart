import 'package:flutter/material.dart';

import '../utilities/app_config.dart';
import '../utilities/my_theme_data.dart';
import 'font.dart';

class SnackBarStyle {

  final BuildContext context;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  late double bottomPadding;
  late AppConfig _appConfig;

  SnackBarStyle(this.context, this._scaffoldKey) {
    _appConfig = AppConfig(context);
    bottomPadding = _appConfig.getHeight();
  }

  bool isSnackBarShowed = false;

  void showSnackBar(String text, {double? bottomPadding}) {

    if (isSnackBarShowed) return;
    if (_scaffoldKey.currentState == null) return;

    isSnackBarShowed = true;
    ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 1,
      margin: EdgeInsets.only(
        left: _appConfig.getWidth() * 10,
        right: _appConfig.getWidth() * 10,
        bottom: bottomPadding ?? this.bottomPadding,
      ),
      backgroundColor: getDarkTheme().highlightColor.withOpacity(0.9),
      content: Text(text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          style: textStyleSnackBar(context)),
      duration: const Duration(seconds: 3),
    )).closed.then((value) => isSnackBarShowed = false);
  }
}

TextStyle textStyleSnackBar(BuildContext context) => TextStyle(
  color: AppConfig(context).getTheme().secondaryHeaderColor,
  fontWeight: FontWeight.w600,
  fontSize: fontSizeMedium,
);