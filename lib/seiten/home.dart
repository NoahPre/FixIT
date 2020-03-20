// home.dart
// 1
import "package:flutter/material.dart";
// 2
import "./fehlermeldung.dart";
import "../widgets/fehlerliste.dart";
import "../widgets/FABHome.dart";
import "../klassen/fehler.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Fehler> fehlerliste = [];

  void fehlerGemeldet({Fehler fehler}) {
    // fügt den in Fehlermeldung gemeldeten Fehler zur fehlerListe hinzu
    setState(() {
      fehlerliste.add(fehler);
    });
  }

  void fehlerGeloescht({int index}) {
    setState(() {
      fehlerliste.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FixIt"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Fehlerliste(fehlerliste: fehlerliste, fehlerGeloescht: fehlerGeloescht,),
        ),
      ),
      floatingActionButton: FABHome(fehlerGemeldet: fehlerGemeldet,),
    );
  }
}


// child: FlatButton(
          //   child: Text("FehlermeldungVorlage"),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           fullscreenDialog: true, builder: (context) {
          //             return FehlermeldungVorlage();
          //           }),
          //     );
          //   },
          // ),