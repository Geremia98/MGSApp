import 'package:flutter/cupertino.dart';

double responsiveFontSize(BuildContext context, double baseSize) {
  final width = MediaQuery.of(context).size.width;
  if (width > 600) {
    return baseSize * 1.4;
  } else {
    return baseSize;
  }
}

const double fontSizeSmall = 12;
const double fontSizeMedium = 14;
const double fontSizeBig = 16;
const double fontSizeHuge = 20;
const double fontSizeButton = 16;
const double fontSizeTitle = 30;
const double fontSizeAppBar = 20;
const double fontSizeSubtitle = 14;
