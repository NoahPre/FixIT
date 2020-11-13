// fehlerDetailansicht.dart
import "../imports.dart";

class FehlerDetailansicht extends StatefulWidget {
  FehlerDetailansicht({
    this.fehler,
    this.fehlerliste,
  });

  final Fehler fehler;
  final List<Fehler> fehlerliste;

  @override
  _FehlerDetailansichtState createState() => _FehlerDetailansichtState();
}

class _FehlerDetailansichtState extends State<FehlerDetailansicht> {
  @override
  Widget build(BuildContext context) {
    print("url zum Bild: " + widget.fehler.bild);
    ThemeData thema = Theme.of(context);
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fehler Detailansicht",
          style: thema.textTheme.headline1,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: thema.iconTheme.color,
            ),
            tooltip: "Fehler löschen",
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            height: deviceSize.height,
            // TODO: hier etwas besseres überlegen
            child: IntrinsicHeight(
              child: Column(
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
                          backgroundColor: Colors.black,
                          radius: deviceSize.width * 0.1,
                          child: Text(
                            widget.fehler.raum,
                            style: thema.textTheme.headline4,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: deviceSize.width * 0.025,
                      ),
                      Text(
                        "gemeldet am: ${widget.fehler.datum}",
                        style: thema.textTheme.bodyText1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.025,
                  ),
                  Text(
                    "Beschreibung:",
                    style: thema.textTheme.headline5,
                  ),
                  // TODO: bei Änderungen hier, auch den Code in Fehlerbehebung aktualisieren
                  // überprüft, ob der Fehler ein Bild hat und lädt dieses im entsprechenden Fall
                  (widget.fehler.bild.isEmpty ||
                          widget.fehler.bild == "" ||
                          widget.fehler.bild == null ||
                          //TODO: das hier besser machen
                          // das hier ist nur als Übergangslösung gedacht, bessere Lösung ist erwünscht
                          widget.fehler.bild ==
                              "https://www.icanfixit.eu/fehlerBilder/")
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Kein Bild gemeldet",
                              style: TextStyle(color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                          ],
                        )
                      // lädt das Bild und gibt beim Fehlschlagen einen Error aus
                      : Flexible(
                          child: GestureDetector(
                            onTap: () {
                              // zeigt nach Tippen das Bild im Vollbild an
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (BuildContext context) {
                                      // hier das Bild nicht extra nochmal runterladen
                                      return BildDetailansicht(
                                        urlZumBild: widget.fehler.bild,
                                      );
                                    }),
                              );
                            },
                            child: Center(
                              child: Image.network(
                                widget.fehler.bild,
                                fit: BoxFit.contain,
                                errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) =>
                                    Column(
                                  children: [
                                    Text("Bild konnte nicht geladen werden"),
                                    Text(exception.toString()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  Expanded(
                    child: Text(
                      widget.fehler.beschreibung,
                      style: thema.textTheme.bodyText1,
                    ),
                  ),
                  Align(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
