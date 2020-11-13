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
  void fehlerGemeldet({@required Fehler fehler, File image}) {
    String fileName = "";
    print("fileName: " + fileName);
    // Bild wird hochgeladen, wenn eins aufgenommen wurde
    if (image != null) {
      print("image != null");
      fileName =
          fehler.id.toString() + "." + image.path.split('/').last.split(".")[1];

      fehler.bild = fileName;
      startUpload(fehler: fehler, file: image);
    }
    schreibeFehler(
      id: fehler.id,
      datum: fehler.datum,
      raum: fehler.raum,
      beschreibung: fehler.beschreibung,
      gefixt: fehler.gefixt,
      bild: fileName,
    );

    fehlerliste.add(fehler);
    notifyListeners();
  }

  void startUpload({@required Fehler fehler, @required File file}) {
    if (null == file) {
      return;
    }
    String fileName =
        fehler.id.toString() + "." + file.path.split('/').last.split(".")[1];
    upload(
      fileName: fileName,
      base64Image: base64Encode(
        file.readAsBytesSync(),
      ),
    );
  }

  String upload({String fileName, String base64Image}) {
    print("uploading");
    http.post("https://www.icanfixit.eu/BildUpload.php", body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      print(result.body);
      return result.statusCode == 200 ? result.body : "";
    }).catchError((error) {
      print(error.toString());
      return error.toString();
    });
  }

  void fehlerGefixt({int indexInFehlerliste}) {}

  // um einen alten Fehler zu löschen muss man nur diese Funktion aufrufen
  void fehlerGeloescht({Fehler fehler}) {
    entferneFehler(id: fehler.id);
    fehlerliste
        .removeWhere((aktuellerFehler) => aktuellerFehler.id == fehler.id);
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
        bild: "https://www.icanfixit.eu/fehlerBilder/" +
            jsonObjekt[index]["bild"],
      );
    });
    return response.body;
  }

  // fügt einen Fehler mit schreibeFehler.php hinzu
  Future<void> schreibeFehler(
      {int id,
      String datum,
      String raum,
      String beschreibung,
      String gefixt,
      String bild}) async {
    // die URL, die aufgerufen werden muss (mit den Argumenten implementiert)
    var url =
        "https://www.icanfixit.eu/schreibeFehler.php?id=$id&datum=$datum&raum=$raum&beschreibung=$beschreibung&gefixt=$gefixt&bild=$bild";
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
