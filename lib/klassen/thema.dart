// thema.dart
import "package:flutter/material.dart";

// Thema für die ganze App
/* Hier kann man verschiedene, app-weite Design Standards implementieren, z.B. für:
- Primär- und Akzentfarben
- AppBar 
- BottomAppBar
- Buttons (auch FloatingActionButtons)
und vieles mehr
*/

ThemeData thema = ThemeData(
  colorScheme: ColorScheme(
    primary: Colors.black,
    onPrimary: Colors.white,
    primaryVariant: Colors.black,
    secondary: Colors.black,
    onSecondary: Colors.white,
    secondaryVariant: Colors.black,
    background: Colors.white,
    onBackground: Colors.black,
    error: Colors.red.shade700,
    onError: Colors.white,
    brightness: Brightness.light,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  highlightColor: Colors.blue,
  textTheme: TextTheme(
    // TextStyle für die Titel von AppBars
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    // TextStyle für die zwei Überschriften der Startseite ("Eigene Fehlermeldungen" & "Sonstige Fehlermeldungen")
    headline2: TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
    ),
    // 16, schwarz, fett
    // TextStyle für kleinere, fett gedruckte Überschriften, etwa die Fehlerbeschreibung in den ListTiles in der Fehlerliste
    headline3: TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    // 16, weiß, fett
    headline4: TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    // 14, schwarz, fett
    headline5: TextStyle(
      fontSize: 14.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    // 14, weiß, fett
    // headline6: TextStyle(
    //   fontSize: 14.0,
    //   color: Colors.white,
    //   fontWeight: FontWeight.bold,
    // ),

    /// schwarzer, normaler Text
    bodyText1: TextStyle(
      color: Colors.black,
      fontSize: 14.0,
    ),

    /// weißer, normaler Text
    // bodyText2: TextStyle(
    //   color: Colors.white,
    //   fontSize: 14.0,
    // ),

    /// dunkelgrauer, normaler Text
    subtitle1: TextStyle(
      color: Colors.grey.shade800,
      fontSize: 14.0,
    ),

    /// dunkelgrauer, kleiner Text
    subtitle2: TextStyle(
      color: Colors.grey.shade800,
      fontSize: 12.0,
    ),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade600,
    space: 1,
  ),
  appBarTheme: AppBarTheme(backgroundColor: Colors.black),
);

ThemeData dunklesThema = ThemeData(
  primaryColor: Colors.blue,
);
