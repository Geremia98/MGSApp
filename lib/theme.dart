
import 'package:flutter/material.dart';
import 'package:mgs_app2/screens/login_screens/login_screen.dart';
import 'package:mgs_app2/screens/other_screens/home_screen.dart';
import 'package:mgs_app2/services/translator/provider.dart';
import 'package:mgs_app2/services/translator/translator.dart';
import 'package:mgs_app2/wrapper.dart';

enum ThemeRoutePage {
  auth,
  home,
  loading,
}

class ThemeService extends StatefulWidget {
  final ThemeRoutePage routePage;

  const ThemeService({
    super.key,
    this.routePage = ThemeRoutePage.auth,
  });

  @override
  State<StatefulWidget> createState() => _ThemeService();
}

class _ThemeService extends State<ThemeService> {
  late Translator _translator; // Maintain an instance of Translator
  Future<void>? _loadLanguages;

  @override
  void initState() {
    super.initState();
    _translator = Translator();
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
