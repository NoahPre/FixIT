// tutorial.dart
import "../imports.dart";

class Tutorial extends StatelessWidget {
  Tutorial({this.istFehlermelder = false});

  final bool istFehlermelder;

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wie funktioniert's?",
          style: thema.textTheme.headline1,
        ),
        backgroundColor: thema.colorScheme.primary,
      ),
      drawer: Seitenmenue(
        aktuelleSeite: "/tutorial",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            4.0,
            0.0,
            4.0,
            0.0,
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 4.0,
              ),
              ListTile(
                title: Text(
                  "1. Ein Fehlermelder verfasst eine Meldung",
                  style: thema.textTheme.bodyText1,
                ),
                subtitle: Text(
                  "mit Datums- und Raumangabe, einer kurzen Beschreibung und optional mit einem Bild",
                  style: thema.textTheme.bodyText2,
                ),
              ),
              ListTile(
                title: Text(
                  "2. Die Meldung wird an den zentralen Server gesendet",
                  style: thema.textTheme.bodyText1,
                ),
              ),
              ListTile(
                title: Text(
                  "3. Die Fehlerbeheber beheben den Fehler",
                  style: thema.textTheme.bodyText1,
                ),
                subtitle: Text(
                  "Fehlerbehebung nach bestem Wissen und Gewissen",
                  style: thema.textTheme.bodyText2,
                ),
              ),
              ListTile(
                title: Text(
                  "4. Die Fehlermeldung wird als gefixt (= behoben) gekennzeichnet",
                  style: thema.textTheme.bodyText1,
                ),
                subtitle: Text(
                  "mit optionalem Kommentar des Fehlerbehebers (kommt bald)",
                  style: thema.textTheme.bodyText2,
                ),
              ),
              ListTile(
                title: Text(
                  "5. Die Fehlermeldung ist weiterhin für ihren Ersteller zu sehen und wird nach einiger Zeit vollständig gelöscht",
                  style: thema.textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
