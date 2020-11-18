//main.dart
import "./imports.dart";
import "./klassen/thema.dart";

// passwort für melder: winniethepou

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(FixIt());
}

// TODO: alle istRegistriert in istAngemeldet umwandeln oder noch einen besseren Namen finden
// TODO: schauen wie oft wir BenutzerInfoProvider benutzen

// TODO: die IDs der Fehler mit nem anderm Algorithmus machen, z.B. mit de uuid package
// TODO: Meldung einbauen, wenn keine Internetverbindung vorhanden ist

List<CameraDescription> cameras = [];

class FixIt extends StatefulWidget {
  @override
  _FixItState createState() => _FixItState();
}

class _FixItState extends State<FixIt> {
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
          // Startseite (initialRoute) der App
          "/": (context) => Home(),
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
