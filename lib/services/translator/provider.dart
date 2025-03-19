import 'package:flutter/material.dart';

class LanguageProvider extends InheritedWidget {
  final Locale locale;
  final Function(Locale) changeLocale;

  const LanguageProvider({
    Key? key,
    required this.locale,
    required this.changeLocale,
    required Widget child,
  }) : super(key: key, child: child);

  static LanguageProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LanguageProvider>()!;
  }

  // Additional static method for more convenient access
  static LanguageProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LanguageProvider>();
  }

  @override
  bool updateShouldNotify(LanguageProvider oldWidget) {
    return oldWidget.locale != locale;
  }
}
