import 'package:flutter/material.dart';

class AppConfig {
  late double _width;
  late double _height;
  late double _statusBarHeight;
  late ThemeData _theme;
  late Brightness _brightness;
  late BuildContext _context;

  double getWidth() => _width;
  double getHeight() => _height;
  double getStatusBarHeight() => _statusBarHeight;
  ThemeData getTheme() => _theme;
  Brightness getBrightness() => _brightness;
  BuildContext getContext() => _context;

  bool isTablet() => _width * 100 > 600;



  AppConfig(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    _statusBarHeight = MediaQuery.of(context).padding.top;
    _brightness = MediaQuery.of(context).platformBrightness;
    _theme = Theme.of(context);
    _width = w / 100;
    _height = h / 100;
    _context = context;
  }
}
