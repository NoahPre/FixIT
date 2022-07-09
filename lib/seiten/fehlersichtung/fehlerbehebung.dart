// fehlerbehebung.dart
import 'package:fixit/imports.dart';

// TODO: bei Änderungen hier, auch den Code in FehlerDetailansicht aktualisieren

class Fehlerbehebung extends StatefulWidget {
  Fehlerbehebung({
    required this.fehler,
  });

  final Fehler fehler;

  @override
  _FehlerbehebungState createState() => _FehlerbehebungState();
}

class _FehlerbehebungState extends State<Fehlerbehebung> {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    // MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size deviceSize = MediaQuery.of(context).size;
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);
    // final String urlZumBild =
    // "https://www.icanfixit.eu/gibBild.php?schule=${fehlerlisteProvider.schule}&token=${fehlerlisteProvider.token}&bild=${widget.fehler.bild}";
    final String urlZumBild = Uri.https(adresse, serverScripts.gibBild, {
      "schule": fehlerlisteProvider.schule,
      "token": fehlerlisteProvider.token,
      "bild": widget.fehler.bild,
    }).toString();

    var appBar = AppBar(
      title: Text(
        "Fehlerbehebung",
        style: thema.textTheme.headline1,
      ),
      backgroundColor: thema.colorScheme.primary,
      actions: <Widget>[
        Builder(builder: (currentContext) {
          return IconButton(
            icon: Icon(
              widget.fehler.gefixt == "0" ? Icons.done : Icons.undo,
              color: thema.colorScheme.onPrimary,
            ),
            tooltip: widget.fehler.gefixt == "0"
                ? "Fehler beheben"
                : '"Fehler behoben" zurücknehmen',
            onPressed: () async {
              if (await ueberpruefeInternetVerbindung(
                      currentContext: currentContext) ==
                  false) {
                return;
              }
              String serverAntwort = "";
              if (widget.fehler.gefixt == "0") {
                serverAntwort = await fehlerlisteProvider.fehlerStatusGeaendert(
                  id: widget.fehler.id,
                  gefixt: "1",
                );
              } else {
                serverAntwort = await fehlerlisteProvider.fehlerStatusGeaendert(
                    id: widget.fehler.id, gefixt: "0");
              }
              ueberpruefeServerAntwort(
                antwort: serverAntwort,
                currentContext: currentContext,
              );
              Navigator.pop(context);
            },
          );
        }),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 5.0,
            ),
            Row(
              children: <Widget>[
                Hero(
                  tag: "CircleAvatar${widget.fehler.id}",
                  child: CircleAvatar(
                    radius: deviceSize.width * 0.1,
                    backgroundColor: thema.colorScheme.primary,
                    child: Text(
                      widget.fehler.raum,
                      style: thema.textTheme.headline4,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  "gemeldet am: " + datumInSchoen(fehler: widget.fehler),
                  style: thema.textTheme.bodyText1,
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "Beschreibung:",
              style: thema.textTheme.headline5,
            ),
            Text(
              widget.fehler.beschreibung,
              style: thema.textTheme.bodyText1,
            ),
            const SizedBox(
              height: 10.0,
            ),
            // überprüft, ob der Fehler ein Bild hat und lädt dieses im entsprechenden Fall
            (widget.fehler.bild.isEmpty || widget.fehler.bild == "")
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Kein Bild gemeldet",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                    ],
                  )

                // lädt das Bild und gibt beim Fehlschlagen einen Error aus
                : Flexible(
                    fit: FlexFit.loose,
                    child: GestureDetector(
                      onTap: () {
                        // zeigt nach Tippen das Bild im Vollbild an
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            fullscreenDialog: false,
                            builder: (BuildContext context) =>
                                BildDetailansicht(
                              urlZumBild: urlZumBild,
                            ),
                          ),
                        );
                      },
                      child: Center(
                        child: Hero(
                          tag: urlZumBild,
                          child: Image.network(
                            urlZumBild,
                            fit: BoxFit.contain,
                            loadingBuilder: (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress,
                            ) {
                              // zeigt das Bild an, wenn es fertig heruntergeladen ist
                              if (loadingProgress == null) {
                                return child;
                              }
                              return CircularProgressIndicator(
                                  // valueColor: AlwaysStoppedAnimation<Color>(
                                  //   thema.primaryColor,
                                  // ),
                                  );
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              print(exception.toString());
                              return Column(
                                children: [
                                  Text(
                                    "Bild konnte nicht geladen werden",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    exception.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
            // Informationen zum Fixer und ein Kommentar
            /*Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "gefixt von: ${widget.fehler.fixer}",
                            style: thema.textTheme.bodyText1,
                          ),
                          Text(
                            "gefixt am: ${widget.fehler.gefixtDatum}",
                            style: thema.textTheme.bodyText1,
                          ),
                          Text(
                            "Kommentar: ${widget.fehler.kommentar}",
                            style: thema.textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ), */
          ],
        ),
      ),
    );
  }
}
