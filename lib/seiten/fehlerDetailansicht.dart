// fehlerDetailansicht.dart
// 1
import "package:flutter/material.dart";
// 2
import "../klassen/fehler.dart";

class FehlerDetailansicht extends StatefulWidget {
  FehlerDetailansicht({this.fehler, this.fehlerliste});

  final Fehler fehler;
  final List<Fehler> fehlerliste;

  @override
  _FehlerDetailansichtState createState() => _FehlerDetailansichtState();
}

class _FehlerDetailansichtState extends State<FehlerDetailansicht> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fehler Detailansicht"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Hero(
              tag: "CircleAvatarMitRaumnummer",
              child: CircleAvatar(
                child: Text(widget.fehler.raum),
              ),
            ),
            Text(widget.fehler.beschreibung),
          ],
        ),
      ),
    );
  }
}
