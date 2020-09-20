// fehlerbehebung.dart
// 1
import 'package:bottom_bar/imports.dart';
import "package:flutter/material.dart";

class Fehlerbehebung extends StatefulWidget {
  Fehlerbehebung({this.fehler});

  final Fehler fehler;

  @override
  _FehlerbehebungState createState() => _FehlerbehebungState();
}

class _FehlerbehebungState extends State<Fehlerbehebung> {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    final Size deviceSize = MediaQuery.of(context).size;

    void fehlerBeheben() {}

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fehlerbehebung",
          style: thema.textTheme.headline1,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              color: thema.iconTheme.color,
            ),
            tooltip: "Fehler beheben",
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            height: deviceSize.height,
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
                          radius: deviceSize.width * 0.1,
                          backgroundColor: thema.primaryColor,
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
                        "gemeldet am: ${widget.fehler.datum}",
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
                  Expanded(
                    child: Text(
                      widget.fehler.beschreibung ?? "",
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
