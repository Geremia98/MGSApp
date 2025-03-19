import 'package:flutter/material.dart';

class MyTheme {
  static Color coloreSfondoDay = Colors.white;
  static Color coloreTestoDay = const Color.fromARGB(255, 0, 35, 99);
  static Color coloreSfondoReminderDay =
      const Color.fromARGB(255, 225, 235, 255);
  static Color colorePuntatoreTextFieldDay =
      const Color.fromARGB(255, 0, 115, 222);
  static Color coloreDescriptionTestDay = const Color.fromARGB(255, 60, 69, 84);
  static Color coloreDisabledButtonDay =
      const Color.fromARGB(255, 205, 218, 241);
  static Color coloreErroreDay = Color.fromARGB(255, 227, 46, 33);

  static Color coloreSfondoNight = const Color.fromRGBO(38, 45, 59, 1);
  static Color coloreTestoNight = const Color.fromARGB(255, 239, 245, 255);
  static Color coloreSfondoReminderNight =
      const Color.fromARGB(255, 53, 65, 93);
  static Color colorePuntatoreTextFieldNight =
      const Color.fromARGB(255, 71, 110, 184);
  static Color coloreDescriptionTestNight =
      const Color.fromARGB(255, 177, 185, 197);
  static Color coloreDisabledButtonNight = Color.fromARGB(255, 73, 79, 88);
  static Color coloreErroreNight = Color.fromARGB(255, 207, 35, 23);

  static Border getCustomBorder({
    required BuildContext context,
    double width = 1.0,
  }) {
    return Border.all(
      width: width,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  static Color getSfondoReminder({
    required BuildContext context,
  }) {
    return (Theme.of(context).colorScheme.secondary == coloreTestoDay)
        ? coloreSfondoReminderDay
        : coloreSfondoReminderNight;
  }

  static Color getCiSonoButtonColor({
    required BuildContext context,
  }) {
    return (Theme.of(context).colorScheme.secondary == coloreTestoDay)
        ? coloreTestoDay
        : coloreTestoNight;
  }

  static Color getCiSonoButtonTextColor({
    required BuildContext context,
  }) {
    return (Theme.of(context).colorScheme.secondary == coloreTestoDay)
        ? coloreSfondoDay
        : coloreSfondoNight;
  }

  static Color getColorDisabledButton({
    required BuildContext context,
  }) {
    return (Theme.of(context).colorScheme.secondary == coloreTestoDay)
        ? coloreDisabledButtonDay
        : coloreDisabledButtonNight;
  }

  static Color getLighter({
    required BuildContext context,
  }) {
    return (Theme.of(context).colorScheme.secondary == coloreTestoDay)
        ? colorePuntatoreTextFieldDay
        : colorePuntatoreTextFieldNight;
  }

  static Color getCustomDescriptionColor({
    required BuildContext context,
  }) {
    return (Theme.of(context).colorScheme.secondary == coloreTestoDay)
        ? coloreDescriptionTestDay
        : coloreDescriptionTestNight;
  }

  static Color getErrorColor({
    required BuildContext context,
  }) {
    return (Theme.of(context).colorScheme.secondary == coloreTestoDay)
        ? coloreErroreDay
        : coloreErroreNight;
  }

  static BorderSide getCustomBorderSide({
    required BuildContext context,
    double width = 1.0,
  }) {
    return BorderSide(
      width: width,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: coloreSfondoDay,
    filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(coloreTestoDay))),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: coloreTestoDay),
    iconTheme: IconThemeData(
      color: coloreTestoDay,
    ),
    dividerTheme: DividerThemeData(
      color: coloreTestoDay,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: coloreTestoDay,
      ), //la scritta che va dentro a TExtField (quando scrivi)
      bodyMedium: TextStyle(color: coloreTestoDay), //Il colore delle scritte
    ),
    textSelectionTheme:
        TextSelectionThemeData(cursorColor: colorePuntatoreTextFieldDay),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle:
          TextStyle(color: coloreTestoDay), //colore hintText del textField
      floatingLabelStyle: TextStyle(
          color: colorePuntatoreTextFieldDay), //quando hint text va su in alto
      enabledBorder: OutlineInputBorder(
        //questo è il colore del bordo del TextField
        borderSide: BorderSide(width: 1, color: coloreTestoDay),
      ),
      focusedBorder: OutlineInputBorder(
        //questo è il colore di quando il TextField è premuto (si sta scrivendo dentro)
        borderSide: BorderSide(width: 2, color: colorePuntatoreTextFieldDay),
      ),
    ),
  );

  static ThemeData nightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor:
        coloreSfondoNight, //questo cambia un po' di cose ... è lo sfondo di ogni scaffold
  );
}
