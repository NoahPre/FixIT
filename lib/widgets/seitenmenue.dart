// seitenmenue.dart
import "../imports.dart";

class Seitenmenue extends StatelessWidget {
  final String aktuelleSeite;
  String gemeldeteFehlerAnzahl;

  Seitenmenue({this.aktuelleSeite}) {
    anzahlAnGemeldetenFehlern();
  }

  // TODO: das hier intelligenter machen
  Future<void> anzahlAnGemeldetenFehlern() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    gemeldeteFehlerAnzahl = sharedPreferences.getInt("anzahlAnGefixtenFehlern").toString();
  }

  @override
  Widget build(BuildContext context) {


    ThemeData thema = Theme.of(context);

    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context);

    Size deviceSize = MediaQuery.of(context).size;

    return Drawer(
      
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(Icons.person),
                      backgroundColor: thema.primaryColor,
                      foregroundColor: Colors.white,
                      minRadius: deviceSize.width * 0.07,
                    ),
                    SizedBox(
                      width: deviceSize.width * 0.025,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        
                        const SizedBox(
                          height: 5.0,
                        ),
                        benutzerInfoProvider.istFehlermelder
                            ? Text("Fehlermelder")
                            : Text("Fehlerbeheber"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                // TODO: richtigen gefixte Fehler Zähler erstellen
                Flexible(
                  child: benutzerInfoProvider.istFehlermelder
                      ? Text("Anzahl an gemeldeten Fehlern: 27")
                      : Text("Anzahl an gefixten Fehlern: " + gemeldeteFehlerAnzahl),
                ),
              ],
            ),
          ),
          // TODO: hier komischen Abstand wegmachen 
          ListTile(
            title: Text("Gemeldete Fehler"),
            onTap: () {
              if (this.aktuelleSeite == "/gemeldeteFehler") {
                // lässt das Seitenmenü einklappen
                Navigator.pop(context);
              } else {
                // lässt das Seitenmenü einklappen
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/gemeldeteFehler");
              }
            },
          ),
          Divider(),
          ListTile(
            title: Text("Soforthilfe"),
            onTap: () {
              if (this.aktuelleSeite == "/soforthilfe") {
                // lässt das Seitenmenü einklappen
                Navigator.pop(context);
              } else {
                // lässt das Seitenmenü einklappen
                Navigator.pop(context);
                // zeigt die Soforthilfe Seite
                Navigator.pushReplacementNamed(context, "/soforthilfe");
              }
            },
          ),
          Divider(),
          ListTile(
            // alternativer Titel: Tutorial
            title: Text("Wie funktioniert's"),
            onTap: () {
              if (this.aktuelleSeite == "/tutorial") {
                // lässt das Seitenmenü einklappen
                Navigator.pop(context);
              } else {
                // lässt das Seitenmenü einklappen
                Navigator.pop(context);
                // zeigt die Soforthilfe Seite
                Navigator.pushReplacementNamed(context, "/tutorial");
              }
            },
          ),
          Divider(),
          ListTile(
            title: Text("Statistiken"),
            onTap: () {
              if (this.aktuelleSeite == "/statistiken") {
                // lässt das Seitenmenü einklappen
                Navigator.pop(context);
              } else {
                // lässt das Seitenmenü einklappen
                Navigator.pop(context);
                // zeigt die Soforthilfe Seite
                Navigator.pushReplacementNamed(context, "/statistiken");
              }
            },
          ),
          Divider(),
          ListTile(
              title: Text("Einstellungen"),
              onTap: () {
                if (aktuelleSeite == "/einstellungen") {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "/einstellungen");
                }
              }),
          Divider(),
          ListTile(
            title: Text("Über uns"),
            onTap: () {
              if (this.aktuelleSeite == "/ueberUns") {
                // lässt das Seitenmenü einklappen
                Navigator.pop(context);
              } else {
                // lässt das Seitenmenü einklappen
                Navigator.pop(context);
                // zeigt die Soforthilfe Seite
                Navigator.pushReplacementNamed(context, "/ueberUns");
              }
            },
          ),
        ],
      ),
    );
  }
}
