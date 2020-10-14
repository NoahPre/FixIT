//main.dart
import "./imports.dart";
import "./klassen/thema.dart";

// passwort für melder: winniethepou

main() => runApp(FixIt());

// TODO: wichtige Anmeldedaten zum Server zu .gitignore hinzufügen

// TODO: alle istRegistriert in istAngemeldet umwandeln oder noch einen besseren Namen finden
// TODO: schauen wie oft ich BenutzerInfoProvider benutze
// TODO: standardmäßiges Datumsschreibweise festlegen

class FixIt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // wir benutzen hier Provider für ein besseres State Management
    // für mehr Informationen siehe: https://pub.dev/packages/provider
    return MultiProvider(
      providers: [
        // Provider für die Anmeldung / Registrierung
        ChangeNotifierProvider<BenutzerInfoProvider>.value(
          value: BenutzerInfoProvider(),
        ),
        // Provider für die Fehlerliste
        ChangeNotifierProvider<FehlerlisteProvider>.value(
          value: FehlerlisteProvider(),
        ),
      ],
      child: MaterialApp(
        // wird in /klassen/thema.dart definiert
        theme: thema,
        // darkTheme: dunklesThema,
        initialRoute: "/",
        routes: {
          "/": (context) => Home(),
          // Startseite (initialRoute) der App
          "/gemeldeteFehler": (context) => GemeldeteFehler(),
          "/fehlerDetailansicht": (context) => FehlerDetailansicht(),
          "/fehlerBehebung": (context) => Fehlerbehebung(),
          "/soforthilfe": (context) => Soforthilfe(),
          "/tutorial": (context) => Tutorial(),
          "/statistiken": (context) => Statistiken(),
          "/einstellungen": (context) => Einstellungen(),
          "/ueberUns": (context) => UeberUns(),
        },
      ),
    );
  }
}
