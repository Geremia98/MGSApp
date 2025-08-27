import 'package:flutter/material.dart';
import 'package:mgs_app2/theme.dart';

class FakeTranslator implements TranslatorLike {
  @override
  Future<void> load(Locale locale) async {}
  @override
  Future<void> changeLanguage(BuildContext context, Locale newLocale) async {}
}
