// fehlerlisteProvider.dart
import "package:fixit/imports.dart";
import "package:http/http.dart" as http;
import "package:image_picker/image_picker.dart";

/// Dieser Provider enthält die Fehlerliste, die dem Benutzer angezeigt wird.
///
/// Außerdem enthält er Methoden, mit denen man
/// - neue Fehler hinzufügen kann
/// - Fehler editieren kann
/// - Fehler löschen kann
class FehlerlisteProvider with ChangeNotifier {
  FehlerlisteProvider() {
    holeToken();
    holeFehler();
    holeFehlermeldungenIDsUndZaehler();
  }

  /// Token zur Authentifizierung
  String token = "";

  /// Speichert, ob der Benutzer Fehlermelder ist oder nicht.
  ///
  /// Existiert schon in BenutzerInfoProvider, ist hier aber der Bequemlichkeit halber nocheinmal.
  // bool istFehlermelder;

  /// StreamController für die Fehlerliste
  StreamController fehlerlisteController =
      StreamController<List<Fehler>?>.broadcast();
  Sink get fehlerlisteSink => fehlerlisteController.sink;
  Stream<List<Fehler>?> get fehlerlisteStream =>
      fehlerlisteController.stream as Stream<List<Fehler>?>;

  /// Liste der Fehler, die auf der Startseite angezeigt werden
  List<Fehler>? fehlerliste;

  /// IDs der Fehlermeldungen des Benutzers
  List<String> eigeneFehlermeldungenIDs = [];

  /// Zähler, der die Anzahl an abgesendeten Fehlermeldungen speichert
  int fehlermeldungsZaehler = 0;

  /// Zähler, der bei Fehlerbehebern die Anzahl an gelöschten (behobenen) Fehlermeldungen^ speichert
  int fehlerbehebungsZaehler = 0;

  // wird ganz am Anfang ausgeführt und holt alle Fehler vom Server
  Future<void> holeFehler() async {
    var url = 'https://www.icanfixit.eu/gibAlleFehler.php?token=$token';
    var jsonObjekt = [];
    try {
      http.Response response = await http.get(Uri.parse(url));
      jsonObjekt = jsonDecode(response.body) ?? [];
    } catch (error) {
      await Future.delayed(const Duration(seconds: 3), () {});
      holeFehler();
      return;
    }
    // überschreibt fehlerliste mit den Werten aus der Datenbank
    fehlerliste = List.generate(jsonObjekt.length, (int index) {
      // erstellt für jeden in gibAlleFehler.php zurückgegebenen Eintrag einen Fehler in fehlerliste
      return Fehler.from(jsonObjekt[index]);
    });
    // fügt die geholten Fehler dem fehlerlisteController hinzu und aktualisiert damit das Widget Fehlerliste
    fehlerlisteSink.add(fehlerliste);
    notifyListeners();
  }

