import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';

final ThemeData _lightTheme = ThemeData(

  fontFamily: 'Montserrat',
  iconTheme: const IconThemeData(
    color: Color.fromARGB(255, 0, 35, 99),
  ),
  
  //colore dei bordi delle card (quello di Default)
  cardColor: const Color.fromARGB(255, 0, 35, 99),

  //colore puntatore TextField, bottoni attivi, progressBar
  primaryColor: const Color.fromARGB(255, 0, 35, 99),

  //colore dei Titoli, inside the TextField
  secondaryHeaderColor: const Color.fromARGB(255, 0, 35, 99),

  //sfondo di tutta l'applicazione
  scaffoldBackgroundColor: Colors.white,
  
  hintColor: const Color.fromARGB(255, 255, 204, 0),

  textTheme: const TextTheme(

    //colore di tutto il testo dell'applicazione
    bodyMedium: TextStyle(color: Color.fromARGB(255, 0, 35, 99),), 
  ),

  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.white)
    )
  ),


  //Usato per il toggleSwitch quando è disattivato
  /*coloreSfondoDay*/splashColor: const Color.fromARGB(255, 199, 212, 236),
  /*ColoreTestoDay*/hoverColor: const Color.fromARGB(255, 0, 35, 99),

  //colore del Reminder nella HomeScreen
  highlightColor: const Color.fromARGB(255, 225, 235, 255),

  //colore delle miniIcons nella sezione dell'Evento in Detail
  focusColor: const Color.fromARGB(255, 0, 115, 222),

  //colore Description della schermata Evento in dettaglio
  /*coloreDescriptionTestDay*/dividerColor:  const Color.fromARGB(255, 40, 59, 93),
  /*coloreDisabledButtonDay*/disabledColor: const Color.fromARGB(255, 224, 226, 228),
  /*coloreErroreDay*/indicatorColor:  const Color.fromARGB(255, 227, 46, 33),

  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle()
  )
);



final ThemeData _darkTheme = ThemeData(

  fontFamily: 'Montserrat',
  iconTheme: const IconThemeData(
    color: Color.fromARGB(255, 239, 245, 255),
  ),
  
  //colore dei bordi delle card (quello di Default)
  cardColor: const Color.fromARGB(255, 239, 245, 255),

  //colore puntatore TextField, bottoni attivi
  primaryColor: const Color.fromARGB(255, 239, 245, 255),

  //colore dei Titoli, inside the TextField
  secondaryHeaderColor: const Color.fromARGB(255, 239, 245, 255),

  //sfondo di tutta l'applicazione
  scaffoldBackgroundColor: const Color.fromRGBO(38, 45, 59, 1),

  textTheme: const TextTheme(
    //colore di tutto il testo dell'applicazione
    bodyMedium: TextStyle(color: Color.fromARGB(255, 239, 245, 255),
), 
  ),

  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.amber)
    )
  ),

  //colore del Reminder nella HomeScreen
  highlightColor: const Color.fromARGB(255, 53, 65, 93),

  //colore delle miniIcons nella sezione dell'Evento in Detail
  focusColor: const Color.fromARGB(255, 249, 251, 255),


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
  




