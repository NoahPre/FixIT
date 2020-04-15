// fehlerlisteProvider.dart
// 1
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import "dart:async";
// 2
import "../fehler.dart";

// Dieser Provider enthält die Fehlerliste, die dem Benutzer angezeigt wird.
// Außerdem enthält er Funktionalität, mit der man
// - neue Fehler hinzufügen kann
// - Fehler editieren kann
// - Fehler löschen kann
class FehlerlisteProvider with ChangeNotifier {
  FehlerlisteProvider() {
    holeFehler();
  }
  // Liste der Fehler, die auf der Startseite angezeigt werden
  List<Fehler> fehlerliste;
  // um einen neuen Fehler zu schreiben muss man nur diese Funktion aufrufen
  void fehlerGemeldet({Fehler fehler}) {
    schreibeFehler(
      id: fehler.id,
      datum: fehler.datum,
      melder: fehler.melder,
      raum: fehler.raum,
      beschreibung: fehler.beschreibung,
      gefixt: fehler.gefixt,
    );
    fehlerliste.add(fehler);
    notifyListeners();
  }

  // um einen alten Fehler zu löschen muss man nur diese Funktion aufrufen
  void fehlerGeloescht({Fehler fehler}) {    entferneFehler(id: fehler.id);
    fehlerliste.remove(fehler);
    notifyListeners();
  }

  Future<String> holeFehler() async {
    var url = 'http://fixapp.ddns.net/gibAlleFehler.php';
    http.Response response = await http.get(url);
    var jsonObjekt = jsonDecode(response.body);
    // überschreibt fehlerliste mit den Werten aus der Datenbank
    this.fehlerliste = List.generate(jsonObjekt.length, (int index) {
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
    return response.body;
  }

  // fügt einen Fehler mit schreibeFehler.php hinzu
  Future<void> schreibeFehler({
    int id,
    String datum,
    String melder,
    String raum,
    String beschreibung,
    String gefixt,
  }) async {
    // die URL, die aufgerufen werden muss (mit den Argumenten implementiert)
    var url =
        "http://fixapp.ddns.net/schreibeFehler.php?id=$id&datum=$datum&melder=$melder&raum=$raum&beschreibung=$beschreibung&gefixt=$gefixt";
    http.Response response = await http.get(url);
    print(url);
    print("Response body: " + response.body);
  }

  // löscht einen Fehler mit entferneFehler.php
  Future<void> entferneFehler({int id}) async {
    var url = "http://fixapp.ddns.net/entferneFehler.php?id=$id";
    http.Response response = await http.get(url);
    print(url);
    print("entferneFehler: " + response.body);
  }
}
