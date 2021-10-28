// einstellungen.dart
import '../imports.dart';
import "package:flutter/foundation.dart";

class Einstellungen extends StatefulWidget {
  @override
  _EinstellungenState createState() => _EinstellungenState();
}

class _EinstellungenState extends State<Einstellungen> {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context);
    FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Einstellungen",
          style: thema.textTheme.headline1,
        ),
        backgroundColor: thema.colorScheme.primary,
      ),
      drawer: Seitenmenue(
        aktuelleSeite: "/einstellungen",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                "Hier werden später einige Einstellungen sein",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Card(
                child: Column(
              children: [
                ListTile(
                  title: Text("Gemeldete Fehler Zähler zurücksetzen"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    await fehlerlisteProvider
                        .setzeFehlermeldungsZaehlerZurueck();
                  },
                ),
                benutzerInfoProvider.istFehlermelder == false
                    ? Column(
                        children: [
                          Divider(),
                          ListTile(
                            title: Text("Gefixte Fehler Zähler zurücksetzen"),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () async {
                              await fehlerlisteProvider
                                  .setzeFehlerbehebungsZaehlerZurueck();
                            },
                          )
                        ],
                      )
                    : Container(),
                Divider(),
                ListTile(
                  title: Text("Abmelden"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    await benutzerInfoProvider.benutzerMeldetSichAb();
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
