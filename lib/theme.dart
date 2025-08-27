
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/login_screens/login_screen.dart';
import 'package:mgs_app2/screens/main_screens/home_screen.dart';
import 'package:mgs_app2/services/translator/provider.dart';
import 'package:mgs_app2/wrapper.dart';
import 'package:mgs_app2/services/translator/translator.dart' as impl;

enum ThemeRoutePage {
  auth,
  home,
  loading,
}

class ThemeService extends StatefulWidget {
  final ThemeRoutePage routePage;
  final TranslatorLike? translator;

  const ThemeService({
    super.key,
    this.routePage = ThemeRoutePage.auth,
    this.translator,
  });

  @override
  State<StatefulWidget> createState() => _ThemeService();
}

abstract class TranslatorLike {
  Future<void> load(Locale locale);
  Future<void> changeLanguage(BuildContext context, Locale newLocale);
}

class _DefaultTranslatorAdapter implements TranslatorLike {
  final impl.Translator _inner = impl.Translator();

  @override
  Future<void> load(Locale locale) => _inner.load(locale);

  @override
  Future<void> changeLanguage(BuildContext context, Locale newLocale) =>
      _inner.changeLanguage(context, newLocale);
}

class _ThemeService extends State<ThemeService> {
  late TranslatorLike _translator; 
  Future<void>? _loadLanguages;

  @override
  void initState() {
    super.initState();
    _translator = widget.translator ?? _DefaultTranslatorAdapter();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeRoutePage routePage = widget.routePage;

    return LanguageProvider(
      locale: Localizations.localeOf(context),
      changeLocale: (Locale newLocale) async {
        await _translator.changeLanguage(context, newLocale);
        // No need to call _translator.load() here, it's already called in changeLanguage

        setState(() {
          _loadLanguages = null;
          // Rebuild the widget tree
        });
      },
      child: FutureBuilder(
            future: _loadLanguages ??= _translator.load(Localizations.localeOf(context)),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }

              switch (routePage) {
                case ThemeRoutePage.home:
                  return const HomeScreen();
                case ThemeRoutePage.loading:
                  return Container();
                case ThemeRoutePage.auth:
                  return const LoginScreen();
                default:
                  return const Wrapper();
              }
            },
      ),
    );
  }
}
