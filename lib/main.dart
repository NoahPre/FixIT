//main.dart
import "./imports.dart";
import "./klassen/thema.dart";

Future<void> main() async {
  // wichtig für das Kamera Package
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(FixIt());
}

// TODO: alle istRegistriert in istAngemeldet umwandeln oder noch einen besseren Namen finden
// TODO: schauen wie oft wir BenutzerInfoProvider benutzen

// TODO: Meldung einbauen, wenn keine Internetverbindung vorhanden ist

List<CameraDescription> cameras = [];

class FixIt extends StatelessWidget {
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
        title: "FixIT",
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          // Startseite (initialRoute) der App
          "/": (context) => GemeldeteFehler(),
          // diese beiden Seiten werden nie durch namedRoutes aufgerufen, sind aber der Vollständigkeit halber auch hier
          // "/fehlerDetailansicht": (context) => FehlerDetailansicht(),
          // "/fehlerBehebung": (context) => Fehlerbehebung(),
          "/soforthilfe": (context) => Soforthilfe(),
          "/tutorial": (context) => Tutorial(),
          "/statistiken": (context) => Statistiken(),
          "/einstellungen": (context) => Einstellungen(),
          "/ueberUns": (context) => UeberUns(),
          "/registrierung": (context) => Registrierung(),
        },
      ),
    );
  }
}
