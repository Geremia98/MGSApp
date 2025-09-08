import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgs_app2/wrapper.dart';
import 'package:mgs_app2/screens/login_screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mgs_app2/main.dart' show BrightnessManager;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:mgs_app2/theme.dart' show TranslatorLike;


class _FakeTranslator implements TranslatorLike {
  @override
  Future<void> load(Locale locale) async {}
  @override
  Future<void> changeLanguage(BuildContext context, Locale newLocale) async {}
}

void main() {
  testWidgets('Render senza auth reale (mostra LoginScreen)', (tester) async {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (!details.toString().contains('overflowed') && 
          !details.toString().contains('RenderFlex')) {
        throw details.exception;
      }
    };

    try {
      final view = tester.view;
      view.devicePixelRatio = 1.0;                    
      view.physicalSize = const Size(1080, 2400);     
      addTearDown(() {
        view.resetPhysicalSize();
        view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => BrightnessManager(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('it', 'IT'),
          ],
          home: Wrapper(
            userStreamOverride: Stream<fb.User?>.value(null),
            userFutureOverride: Future.value(null),
            translatorOverride: _FakeTranslator(),
          ),
        ),
      ),
    );

      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    } finally {
      FlutterError.onError = originalOnError;
    }
  });
}
