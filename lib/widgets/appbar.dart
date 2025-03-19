import 'dart:io';
import 'package:flutter/material.dart';

import '../utilities/app_config.dart';
import 'font.dart';

const IconData backArrowIphone = Icons.arrow_back_ios;
const IconData backArrowAndroid = Icons.arrow_back;

AppBar buildAppBar(
  BuildContext context,
   {
     String text = '',
  bool hasLeading = false,
  Color? backgroundColor,
  Widget? suffixAction,
  IconData? icon,
  void Function(BuildContext context)? onBackPressed,
}) {
  AppConfig appConfig = AppConfig(context);

  onBackPressed ??= _onBackPressed;

  return AppBar(
    elevation: 0,
    titleSpacing: 0,
    actions: suffixAction == null ? null : [suffixAction],
    backgroundColor:
        backgroundColor ?? appConfig.getTheme().scaffoldBackgroundColor,
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        color: appConfig.getTheme().scaffoldBackgroundColor, // Set the background color of the flexible space
      ),
    ),
    title: Text(
      text,
      style: textStyleAppBar(context),
    ),
    leading: hasLeading
        ? Platform.isIOS
            ? IconButton(
                icon: Icon(
                  icon ?? backArrowIphone,
                  size: 16,
                  color: appConfig.getTheme().secondaryHeaderColor,
                ),
                onPressed: () => onBackPressed!(context),
              )
            : IconButton(
                icon: Icon(
                  icon ?? backArrowAndroid,
                  size: 16,
                  color: appConfig.getTheme().secondaryHeaderColor,
                ),
                onPressed: () => onBackPressed!(context),
              )
        : Container(),
  );
}

void _onBackPressed(BuildContext context) {
  Navigator.of(context).pop();
}


TextStyle textStyleAppBar(BuildContext context) {
  final AppConfig appConfig = AppConfig(context);
  return TextStyle(
    color: appConfig.getTheme().secondaryHeaderColor,
    fontSize: fontSizeAppBar,
    fontWeight: FontWeight.w600,
    overflow: TextOverflow.ellipsis,
  );
}
