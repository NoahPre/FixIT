// fehlerliste.dart
import "../../imports.dart";
//import "package:http/http.dart" as http;
// TODO: den Benutzer benachrichtigen, wenn keine Internetverbindung vorhanden ist

// TODO: beim fixen des Fehlers Kommentar hinterlassen Funktion hinzufügen

class Fehlerliste extends StatefulWidget {
  Fehlerliste({this.appBarHoehe = 0.0});

  final double appBarHoehe;

  @override
  _FehlerlisteState createState() => _FehlerlisteState();
}

class _FehlerlisteState extends State<Fehlerliste> {
  @override
  Widget build(BuildContext context) {
    // aus provider.dart und fehlerlisteProvider.dart
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    ThemeData thema = Theme.of(context);

    // aktualisiert die Liste
    Future<void> refresh() async {
      if (fehlerlisteProvider.fehlerliste != null) {
        fehlerlisteProvider.fehlerliste.clear();
      }
      await fehlerlisteProvider.holeFehler();
      return null;
    }

    return StreamBuilder(
      stream: fehlerlisteProvider.fehlerlisteStream,
      initialData: fehlerlisteProvider.fehlerliste,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        // Widget für den Scrollbalken am Rand
        return Scrollbar(
          child: RefreshIndicator(
            onRefresh: () => refresh(),
            color: thema.colorScheme.primary,
            child: ListView(
              children:
                  // überprüft, ob die Fehlerliste schon vollständig heruntergeladen wurde
                  snapshot.hasData
                      ? (snapshot.data.length == 0 || snapshot.data == [])
                          // wird ausgegeben, wenn die Fehlerliste leer ist
                          ? [
                              Container(
                                height: mediaQueryData.size.height -
                                    widget.appBarHoehe,
                                child: Center(
                                  child: Text(
                                    "Noch keine Fehler gemeldet",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          : snapshot.data.map<Widget>(
                              (Fehler fehler) {
                                return FehlerlisteEintrag(
                                  fehler: fehler,
                                );
                              },
                            ).toList()
                      // zeigt einen Ladedonut an, während die Fehlerliste fertig heruntergeladen wird
                      : [
                          Container(
                            height: mediaQueryData.size.height -
                                widget.appBarHoehe -
                                mediaQueryData.padding.top -
                                mediaQueryData.padding.bottom,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  thema.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
            ),
          ),
        );
      },
    );
  }
}