  Future<void> holeFehlermeldungenIDsUndZaehler() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    eigeneFehlermeldungenIDs =
        sharedPreferences.getStringList("eigeneFehlermeldungenIDs") ?? [];
    fehlermeldungsZaehler =
        sharedPreferences.getInt("fehlermeldungsZaehler") ?? 0;
    fehlerbehebungsZaehler =
        sharedPreferences.getInt("fehlerbehebungsZaehler") ?? 0;
    notifyListeners();
  }

  Future<void> holeToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token") ?? "";
  }

  /// Sendet den übergebenen Fehler ans Backend
  ///
  /// es kann immer nur entweder image oder pickedImage angegeben werden
  Future<void> fehlerGemeldet(
      {required Fehler fehler, File? image, PickedFile? pickedImage}) async {
    String dateiname = "";
    // TODO: das hier alles ein wenig sicherer und generell besser machen
    // Bild wird hochgeladen, wenn eins aufgenommen wurde
    if (image != null) {
      // erstellt den Dateinamen des Bildes
      dateiname = fehler.id + "." + image.path.split('/').last.split(".")[1];
      fehler.bild = dateiname;
      await starteUpload(
        fehler: fehler,
        base64EncodedImage: base64Encode(
          image.readAsBytesSync(),
        ),
        pfad: image.path,
        dateiname: dateiname,
      );
    }
    if (pickedImage != null) {
      print("pickedImage != null");
      dateiname =
          fehler.id + "." + pickedImage.path.split('/').last.split(".")[1];

      fehler.bild = dateiname;
      await starteUpload(
        fehler: fehler,
        base64EncodedImage: base64Encode(
          await pickedImage.readAsBytes(),
        ),
        pfad: pickedImage.path,
        dateiname: dateiname,
      );
    }
    // speichert die Fehler ID lokal
    await speichereFehlerID(neueID: fehler.id);
    // erhöht den Zähler
    await erhoeheFehlermeldungsZaehler();
    // sendet den Fehler zum Server
    await schreibeFehler(
      id: fehler.id,
      datum: fehler.datum,
      raum: fehler.raum,
      beschreibung: fehler.beschreibung,
      gefixt: fehler.gefixt,
      bild: dateiname,
    );

    fehlerliste!.add(fehler);
    fehlerlisteSink.add(fehlerliste);
    notifyListeners();
  }

  /// Startet das Upload der übergebenen Daten
  Future<void> starteUpload({
    required Fehler fehler,
    required String base64EncodedImage,
    required String pfad,
    required String dateiname,
  }) async {
    upload(
      dateiname: dateiname,
      base64Image: base64EncodedImage,
      // base64Image: base64Encode(
      //   await file.readAsBytes(),
      // ),
    );
  }

  String upload({String? dateiname, String? base64Image}) {
    print("uploading");
    print(dateiname);
    http.post(Uri.parse("https://www.icanfixit.eu/BildUpload.php?token=$token"),
        body: {
          "image": base64Image,
          "name": dateiname,
        }).then((result) {
      print(result.body);
      return result.statusCode == 200 ? result.body : "";
    }).catchError((error) {
      print(error.toString());
      return error.toString();
    });
    return "";
  }

  //TODO: Funktionalität einbauen
  void fehlerGefixt({int? indexInFehlerliste}) {}

  // um einen alten Fehler zu löschen muss man nur diese Funktion aufrufen
  Future<void> fehlerGeloescht({
    required Fehler fehler,
    required bool istFehlermelder,
  }) async {
    if (istFehlermelder == false) {
      await erhoeheFehlerbehebungsZaehler();
    }

    await entferneFehler(
      id: fehler.id,
      fileName: fehler.bild,
      istFehlermelder: istFehlermelder,
    );
    fehlerliste!
        .removeWhere((aktuellerFehler) => aktuellerFehler.id == fehler.id);
    fehlerlisteSink.add(fehlerliste);
    notifyListeners();
  }

  /// Fügt einen Fehler mit schreibeFehler.php hinzu
  Future<void> schreibeFehler({
    required String id,
    required String datum,
    required String raum,
    required String beschreibung,
    required String gefixt,
    required String bild,
  }) async {
    // die URL, die aufgerufen werden muss (mit den Argumenten implementiert)
    var url =
        "https://www.icanfixit.eu/schreibeFehler.php?id=$id&datum=$datum&raum=$raum&beschreibung=$beschreibung&gefixt=$gefixt&bild=$bild&token=$token";
    await http.get(Uri.parse(url));
  }

  /// Löscht einen Fehler mit entferneFehler.php
  Future<void> entferneFehler({
    required String id,
    required String fileName,
    required bool istFehlermelder,
  }) async {
    var url =
        "https://www.icanfixit.eu/entferneFehler.php?id=$id&fileName=$fileName&token=$token";
    await http.get(Uri.parse(url));
  }

  void dispose() {
    super.dispose();
    fehlerlisteController.close();
  }

  /// Speichert die ID einer Fehlermeldung lokal auf dem Gerät, wenn ein Fehler gemeldet wurde
  Future<void> speichereFehlerID({required String neueID}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? idsList =
        sharedPreferences.getStringList("eigeneFehlermeldungenIDs") ?? [];
    idsList.add(neueID);
    eigeneFehlermeldungenIDs.add(neueID);
    await sharedPreferences.setStringList("eigeneFehlermeldungenIDs", idsList);
  }

  /// Erhöht den Fehlermeldung-Zähler um eins
  Future<void> erhoeheFehlermeldungsZaehler() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    fehlermeldungsZaehler = fehlermeldungsZaehler + 1;
    await sharedPreferences.setInt(
        "fehlermeldungsZaehler", fehlermeldungsZaehler);
  }

  /// Erhöht den Fehlerbehebung-Zähler um eins
  Future<void> erhoeheFehlerbehebungsZaehler() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    fehlerbehebungsZaehler = fehlerbehebungsZaehler + 1;
    await sharedPreferences.setInt(
        "fehlerbehebungsZaehler", fehlerbehebungsZaehler);
  }
}
