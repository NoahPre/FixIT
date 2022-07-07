// fehlerliste.dart
import "package:fixit/imports.dart";

// TODO: beim fixen des Fehlers Kommentar hinterlassen Funktion hinzufügen

class Fehlerliste extends StatefulWidget {
  Fehlerliste({
    this.appBarHoehe = 0.0,
    required this.nachrichtVomServer,
    required this.fehlerlisteProvider,
    required this.automatischesEntfernenVonGefixtenMeldungen,
  });

  final double appBarHoehe;
  final Function nachrichtVomServer;
  final FehlerlisteProvider fehlerlisteProvider;
  final Function automatischesEntfernenVonGefixtenMeldungen;

  @override
  _FehlerlisteState createState() => _FehlerlisteState();
}

class _FehlerlisteState extends State<Fehlerliste> {
  List<Widget> zeigeFehlerliste(
      {required dynamic fehlerliste,
      required List<dynamic> eigeneFehlermeldungenIDs,
      required ThemeData thema}) {
    List<Fehler> eigeneFehlermeldungen = [];
    List<Fehler> sonstigeFehlermeldungen = [];
    for (Fehler aktuellerFehler in fehlerliste) {
      if (eigeneFehlermeldungenIDs.contains(aktuellerFehler.id)) {
        eigeneFehlermeldungen.add(aktuellerFehler);
      } else {
        sonstigeFehlermeldungen.add(aktuellerFehler);
      }
    }

    List<Widget> children = [];
    children.add(
      SizedBox(
        height: 4.0,
      ),
    );
    if (eigeneFehlermeldungen.length != 0) {
      children.add(Text(
        "Eigene Fehlermeldungen:",
        style: thema.textTheme.headline2,
      ));
      children.addAll(
        eigeneFehlermeldungen.map<Widget>(
          (Fehler fehler) => FehlerlisteEintrag(fehler: fehler),
        ),
      );
      children.add(SizedBox(
        height: 20.0,
      ));
    }
    if (sonstigeFehlermeldungen.length != 0) {
      if (eigeneFehlermeldungen.length != 0) {
        children.add(
          Text(
            "Andere Fehlermeldungen:",
            style: thema.textTheme.headline2,
          ),
        );
      }
      children.addAll(
        sonstigeFehlermeldungen.map<Widget>(
          (Fehler fehler) => FehlerlisteEintrag(fehler: fehler),
        ),
      );
    }
    return children;
  }

  @override
  void initState() {
    // widget.fehlerlisteProvider.holeFehler();
    // WidgetsBinding.instance?.addPostFrameCallback(
    //     (timeStamp) => widget.automatischesEntfernenVonGefixtenMeldungen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // aus provider.dart und fehlerlisteProvider.dart
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    ThemeData thema = Theme.of(context);
    // aktualisiert die Liste
    Future<void> aktualisieren() async {
      fehlerlisteProvider.fehlerliste.clear();
      fehlerlisteProvider.angezeigteFehlerliste.clear();
      await fehlerlisteProvider.holeFehler();
      return null;
    }

    // schaut, ob auf dem Server irgendwelche neuen Nachrichten sind
    // TODO: das hier auslagern
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await holeServerNachricht(
          context: context, nachrichtVomServer: widget.nachrichtVomServer);
    });
    return StreamBuilder(
      stream: fehlerlisteProvider.fehlerlisteStream,
      initialData: fehlerlisteProvider.angezeigteFehlerliste,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        Widget screen = Builder(
          builder: (BuildContext currentContext) => RefreshIndicator(
            onRefresh: () async {
              if (await ueberpruefeInternetVerbindung(
                    currentContext: currentContext,
                  ) ==
                  true) {
                aktualisieren();
              } else {}
            },
            color: thema.colorScheme.primary,
            child: ListView(
              children:
                  // überprüft, ob die Fehlerliste schon vollständig heruntergeladen wurde
                  snapshot.hasData
                      ? (snapshot.data.length == 0)
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
                          : zeigeFehlerliste(
                              fehlerliste: snapshot.data,
                              eigeneFehlermeldungenIDs:
                                  fehlerlisteProvider.eigeneFehlermeldungenIDs,
                              thema: thema)
                      // zeigt einen Ladedonut an, während die Fehlerliste fertig heruntergeladen wird
                      : [
                          Container(
                            height: mediaQueryData.size.height -
                                widget.appBarHoehe -
                                mediaQueryData.padding.top -
                                mediaQueryData.padding.bottom,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      thema.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  Text(
                                    "Download der Fehlermeldungen",
                                    style: thema.textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
            ),
          ),
        );
        return snapshot.data?.length == 0
            ? screen
            :
            // Widget für den Scrollbalken am Rand
            RawScrollbar(
                thumbColor: Colors.grey,
                child: screen,
              );
      },
    );
  }
}
