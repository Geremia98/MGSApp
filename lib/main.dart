import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/my_theme_data.dart';
import 'package:mgs_app2/wrapper.dart';
import 'package:provider/provider.dart';


import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  runApp( ChangeNotifierProvider(
    create: (_) => BrightnessManager(),
    child: const MyApp(),
  ),);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final brightnessManager = Provider.of<BrightnessManager>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('it', 'IT'),
      ],
      theme: brightnessManager.brightness == Brightness.light
          ? getLightTheme()
          : getDarkTheme(),
      home: const Wrapper(),
    );
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      Provider.of<BrightnessManager>(context, listen: false).toggleBrightness();
    }
    super.didChangePlatformBrightness();
  }
}

class BrightnessManager extends ChangeNotifier {
  static final BrightnessManager _instance = BrightnessManager._internal();
  factory BrightnessManager() => _instance;

  Brightness _brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

  Brightness get brightness => _brightness;

  BrightnessManager._internal();

  void toggleBrightness() {
    _brightness = (_brightness == Brightness.light) ? Brightness.dark : Brightness.light;
    _updateSystemUIOverlay();
    notifyListeners(); // Notifica i listener per aggiornare la UI
  }

  void _updateSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      _brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
    );
  }
}

