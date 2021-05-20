// fehlerDetailansicht.dart
import '../../imports.dart';

class FehlerDetailansicht extends StatefulWidget {
  FehlerDetailansicht({
    this.fehler,
    this.fehlerliste,
  });

  final Fehler? fehler;
  final List<Fehler>? fehlerliste;

  @override
  _FehlerDetailansichtState createState() => _FehlerDetailansichtState();
}

class _FehlerDetailansichtState extends State<FehlerDetailansicht> {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    Size deviceSize = MediaQuery.of(context).size;
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);

    /// nimmt das in der Form YYYYMMDD gespeicherte Datum und formatiert es neu
    String datumInSchoen() {
      String tag =
          widget.fehler!.datum!.split("")[6] + widget.fehler!.datum!.split("")[7];
      String monat =
          widget.fehler!.datum!.split("")[4] + widget.fehler!.datum!.split("")[5];
      String jahr = widget.fehler!.datum!.split("")[0] +
          widget.fehler!.datum!.split("")[1] +
          widget.fehler!.datum!.split("")[2] +
          widget.fehler!.datum!.split("")[3];
      String gesamt = tag + "." + monat + "." + jahr;
      return gesamt;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fehler Detailansicht",
          style: thema.textTheme.headline1,
        ),
        backgroundColor: thema.colorScheme.primary,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.delete,
                color: thema.colorScheme.onPrimary,
              ),
              tooltip: "Fehler löschen",
              onPressed: () async {
                await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Text("Fehler wirklich löschen?"),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SimpleDialogOption(
                                child: Text(
                                  "Bestätigen",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  fehlerlisteProvider.fehlerGeloescht(
                                    fehler: widget.fehler!,
                                  );
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                              SimpleDialogOption(
                                child: Text("Abbrechen"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    });
              }),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
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
                    tag: "CircleAvatar${widget.fehler!.id}",
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: deviceSize.width * 0.1,
                      child: Text(
                        widget.fehler!.raum!,
                        style: thema.textTheme.headline4,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.025,
                  ),
                  Text(
                    "gemeldet am: " + datumInSchoen(),
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

              Text(
                widget.fehler!.beschreibung!,
                style: thema.textTheme.bodyText1,
              ),

              // TODO: bei Änderungen hier, auch den Code in FehlerDetailansicht aktualisieren
              // überprüft, ob der Fehler ein Bild hat und lädt dieses im entsprechenden Fall
              (widget.fehler!.bild!.isEmpty ||
                      widget.fehler!.bild == "" ||
                      widget.fehler!.bild == null)
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
                      fit: FlexFit.loose,
                      child: GestureDetector(
                        onTap: () {
                          // zeigt nach Tippen das Bild im Vollbild an
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (BuildContext context) =>
                                  BildDetailansicht(
                                urlZumBild:
                                    "https://www.icanfixit.eu/fehlerBilder/" +
                                        widget.fehler!.bild!,
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: Image.network(
                            "https://www.icanfixit.eu/fehlerBilder/" +
                                widget.fehler!.bild!,
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
                            errorBuilder: (BuildContext currentContext,
                                Object exception, StackTrace? stackTrace) {
                              return Text(
                                "Bild konnte nicht geladen werden",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
