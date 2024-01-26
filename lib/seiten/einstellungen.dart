// einstellungen.dart
import '../imports.dart';

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
          style: thema.textTheme.displayLarge,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: thema.colorScheme.onPrimary),
        backgroundColor: thema.colorScheme.primary,
      ),
      drawer: Seitenmenue(
        aktuelleSeite: "/einstellungen",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        child: ListView(
          children: [
            Card(
                child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Gemeldete Fehler Zähler zurücksetzen",
                    style: thema.textTheme.bodyLarge,
                  ),
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
                            title: Text(
                              "Gefixte Fehler Zähler zurücksetzen",
                              style: thema.textTheme.bodyLarge,
                            ),
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
                  title: Text(
                    "Abmelden",
                    style: thema.textTheme.bodyLarge,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    await benutzerInfoProvider.benutzerMeldetSichAb();
                    Navigator.pushReplacementNamed(context, "/");
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    // "/registrierung", (route) => false);

                    // setState(() {});
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
