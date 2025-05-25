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
      secondary: Colors.indigoAccent.shade700,
      onSecondary: Colors.white,
      error: Colors.red.shade700,
      onError: Colors.white,
      brightness: Brightness.light,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    highlightColor: Colors.indigoAccent.shade400,
    textTheme: TextTheme(
      // TextStyle für die Titel von AppBars
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      // TextStyle für die zwei Überschriften der Startseite ("Eigene Fehlermeldungen" & "Sonstige Fehlermeldungen")
      displayMedium: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
      ),
      // 16, schwarz, fett
      // TextStyle für kleinere, fett gedruckte Überschriften, etwa die Fehlerbeschreibung in den ListTiles in der Fehlerliste
      displaySmall: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),

      /// schwarzer, normaler Text
      bodyLarge: TextStyle(
        color: Colors.black,
        fontSize: 14.0,
      ),

      // grauer, kleiner Text
      bodySmall: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 12.0,
      ),

      /// dunkelgrauer, normaler Text
      titleMedium: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 14.0,
      ),

      /// dunkelgrauer, kleiner Text
      titleSmall: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 12.0,
      ),
      // TextStyle für die Raumnummern der Einträge der Fehlerliste
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade600,
      space: 1,
    ),
    appBarTheme: AppBarTheme(backgroundColor: Colors.black),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
      backgroundColor: Colors.grey.shade800,
    ));

ThemeData dunklesThema = ThemeData(
  primaryColor: Colors.blue,
);
