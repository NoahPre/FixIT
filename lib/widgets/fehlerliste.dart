// fehlerliste.dart
// 1
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import "dart:async";
// 2
import "../klassen/fehler.dart";
import "../seiten/fehlerDetailansicht.dart";
import "../klassen/provider/fehlerlisteProvider.dart";
// 3
import 'package:provider/provider.dart';

class Fehlerliste extends StatefulWidget {
  @override
  _FehlerlisteState createState() => _FehlerlisteState();
}

class _FehlerlisteState extends State<Fehlerliste> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Fehler>> holeFehler() async {
    print("holeFehler");
    var url = 'http://fixapp.ddns.net/gibAlleFehler.php';
    http.Response response = await http.get(url);
    var jsonObjekt = jsonDecode(response.body);

    // List<Fehler> fehlerliste = jsonObjekt.map(
    //   (Map fehler) {
    //     return Fehler(
    //       id: int.parse(fehler["id"]),
    //       datum: fehler["datum"],
    //       melder: fehler["melder"],
    //       raum: fehler["raum"],
    //       beschreibung: fehler["beschreibung"],
    //       gefixt: fehler["gefixt"],
    //     );
    //   },
    // ).toList();
    return List.generate(jsonObjekt.length, (int index) {
      // erstellt für jeden in gibAlleFehler.php zurückgegebenen Eintrag einen Fehler in fehlerliste
      return Fehler(
        id: int.parse(jsonObjekt[index]["id"]),
        datum: jsonObjekt[index]["datum"],
        melder: jsonObjekt[index]["melder"],
        raum: jsonObjekt[index]["raum"],
        beschreibung: jsonObjekt[index]["beschreibung"],
        gefixt: jsonObjekt[index]["gefixt"],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // aus provider.dart und fehlerlisteProvider.dart
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);
    var _size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: holeFehler(),
      initialData: null,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        return snapshot.hasData
            ? snapshot.data.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text("Noch keine Fehler gemeldet"),
                      ),
                    ],
                  )
                : ListView(
                    children: fehlerlisteProvider.fehlerliste.map(
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
                            fehlerlisteProvider.fehlerGeloescht(
                              index: fehlerlisteProvider.fehlerliste
                                  .indexOf(fehler),
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
                                    tag: "CircleAvatar${fehlerlisteProvider.fehlerliste.indexOf(fehler)}",
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
                  )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
