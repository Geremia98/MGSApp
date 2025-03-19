import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/theme_data.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = MyTheme.lightTheme;
  ThemeData get themeData => _themeData;
  bool isLight = true;

  void toggleTheme() {
    isLight = _themeData == MyTheme.lightTheme;
    isLight ? _themeData = MyTheme.nightTheme : _themeData = MyTheme.lightTheme;
    isLight = !isLight;
    notifyListeners();
  }
}
