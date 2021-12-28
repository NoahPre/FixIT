// fehlerliste.dart
import "package:fixit/imports.dart";
import "package:crypto/crypto.dart";
import 'package:flutter/rendering.dart';

// TODO: beim fixen des Fehlers Kommentar hinterlassen Funktion hinzufügen

class Fehlerliste extends StatefulWidget {
  Fehlerliste({this.appBarHoehe = 0.0, required this.nachrichtVomServer});

  final double appBarHoehe;
  final Function nachrichtVomServer;

  @override
  _FehlerlisteState createState() => _FehlerlisteState();
}

class _FehlerlisteState extends State<Fehlerliste> {
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
    if (sonstigeFehlermeldungen.length != 0) {
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
    }
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

    // schaut, ob auf dem Server irgendwelche neuen Nachrichten sind
    // TODO: das hier auslagern
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      Map<String, dynamic>? nachrichtMap = await widget.nachrichtVomServer();
      // wenn keine Nachricht anzuzeigen ist, dann wird die Funktion hier beendet
      if (nachrichtMap == null) {
        return;
      }
      LokaleDatenbank lokaleDatenbank = LokaleDatenbank();
      Map<String, dynamic> serverNachrichten =
          await lokaleDatenbank.holeLokaleServerNachrichtenDaten();
      String aktuelleNachrichtSHA1 =
          sha1.convert(utf8.encode(nachrichtMap["text"] ?? "")).toString();
      // wenn die Nachricht schon einmal angezeigt wurde, dann
      if (aktuelleNachrichtSHA1 ==
          (serverNachrichten["letzteNachrichtSHA1"] ?? "")) {
        return;
      }
      // // wird ausgeführt, wenn die Nachricht noch nicht angezeigt wurde (der Hash der Nachricht noch nicht in der Datenbank ist)
      else {
        serverNachrichten["letzteNachrichtSHA1"] = aktuelleNachrichtSHA1;
        lokaleDatenbank.schreibeLokaleServerNachrichtenDaten(serverNachrichten);
        await showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Center(
                  child: Text(nachrichtMap["titel"] ?? ""),
                ),
                titleTextStyle: thema.textTheme.headline2,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            nachrichtMap["text"] ?? "",
                            style: thema.textTheme.bodyText1,
                            maxLines: 1000,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Center(
                    child: TextButton(
                      child: Text(
                        "OK",
                        style: thema.textTheme.bodyText1,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              );
            });
      }
    });
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
              if (await ueberpruefeInternetVerbindung(
                    currentContext: currentContext,
                  ) ==
                  true) {
                refresh();
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
            : Scrollbar(
                child: screen,
              );
      },
    );
  }
}
