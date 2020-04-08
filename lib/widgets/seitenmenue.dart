// seitenmenue.dart
// 1
import "package:flutter/material.dart";
// 2
import "../seiten/statistiken.dart";
import "../seiten/tutorial.dart";
import "../seiten/ueberUns.dart";
import "../seiten/soforthilfe.dart";
import "../klassen/provider/anmeldungProvider.dart";
// 3
import "package:provider/provider.dart";

class Seitenmenue extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final AnmeldungProvider anmeldungProvider = Provider.of<AnmeldungProvider>(context);

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    Divider(),
                    Text(anmeldungProvider.benutzername ?? ""),
                  ],
                ),
                Text("Passwort ${anmeldungProvider.passwort}"),
                anmeldungProvider.istFehlermelder ? Text("Fehlermelder") : Text("Fehlerbeheber"),
              ],
            ),
          ),
          ListTile(
            title: Text("Gemeldete Fehler"),
            onTap: () {
              // lässt das Seitenmenü einklappen
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Soforthilfe"),
            onTap: () {
              // lässt das Seitenmenü einklappen
              Navigator.pop(context);
              // zeigt die Soforthilfe Seite
              Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (context) {
                      return Soforthilfe();
                    }),
              );
            },
          ),
          ListTile(
            // alternativer Titel: Tutorial
            title: Text("Wie funktioniert's"),
            onTap: () {
              // lässt das Seitenmenü einklappen
              Navigator.pop(context);
              // bringt die Tutorial Seite in den Vordergrund
              Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (context) {
                      return Tutorial();
                    }),
              );
            },
          ),
          ListTile(
            title: Text("Statistiken"),
            onTap: () {
              // lässt das Seitenmenü einklappen
              Navigator.pop(context);
              // bringt die Statistiken Seite in den Vordergrund
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Statistiken();
                }),
              );
            },
          ),
          ListTile(
            title: Text("Über uns"),
            onTap: () {
              // lässt das Seitenmenü einklappen
              Navigator.pop(context);
              // bringt die ÜberUns Seite in den Vordergrund
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return UeberUns();
                }),
              );
            },
          ),
          ListTile(
            title: Text("Abmelden"),
            onTap: () {
              Navigator.pop(context);
              // meldet User ab, indem istAngemeldet in AnmeldungProvider überschrieben wird
              anmeldungProvider.istAngemeldet = false;
              anmeldungProvider.ueberschreibeUserInformation();
            },
          ),
        ],
      ),
    );
  }
}
