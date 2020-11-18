// home.dart
import "../imports.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context);

    return FutureBuilder<bool>(
      future: benutzerInfoProvider.authentifizierung(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        return 
        // solange die Funktion am laufen ist, wird ein Ladedonut angezeigt
        snapshot.hasData
            ? snapshot.data
                // wird angezeigt, wenn der User angemeldet ist, also wenn istRegistriert in SharedPreferences true ist
                ? GemeldeteFehler()
                // wird angezeigt, wenn der User nicht angemeldet ist, also wenn istRegistriert in SharedPreferences false ist
                : Registrierung()
            :
            // TODO: das hier evtl. entfernen
            // wird angezeigt, während istUserAngemeldet() ausgeführt wird

            Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}
