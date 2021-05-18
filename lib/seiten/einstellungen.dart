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
            // wird nur im Debug Modus ausgeführt
            //TODO: machen dass das hier funktioniert
            kDebugMode
                ? ListTile(
                    title: Text("Abmelden"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      await benutzerInfoProvider.ueberschreibeUserInformation(
                          istFehlermelderInFunktion: true,
                          passwortInFunktion: "");
                      benutzerInfoProvider.authentifizierungSink.add(false);
                      setState(() {});
                    },
                  )
                : null,
          ],
        ),
      ),
    );
  }
}
