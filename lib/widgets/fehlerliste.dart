// fehlerliste.dart
// 1
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
// 2
import "../klassen/fehler.dart";
import "../seiten/fehlerDetailansicht.dart";

class Fehlerliste extends StatefulWidget {
  Fehlerliste({this.fehlerliste, this.fehlerGeloescht});

  final List<Fehler> fehlerliste;
  final fehlerGeloescht;

  @override
  _FehlerlisteState createState() => _FehlerlisteState();
}

class _FehlerlisteState extends State<Fehlerliste> {
  List<Fehler> _fehlerliste;

  

  @override
  void initState() {
    super.initState();
    this._fehlerliste = widget.fehlerliste;
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    return _fehlerliste.length == 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text("Noch keine Fehler gemeldet"),
              ),
            ],
          )
        : ListView(
            children: _fehlerliste.map(
              (Fehler fehler) {
                return Dismissible(
                  background: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  secondaryBackground: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onDismissed: (DismissDirection direction) {
                    widget.fehlerGeloescht(
                      index: _fehlerliste.indexOf(fehler),
                    );
                  },
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              fullscreenDialog: false,
                              builder: (context) {
                                return FehlerDetailansicht(
                                  fehler: fehler,
                                );
                              }),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Hero(
                            tag: "CircleAvatarMitRaumnummer",
                            child: CircleAvatar(
                              child: Text(fehler.raum),
                            ),
                          ),
                          SizedBox(
                            width: _size.width * 0.03,
                          ),
                          Text(fehler.beschreibung),
                        ],
                      ),
                    ),
                  ),
                  key: Key(
                    fehler.id.toString(),
                  ),
                );
              },
            ).toList(),
          );
  }
}
