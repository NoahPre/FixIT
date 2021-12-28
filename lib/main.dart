//main.dart
import "./imports.dart";
import "./klassen/thema.dart";

Future<void> main() async {
  // wichtig für das Kamera Package
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(FixIT());
}

// TODO: schauen wie oft wir BenutzerInfoProvider benutzen (und ihn möglichst wenig benutzen wegen der Performance)

List<CameraDescription> cameras = [];

class FixIT extends StatelessWidget {
  Widget build(BuildContext context) {
    FehlerlisteProvider fehlerlisteProvider = FehlerlisteProvider();
    BenutzerInfoProvider benutzerInfoProvider =
        BenutzerInfoProvider(fehlerlisteProvider: fehlerlisteProvider);
    // wir benutzen hier Provider für ein besseres State Management
    // für mehr Informationen siehe: https://pub.dev/packages/provider
    return MultiProvider(
      providers: [
        // Provider für die Anmeldung / Registrierung
        ChangeNotifierProvider<BenutzerInfoProvider>.value(
          value: benutzerInfoProvider,
        ),
        // Provider für die Fehlerliste
        ChangeNotifierProvider<FehlerlisteProvider>.value(
          value: fehlerlisteProvider,
        ),
        // Provider für den Authentifizierungs Status des Benutzers
        StreamProvider<bool?>.value(
          value: benutzerInfoProvider.authentifizierungStream,
          initialData: null,
        ),
        // Provider für die Schule des Benutzers
        StreamProvider<String>.value(
          value: benutzerInfoProvider.schuleStream,
          initialData: "",
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
          "/registrierung": (context) => Anmeldung(),
        },
      ),
    );
  }
}
