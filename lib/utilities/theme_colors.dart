import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';

final ThemeData _darkTheme = ThemeData(
  //backgroundColor: const Color(0xFF1A1E25),
  cardColor: const Color.fromARGB(255, 0, 102, 255),
  primaryColor: const Color.fromARGB(255, 0, 255, 55),
  primaryColorLight: const Color.fromARGB(255, 255, 183, 0),
  secondaryHeaderColor: Colors.white,
  //textSelectionColor: const Color(0xFF1A1E25),
  scaffoldBackgroundColor: const Color(0xFF0E1514),
  hintColor: const Color(0xFFA8A8A8),

    //Da qua in poi ci sono i colori miei:
  /*coloreSfondoNight*/splashColor: const Color.fromRGBO(38, 45, 59, 1),
  /*ColoreTestoNight*/hoverColor: const Color.fromARGB(255, 239, 245, 255),
  /*coloreSfondoReminderNight*/highlightColor: const Color.fromARGB(255, 53, 65, 93),
  /*colorePuntatoreTextFieldNight*/focusColor: const Color.fromARGB(255, 71, 110, 184),
  /*coloreDescriptionTestNight*/dividerColor:  const Color.fromARGB(255, 177, 185, 197),
  /*coloreDisabledButtonNight*/disabledColor: const Color.fromARGB(255, 73, 79, 88),
  /*coloreErroreNight*/indicatorColor:  const Color.fromARGB(255, 207, 35, 23),


);

final ThemeData _lightTheme = ThemeData(

  fontFamily: 'Montserrat',
  iconTheme: const IconThemeData(
    color: Color.fromARGB(255, 0, 35, 99),
  ),
  
  //colore dei bordi delle card (quello di Default)
  cardColor: const Color.fromARGB(255, 0, 35, 99),

  //colore puntatore TextField, bottoni attivi, progressBar
  primaryColor: const Color.fromARGB(255, 253, 0, 177),
  primaryColorLight: const Color.fromARGB(255, 71, 254, 65),

  //colore dei Titoli
  secondaryHeaderColor: const Color.fromARGB(255, 48, 162, 94),

  //sfondo di tutta l'applicazione
  scaffoldBackgroundColor: Colors.white,
  
  hintColor: const Color.fromARGB(255, 255, 204, 0),

  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.amber), 
    displayMedium: TextStyle(color: Color.fromARGB(255, 143, 255, 7)),
    displaySmall: TextStyle(color: Color.fromARGB(255, 7, 255, 214)),
    headlineLarge: TextStyle(color: Color.fromARGB(255, 255, 85, 7)),
    headlineMedium: TextStyle(color: Color.fromARGB(255, 255, 7, 7)), 
    headlineSmall: TextStyle(color: Color.fromARGB(255, 7, 255, 226)), 
    titleLarge: TextStyle(color: Color.fromARGB(255, 28, 255, 7)),
    titleMedium: TextStyle(color: Color.fromARGB(255, 255, 28, 7)), 
    titleSmall: TextStyle(color: Colors.amber), 
    bodyLarge: TextStyle(color: Color.fromARGB(255, 7, 255, 255)),

    //colore di tutto il testo dell'applicazione
    bodyMedium: TextStyle(color: Color.fromARGB(255, 0, 35, 99),), 
    bodySmall: TextStyle(color: Color.fromARGB(255, 7, 102, 255)),
    labelLarge: TextStyle(color: Color.fromARGB(255, 7, 255, 135)),
    labelMedium: TextStyle(color: Color.fromARGB(255, 7, 32, 255)),
    labelSmall: TextStyle(color: Color.fromARGB(255, 7, 247, 255))
  ),

  //Da qua in poi ci sono i colori miei:
  /*coloreSfondoDay*/splashColor: Colors.white,
  /*ColoreTestoDay*/hoverColor: const Color.fromARGB(255, 0, 35, 99),

  //colore del Reminder nella HomeScreen
  highlightColor: const Color.fromARGB(255, 225, 235, 255),

  //colore delle miniIcons nella sezione dell'Evento in Detail
  focusColor: const Color.fromARGB(255, 0, 115, 222),

  //colore Description della schermata Evento in dettaglio
  /*coloreDescriptionTestDay*/dividerColor:  const Color.fromARGB(255, 40, 59, 93),
  /*coloreDisabledButtonDay*/disabledColor: const Color.fromARGB(255, 205, 218, 241),
  /*coloreErroreDay*/indicatorColor:  const Color.fromARGB(255, 227, 46, 33),

);

ThemeData getDarkTheme() => _darkTheme;
ThemeData getLightTheme() => _lightTheme;



Border getCustomBorder({
    double width = 1.0,
    AppConfig? appConfig,

  }) {
    return Border.all(
      width: width,
      color: appConfig!.getTheme().cardColor,
    );
}

BorderSide getCustomBorderSide({
    double width = 1.0,
    AppConfig? appConfig,
  }) {
    return BorderSide(
      width: width,
      color: appConfig!.getTheme().cardColor
    );
  }
  




//Classe per switchare il tema tra dark e ligh dal menù !!

// class ThemeProvider extends ChangeNotifier {
//   ThemeData _themeData = MyTheme.lightTheme;
//   ThemeData get themeData => _themeData;
//   bool isLight = true;

//   void toggleTheme() {
//     isLight = _themeData == MyTheme.lightTheme;
//     isLight ? _themeData = MyTheme.nightTheme : _themeData = MyTheme.lightTheme;
//     isLight = !isLight;
//     notifyListeners();
//   }
// }