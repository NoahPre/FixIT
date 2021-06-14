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
  Future<bool> _ueberpruefeInternetVerbindung(
      {required BuildContext currentContext}) async {
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      // probably unnecessary
      else {
        zeigeSnackBarNachricht(
          nachricht: "Nicht mit dem Internet verbunden",
          context: currentContext,
          istError: true,
        );

        return false;
      }
    } on SocketException catch (error) {
      print(error.toString());
      zeigeSnackBarNachricht(
        nachricht: "Nicht mit dem Internet verbunden",
        context: currentContext,
        istError: true,
      );
      return false;
    } catch (error) {
      zeigeSnackBarNachricht(
        nachricht: error.toString(),
        context: currentContext,
        istError: true,
      );
      return false;
    }
  }

  List<Widget> zeigeFehlerliste(
      {required dynamic fehlerliste,
      required List<String> eigeneFehlermeldungenIDs,
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
    children.add(
      Text(
        "Andere Fehlermeldungen:",
        style: thema.textTheme.headline2,
      ),
    );
    children.addAll(
      sonstigeFehlermeldungen.map<Widget>(
        (Fehler fehler) => FehlerlisteEintrag(fehler: fehler),
      ),
    );
    return children;
  }

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
        fehlerlisteProvider.fehlerliste!.clear();
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
        Widget screen = Builder(
          builder: (BuildContext currentContext) => RefreshIndicator(
            onRefresh: () async {
              if (await _ueberpruefeInternetVerbindung(
                    currentContext: currentContext,
                  ) ==
                  true) {
                refresh();
              }
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
                      // FutureBuilder(
                      //     future: zeigeFehlerliste(
                      //         fehlerliste: snapshot.data, thema: thema),
                      //     builder: (BuildContext context,
                      //         AsyncSnapshot snapshot) {
                      //       if (snapshot.data == null) {
                      //         return Container();
                      //       } else {
                      //         return snapshot.data;
                      //       }
                      //     })

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
        return snapshot.data?.length == 0
            ? screen
            : Scrollbar(
                child: screen,
              );
      },
    );
  }
}
