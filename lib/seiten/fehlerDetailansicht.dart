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
                  const SizedBox(height: 5.0,),
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
                  SizedBox(
                    height: deviceSize.height *0.25,
                    child: Image.network(widget.fehler.bild)
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
