// fehlerlisteProvider.dart
// 1
import "../../imports.dart";
import "package:http/http.dart" as http;
import "dart:async";

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
      raum: fehler.raum,
      beschreibung: fehler.beschreibung,
      gefixt: fehler.gefixt,
    );
    fehlerliste.add(fehler);
    notifyListeners();
  }

  void fehlerGefixt({int indexInFehlerliste}) {}

  // um einen alten Fehler zu löschen muss man nur diese Funktion aufrufen
  void fehlerGeloescht({Fehler fehler}) {
    entferneFehler(id: fehler.id);
    fehlerliste.remove(fehler);
    notifyListeners();
  }

  Future<String> holeFehler() async {
    var url = 'https://www.icanfixit.eu/gibAlleFehler.php';
    http.Response response = await http.get(url);
    var jsonObjekt = jsonDecode(response.body);
    // überschreibt fehlerliste mit den Werten aus der Datenbank
    fehlerliste = List.generate(jsonObjekt.length, (int index) {
      // erstellt für jeden in gibAlleFehler.php zurückgegebenen Eintrag einen Fehler in fehlerliste
      return Fehler(
        id: int.parse(jsonObjekt[index]["id"]),
        datum: jsonObjekt[index]["datum"],
        raum: jsonObjekt[index]["raum"],
        beschreibung: jsonObjekt[index]["beschreibung"],
        gefixt: jsonObjekt[index]["gefixt"],
      );
    });
    // fehlerliste = [
    //   Fehler(
    //     id: 0,
    //     datum: "2020/01/01",
    //     beschreibung: "Erster Fehler",
    //     fixer: "Martin",
    //     gefixt: "1",
    //     gefixtDatum: "2020/01/03",
    //     kommentar: "kein Kommentar",
    //     raum: "K21",
    //   ),
    //   Fehler(
    //     id: 1,
    //     datum: "2020/01/03",
    //     beschreibung: "Zweiter Fehler",
    //     fixer: "Noah",
    //     gefixt: "1",
    //     gefixtDatum: "2020/01/07",
    //     kommentar: "kein Kommentar",
    //     raum: "N41",
    //   ),
    //   Fehler(
    //     id: 2,
    //     datum: "2020/01/02",
    //     beschreibung: "Dritter Fehler",
    //     fixer: "",
    //     gefixt: "0",
    //     gefixtDatum: "",
    //     kommentar: "",
    //     raum: "K21",
    //   ),
    //   Fehler(
    //     id: 3,
    //     datum: "2020/01/05",
    //     beschreibung: "Vierter Fehler",
    //     fixer: "Martin",
    //     gefixt: "0",
    //     gefixtDatum: "",
    //     kommentar: "",
    //     raum: "K21",
    //   ),
    // ];
    // return "";
    return response.body;
  }

  // fügt einen Fehler mit schreibeFehler.php hinzu
  Future<void> schreibeFehler({
    int id,
    String datum,
    String raum,
    String beschreibung,
    String gefixt,
  }) async {
    // die URL, die aufgerufen werden muss (mit den Argumenten implementiert)
    var url =
        "https://www.icanfixit.eu/schreibeFehler.php?id=$id&datum=$datum&raum=$raum&beschreibung=$beschreibung&gefixt=$gefixt";
    http.Response response = await http.get(url);
    print(url);
    print("Response body: " + response.body);
    return;
  }

  // löscht einen Fehler mit entferneFehler.php
  Future<void> entferneFehler({int id}) async {
    var url = "https://www.icanfixit.eu/entferneFehler.php?id=$id";
    http.Response response = await http.get(url);
    print(url);
    print("entferneFehler: " + response.body);
    return;
  }
}
