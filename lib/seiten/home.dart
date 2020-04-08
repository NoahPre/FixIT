// home.dart
// 1
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "dart:async";
// 2
import "../widgets/fehlerliste.dart";
import "../widgets/FABHome.dart";
import "../klassen/fehler.dart";
import "../widgets/seitenmenue.dart";
import "./registrierung.dart";
import "../klassen/provider/anmeldungProvider.dart";
// 3
import "package:provider/provider.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Liste der Fehler
  List<Fehler> fehlerliste = [];
  // Variablen mit wichtigsten Eigenschaften, werden am Anfang aus SharedPreferences überschrieben
  bool istAngemeldet = false;
  String benutzername = "";
  String passwort;
  bool istFehlermelder = true;

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
  void initState() {
    super.initState();
  }

  Future<bool> istUserAngemeldet() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("istAngemeldet") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final AnmeldungProvider anmeldungProvider =
        Provider.of<AnmeldungProvider>(context);

    return FutureBuilder(
      initialData: false,
      future: istUserAngemeldet(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? snapshot.data
                // wird angezeigt, wenn der User angemeldet ist, also wenn istAngemeldet in SharedPreferences true ist
                ? Scaffold(
                    appBar: AppBar(
                      title: Text("FixIt"),
                    ),
                    // Seitenmenü
                    drawer: Seitenmenue(),
                    body: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        // Liste mit gemeldeten Fehlern
                        child: Fehlerliste(
                          fehlerliste: fehlerliste,
                          fehlerGeloescht: fehlerGeloescht,
                        ),
                      ),
                    ),
                    floatingActionButton: FABHome(
                      fehlerGemeldet: fehlerGemeldet,
                    ),
                  )
                :
                // wird angezeigt, wenn der User nicht angemeldet ist, also wenn istAngemeldet in SharedPreferences false ist
                Registrierung(
                    benutzername: benutzername,
                    passwort: passwort,
                    istAngemeldet: istAngemeldet,
                  )
            :
            // wird angezeigt, während istUserAngemeldet() ausgeführt wird
            Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}
