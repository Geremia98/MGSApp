import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';

import '../utilities/app_config.dart';
import 'font.dart';

//test git
Widget buildTitle(
  BuildContext context, {
  String title = '',
  String subtitle = '',
  bool isSection = false,
  TextAlign textAlign = TextAlign.center,
}) {
  final AppConfig appConfig = AppConfig(context);
  return Container(
    width: appConfig.getWidth() * 100,
    padding: EdgeInsets.symmetric(horizontal: appConfig.getWidth() * paddingForCreationEventHorizontal),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: appConfig.getWidth() * 80,
          child: Text(
            title,
            style:
                isSection ? textStyleSection(context) : textStyleTitle(context),
            maxLines: 2,
            textAlign: textAlign,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        subtitle.isEmpty
            ? const SizedBox()
            : SizedBox(
                width: appConfig.getWidth() * 80,
                child: Text(
                  subtitle,
                  style: textStyleSubtitle(context),
                  maxLines: 4,
                  textAlign: textAlign,
                ),
              ),
        //buildLogo(context),
      ],
    ),
  );
}

TextStyle textStyleTitle(BuildContext context) {
  final AppConfig appConfig = AppConfig(context);
  return TextStyle(
    color: appConfig.getTheme().secondaryHeaderColor,
    fontSize: responsiveFontSize(context, fontSizeTitle),
    fontWeight: FontWeight.w600,
    overflow: TextOverflow.ellipsis,
  );
}

TextStyle textStyleSection(BuildContext context) {
  final AppConfig appConfig = AppConfig(context);
  return TextStyle(
    color: appConfig.getTheme().secondaryHeaderColor,
    fontSize: responsiveFontSize(context, fontSizeAppBar),
    fontWeight: FontWeight.w600,
    overflow: TextOverflow.ellipsis,
  );
}

TextStyle textStyleSubtitle(BuildContext context) {
  final AppConfig appConfig = AppConfig(context);
  return TextStyle(
    color: appConfig.getTheme().primaryColor,
    fontSize: responsiveFontSize(context, fontSizeSubtitle),
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis,
  );
}
