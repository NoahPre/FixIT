//main.dart
// 1
import "package:flutter/material.dart";
// 2
import "./seiten/home.dart";
import "./klassen/thema.dart";
// Provider:
import "./klassen/provider/anmeldungProvider.dart";
// 3
import "package:provider/provider.dart";

main() => runApp(FixIt());

class FixIt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // wir benutzen hier das Package Provider für ein besseres State Management
    // für mehr Informationen siehe: https://pub.dev/packages/provider
    return MultiProvider(
      providers: [
        // Provider für die Anmeldung / Registrierung 
        ChangeNotifierProvider<AnmeldungProvider>.value(
          value: AnmeldungProvider(),
        ),
      ],
      child: MaterialApp(
        // Startseite der App 
        home: Home(),
        // wird in /klassen/thema.dart definiert
        theme: thema,
      ),
    );
  }
}
