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
          style: thema.textTheme.displayLarge,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: thema.colorScheme.onPrimary),
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
                  style: thema.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  "mit Datums- und Raumangabe, einer kurzen Beschreibung und optional mit einem Bild",
                  style: thema.textTheme.bodyMedium,
                ),
              ),
              ListTile(
                title: Text(
                  "2. Die Meldung wird an den zentralen Server gesendet",
                  style: thema.textTheme.bodyLarge,
                ),
              ),
              ListTile(
                title: Text(
                  "3. Die Fehlerbeheber beheben den Fehler",
                  style: thema.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  "Fehlerbehebung nach bestem Wissen und Gewissen",
                  style: thema.textTheme.bodyMedium,
                ),
              ),
              ListTile(
                title: Text(
                  "4. Die Fehlermeldung wird als gefixt (= behoben) gekennzeichnet",
                  style: thema.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  "mit optionalem Kommentar des Fehlerbehebers (kommt bald)",
                  style: thema.textTheme.bodyMedium,
                ),
              ),
              ListTile(
                title: Text(
                  "5. Die Fehlermeldung ist weiterhin für ihren Ersteller zu sehen und wird nach einiger Zeit vollständig gelöscht",
                  style: thema.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
