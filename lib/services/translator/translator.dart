import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Translator {
  static final Translator _instance = Translator._internal();

  factory Translator() {
    return _instance;
  }

  Translator._internal();

  Future<void> addTranslationsFromJson(String path) async {

    try {
      final jsonString = await rootBundle
          .loadString(path);

      final Map<String, dynamic> decodedMap = json.decode(jsonString);

      _translations.addAll(Map<String, String>.fromEntries(
        decodedMap.entries
            .map((entry) => MapEntry(entry.key, entry.value.toString())),
      ));

    } catch (e) {
      if (kDebugMode) {
        print('Error decoding JSON: $e');
      }
    }
  }

  Future<void> load(Locale locale) async {

    if (_translations.isNotEmpty) {
      return;
    }

    _currentLocale ??= locale;

    await addTranslationsFromJson('resources/languages/${_currentLocale!.languageCode}.json');
    await addTranslationsFromJson('resources/languages/errors/${_currentLocale!.languageCode}.json');

  }

  final Map<String, String> _translations = {};

  String translate(String key) {
    return _translations[key] ?? key;
  }

  Locale? _currentLocale;

  void setLocale(Locale locale) {
    // You can add additional logic here if needed
    _currentLocale = locale;
    print('Setting locale to: ${locale.languageCode}');
  }

  Future<void> changeLanguage(BuildContext context, Locale locale) async {

    print("change language");
    final currentContext = context;
    setLocale(locale);

    // Use the currentContext inside the async part
    _translations.clear();
    await load(locale);


    // Rebuild the widget tree
    //Navigator.of(currentContext).popUntil((route) => route.isFirst);
  }
}
