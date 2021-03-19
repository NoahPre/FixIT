// fehlerbehebung.dart
import '../../imports.dart';
import "package:flutter/material.dart";

class Fehlerbehebung extends StatefulWidget {
  Fehlerbehebung({
    this.fehler,
    this.fehlerBehoben,
  });

  final Fehler fehler;
  final Function fehlerBehoben;

  @override
  _FehlerbehebungState createState() => _FehlerbehebungState();
}

class _FehlerbehebungState extends State<Fehlerbehebung> {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    // MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size deviceSize = MediaQuery.of(context).size;

    // das Datum in schön
    // TODO: evtl. das intelligenter lösen
    String datumInSchoen() {
      String tag =
          widget.fehler.datum.split("")[6] + widget.fehler.datum.split("")[7];
      String monat =
          widget.fehler.datum.split("")[4] + widget.fehler.datum.split("")[5];
      String jahr = widget.fehler.datum.split("")[0] +
          widget.fehler.datum.split("")[1] +
          widget.fehler.datum.split("")[2] +
          widget.fehler.datum.split("")[3];
      String gesamt = tag + "." + monat + "." + jahr;
      return gesamt;
    }

    // TODO: ein richtiges Beheben von Fehlern einbauen
    void fehlerBeheben() {
      return;
    }

    var appBar = AppBar(
      title: Text(
        "Fehlerbehebung",
        style: thema.textTheme.headline1,
      ),
      backgroundColor: thema.colorScheme.primary,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.done,
            color: thema.colorScheme.onPrimary,
          ),
          tooltip: "Fehler beheben",
          onPressed: () {
            widget.fehlerBehoben(fehler: widget.fehler);
            Navigator.pop(context);
          },
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      backgroundColor: thema.colorScheme.secondary,
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
                    "gemeldet am: " + datumInSchoen(),
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
                widget.fehler.beschreibung ?? "",
                style: thema.textTheme.bodyText1,
              ),
              // TODO: bei Änderungen hier, auch den Code in FehlerDetailansicht aktualisieren
              // überprüft, ob der Fehler ein Bild hat und lädt dieses im entsprechenden Fall
              (widget.fehler.bild.isEmpty ||
                      widget.fehler.bild == "" ||
                      widget.fehler.bild == null)
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
                              fullscreenDialog: true,
                              builder: (BuildContext context) =>
                                  BildDetailansicht(
                                urlZumBild:
                                    "https://www.icanfixit.eu/fehlerBilder/" +
                                        widget.fehler.bild,
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: Image.network(
                            "https://www.icanfixit.eu/fehlerBilder/" +
                                widget.fehler.bild,
                            fit: BoxFit.contain,
                            loadingBuilder: (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent loadingProgress,
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
                                    Object exception, StackTrace stackTrace) =>
                                Column(
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
                            ),
                          ),
                        ),
                      ),
                    ),
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
      ),
    );
  }
}
