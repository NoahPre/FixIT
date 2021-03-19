// fehlerlisteProvider.dart
import "dart:async";
import "../../imports.dart";
import "package:http/http.dart" as http;
import "package:image_picker/image_picker.dart";
import 'package:crypto/crypto.dart';

// Dieser Provider enthält die Fehlerliste, die dem Benutzer angezeigt wird.
// Außerdem enthält er Funktionalität, mit der man
// - neue Fehler hinzufügen kann
// - Fehler editieren kann
// - Fehler löschen kann
class FehlerlisteProvider with ChangeNotifier {
  FehlerlisteProvider() {
    holeFehler();
    berechneToken();
  }

  /// Token zur Authentifizierung
  String token = "";
  //StreamController für die Fehlerliste
  StreamController fehlerlisteController =
      StreamController<List<Fehler>>.broadcast();
  Sink get fehlerlisteSink => fehlerlisteController.sink;
  Stream<List<Fehler>> get fehlerlisteStream => fehlerlisteController.stream;

  // Liste der Fehler, die auf der Startseite angezeigt werden
  List<Fehler> fehlerliste;

  // wird ganz am Anfang ausgeführt und holt alle Fehler vom Server
  Future<void> holeFehler() async {
    var url = 'https://www.icanfixit.eu/gibAlleFehler.php';
    http.Response response = await http.get(Uri.parse(url));
    var jsonObjekt = jsonDecode(response.body) ?? [];
    // überschreibt fehlerliste mit den Werten aus der Datenbank
    fehlerliste = List.generate(jsonObjekt.length, (int index) {
      // erstellt für jeden in gibAlleFehler.php zurückgegebenen Eintrag einen Fehler in fehlerliste
      return Fehler(
        id: jsonObjekt[index]["id"],
        datum: jsonObjekt[index]["datum"],
        raum: jsonObjekt[index]["raum"],
        beschreibung: jsonObjekt[index]["beschreibung"],
        gefixt: jsonObjekt[index]["gefixt"],
        bild: jsonObjekt[index]["bild"],
      );
    });
    // fügt die geholten Fehler dem fehlerlisteController hinzu und aktualisiert damit das Widget Fehlerliste
    fehlerlisteSink.add(fehlerliste);
    notifyListeners();
  }

  Future<void> berechneToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String passwort = sharedPreferences.getString("passwort") ?? "";
    token = sha256.convert(utf8.encode(passwort)).toString();
  }

  /// um einen neuen Fehler zu schreiben muss man nur diese Funktion aufrufen
  ///
  /// es kann immer nur entweder image oder pickedImage angegeben werden
  Future<void> fehlerGemeldet(
      {@required Fehler fehler, File image, PickedFile pickedImage}) async {
    String fileName = "";
    // TODO: das hier alles ein wenig sicherer und generell besser machen
    // Bild wird hochgeladen, wenn eins aufgenommen wurde
    if (image != null) {
      print("image != null");
      fileName = fehler.id + "." + image.path.split('/').last.split(".")[1];

      fehler.bild = fileName;
      await startUpload(
        fehler: fehler,
        base64EncodedImage: base64Encode(
          image?.readAsBytesSync(),
        ),
        path: image.path,
      );
    }
    if (pickedImage != null) {
      print("pickedImage != null");
      fileName =
          fehler.id + "." + pickedImage.path.split('/').last.split(".")[1];

      fehler.bild = fileName;
      await startUpload(
        fehler: fehler,
        base64EncodedImage: base64Encode(
          await pickedImage?.readAsBytes(),
        ),
        path: pickedImage.path,
      );
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
    fehlerlisteSink.add(fehlerliste);
    notifyListeners();
  }

  Future<void> startUpload({
    @required Fehler fehler,
    @required String base64EncodedImage,
    @required String path,
  }) async {
    if (base64EncodedImage == null) {
      return;
    }
    String fileName = fehler.id + "." + path.split('/').last.split(".")[1];
    upload(
      fileName: fileName,
      base64Image: base64EncodedImage,
      // base64Image: base64Encode(
      //   await file.readAsBytes(),
      // ),
    );
  }

  String upload({String fileName, String base64Image}) {
    print("uploading");
    print(fileName);
    http.post(Uri.parse("https://www.icanfixit.eu/BildUpload.php?token=$token"),
        body: {
          "image": base64Image,
          "name": fileName,
        }).then((result) {
      print(result.body);
      return result.statusCode == 200 ? result.body : "";
    }).catchError((error) {
      print(error.toString());
      return error.toString();
    });
    return "";
  }

  void fehlerGefixt({int indexInFehlerliste}) {}

  // um einen alten Fehler zu löschen muss man nur diese Funktion aufrufen
  void fehlerGeloescht({Fehler fehler}) {
    entferneFehler(
      id: fehler.id,
      fileName: fehler.bild,
    );
    fehlerliste
        .removeWhere((aktuellerFehler) => aktuellerFehler.id == fehler.id);
    fehlerlisteSink.add(fehlerliste);
    notifyListeners();
  }

  // fügt einen Fehler mit schreibeFehler.php hinzu
  Future<void> schreibeFehler({
    String id,
    String datum,
    String raum,
    String beschreibung,
    String gefixt,
    String bild,
  }) async {
    // die URL, die aufgerufen werden muss (mit den Argumenten implementiert)
    var url =
        "https://www.icanfixit.eu/schreibeFehler.php?id=$id&datum=$datum&raum=$raum&beschreibung=$beschreibung&gefixt=$gefixt&bild=$bild&token=$token";
    http.Response response = await http.get(Uri.parse(url));
    print(url);
    print("Response body: " + response.body);
    return;
  }

  // löscht einen Fehler mit entferneFehler.php
  Future<void> entferneFehler({
    @required String id,
    @required String fileName,
  }) async {
    var url =
        "https://www.icanfixit.eu/entferneFehler.php?id=$id&fileName=$fileName&token=$token";
    http.Response response = await http.get(Uri.parse(url));
  }

  void dispose() {
    super.dispose();
    fehlerlisteController.close();
  }
}
