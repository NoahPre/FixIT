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
var thema = ThemeData(
  primaryColor: Colors.black,
  accentColor: Colors.black,
  textTheme: TextTheme(
    // TODO: die richtige FontSize und FontWeight für standardmäßigen AppBar title herausfinden
    // TextStyle für die Titel von AppBars
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
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
    headline6: TextStyle(
      fontSize: 14.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),

    /// schwarzer, normaler Text
    bodyText1: TextStyle(
      color: Colors.black,
      fontSize: 14.0,
    ),

    /// weißer, normaler Text
    bodyText2: TextStyle(
      color: Colors.white,
      fontSize: 14.0,
    ),
  ),
  // weiße Icons
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade600,
    space: 1,
  ),
);

var dunklesThema = ThemeData(
  primaryColor: Colors.blue,
);
