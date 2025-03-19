import 'package:flutter/material.dart';

final ThemeData _darkTheme = ThemeData(
  //backgroundColor: const Color(0xFF1A1E25),
  cardColor: const Color(0xFF31353B),
  primaryColor: const Color(0xFF84a98c),
  primaryColorLight: const Color(0xFFFEC841),
  secondaryHeaderColor: Colors.white,
  //textSelectionColor: const Color(0xFF1A1E25),
  scaffoldBackgroundColor: const Color(0xFF0E1514),
  hintColor: const Color(0xFFA8A8A8),

);

final ThemeData _lightTheme = ThemeData(
  //backgroundColor: const Color(0xFFFCFCFC),
  cardColor: const Color(0xFFFAF7FF),
  primaryColor: const Color(0xFFFDB400),
  primaryColorLight: const Color(0xFFFEC841),
  secondaryHeaderColor: const Color(0xFF252A34),
  //textSelectionColor: const Color(0xFF1A1E25),
  scaffoldBackgroundColor: const Color(0xFFF7F8FC),
  hintColor: Colors.grey,
);

ThemeData getDarkTheme() => _darkTheme;
ThemeData getLightTheme() => _lightTheme;
