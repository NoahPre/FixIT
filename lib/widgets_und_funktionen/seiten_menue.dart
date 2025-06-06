// seiten_menue.dart
import 'package:fixit/imports.dart';

// Seitenmenü der App
class Seitenmenue extends StatelessWidget {
  final String aktuelleSeite;

  const Seitenmenue({super.key, required this.aktuelleSeite});

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);

    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context);
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);

    Size deviceSize = MediaQuery.of(context).size;

    return Drawer(
      child: ListView(
        primary: false,
        children: <Widget>[
          // Abschnitt über der Liste mit den verfügbaren Seiten
          // zeigt Informationen über den Benutzer an
          DrawerHeader(
            // entfernt den komischen Platz zwischen dem Header und dem ersten ListTile
            margin: EdgeInsets.only(bottom: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: thema.colorScheme.primary,
                      foregroundColor: Colors.white,
                      minRadius: 30.0,
                      child: Icon(Icons.person),
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
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text("Schule: ${benutzerInfoProvider.schule}"),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 180.0,
                              child: Text("Gemeldete Fehler:"),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                fehlerlisteProvider.fehlermeldungsZaehler
                                    .toString(),
                              ),
                            )
                          ],
                        ),
                        benutzerInfoProvider.istFehlermelder
                            ? Container()
                            : Row(
                                children: [
                                  SizedBox(
                                    width: 180.0,
                                    child: Text("Gefixte Fehler:"),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      fehlerlisteProvider.fehlerbehebungsZaehler
                                          .toString(),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: Text("Gemeldete Fehler"),
            onTap: () {
              if (aktuelleSeite == "/") {
                // lässt das Seitenmenü einklappen
                Navigator.pop(context);
              } else {
                // lässt das Seitenmenü einklappen
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/");
              }
            },
          ),
          Divider(),
          // ListTile(
          //   title: Text("Soforthilfe"),
          //   onTap: () {
          //     if (this.aktuelleSeite == "/soforthilfe") {
          //       // lässt das Seitenmenü einklappen
          //       Navigator.pop(context);
          //     } else {
          //       // lässt das Seitenmenü einklappen
          //       Navigator.pop(context);
          //       // zeigt die Soforthilfe Seite
          //       Navigator.pushReplacementNamed(context, "/soforthilfe");
          //     }
          //   },
          // ),
          // Divider(),
          ListTile(
            // alternativer Titel: Tutorial
            title: Text("Wie funktioniert's?"),
            onTap: () {
              if (aktuelleSeite == "/tutorial") {
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
          // ListTile(
          //   title: Text("Statistiken"),
          //   onTap: () {
          //     if (this.aktuelleSeite == "/statistiken") {
          //       // lässt das Seitenmenü einklappen
          //       Navigator.pop(context);
          //     } else {
          //       // lässt das Seitenmenü einklappen
          //       Navigator.pop(context);
          //       // zeigt die Soforthilfe Seite
          //       Navigator.pushReplacementNamed(context, "/statistiken");
          //     }
          //   },
          // ),
          // Divider(),
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
              if (aktuelleSeite == "/ueberUns") {
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
          Divider(),
        ],
      ),
    );
  }
}
