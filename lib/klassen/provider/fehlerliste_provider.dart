// fehlerliste_provider.dart
import "package:fixit/imports.dart";
import "package:http/http.dart" as http;
import "package:image_picker/image_picker.dart";

/// Dieser Provider enthält die Fehlerliste, die dem Benutzer angezeigt wird.
///
/// Außerdem enthält er Methoden, mit denen man
/// - neue Fehler hinzufügen kann
/// - Fehler editieren kann / Fehler als gefixt markieren kann
/// - Fehler löschen kann
///
/// Jede Funktion, die mit dem Server kommuniziert, gibt den Status in Form eines Strings zurück.
/// "1" als Status bedeutet: alles ist richtig abgelaufen
/// "0": irgendetwas ist falsch gelaufen
/// spezifischere Probleme haben einen eigenen Statuswert (etwa "falsches_token" für ein falsches Authentifizierungstoken)
class FehlerlisteProvider with ChangeNotifier {
  FehlerlisteProvider() {
    holeToken();
    // holeFehler();
    holeLokaleDaten();
  }

  /// Schule des Benutzers
  String schule = "";

  /// Token zur Authentifizierung
  String token = "";

  /// Speichert, ob der Benutzer Fehlermelder ist oder nicht.
  ///
  /// Existiert schon in BenutzerInfoProvider, ist hier aber der Bequemlichkeit halber nocheinmal.
  // bool istFehlermelder;
  Map<String, dynamic> schuldaten = {};

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

  /// Zähler, der bei Fehlerbehebern die Anzahl an gelöschten (behobenen) Fehlermeldungen speichert
  int fehlerbehebungsZaehler = 0;

  /// Instanz von LokaleDatenbank zum Zugreifen auf lokal gespeicherte Daten
  LokaleDatenbank lokaleDatenbank = LokaleDatenbank();

  Future<void> holeToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token") ?? "";
  }

  // wird ganz am Anfang ausgeführt und holt alle Fehler vom Server
  Future<String> holeFehler() async {
    var url =
        'https://www.icanfixit.eu/gibAlleFehler.php?schule=$schule&token=$token';
    var jsonObjekt = [];
    String status = "";
    try {
      http.Response response = await http.get(Uri.parse(url));
      jsonObjekt = jsonDecode(response.body) ?? [];
      status = response.body;
    } catch (error) {
      await Future.delayed(const Duration(seconds: 3), () {});
      holeFehler();
      return "";
    }
    // überschreibt fehlerliste mit den Werten aus der Datenbank
    fehlerliste = List.generate(jsonObjekt.length, (int index) {
      // erstellt für jeden in gibAlleFehler.php zurückgegebenen Eintrag einen Fehler in fehlerliste
      return Fehler.from(jsonObjekt[index]);
    });
    // fügt die geholten Fehler dem fehlerlisteController hinzu und aktualisiert damit das Widget Fehlerliste
    fehlerlisteSink.add(fehlerliste);
    // räumt die lokal gespeicherte Liste der eigenen Fehlermeldungen auf (eigeneFehlermeldungenIDs, gespeichert in SharedPreferences)
    await entferneGeloeschteFehlermeldungenIDs();
    notifyListeners();
    return status;
  }

  /// ruft lokale Daten aus dem Speicher ab, z.B. eigeneFehlermeldungenIDs, die Werte der verschiedenen Zähler und die Schuldaten
  Future<void> holeLokaleDaten() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    eigeneFehlermeldungenIDs =
        sharedPreferences.getStringList("eigeneFehlermeldungenIDs") ?? [];
    fehlermeldungsZaehler =
        sharedPreferences.getInt("fehlermeldungsZaehler") ?? 0;
    fehlerbehebungsZaehler =
        sharedPreferences.getInt("fehlerbehebungsZaehler") ?? 0;
    schuldaten = await lokaleDatenbank.holeLokaleSchuldaten();
    notifyListeners();
  }

  /// Sendet den übergebenen Fehler an den Server
  ///
  /// es kann immer nur entweder image oder pickedImage angegeben werden
  Future<String> fehlerGemeldet(
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
    String status = await schreibeFehler(
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
    return status;
  }

  /// Startet das Upload der übergebenen Daten
  Future<String> starteUpload({
    required Fehler fehler,
    required String base64EncodedImage,
    required String pfad,
    required String dateiname,
  }) async {
    return upload(
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
    http.post(
        Uri.parse(
            "https://www.icanfixit.eu/schreibeBild.php?schule=$schule&token=$token"),
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

  /// Ändert den Status des Fehlers mit der angegebenen ID
  /// "0": Fehler nicht behoben
  /// "1": Fehler behoben
  Future<String> fehlerStatusGeaendert({
    required String id,
    required String gefixt,
  }) async {
    // wenn der Fehler gerade gefixt wurde, dann wird der Fehlerbehebungszähler um 1 erhöht
    if (gefixt == "1") {
      await erhoeheFehlerbehebungsZaehler();
    }

    var url =
        "https://www.icanfixit.eu/behebeFehler.php?id=$id&gefixt=$gefixt&schule=$schule&token=$token";
    http.Response response = await http.get(Uri.parse(url));
    holeFehler();
    return response.body;
    // notifyListeners();
  }

  /// Löscht den übergebenen Fehler
  Future<String> fehlerGeloescht({
    required Fehler fehler,
    required bool istFehlermelder,
  }) async {
    String status = await entferneFehler(
      id: fehler.id,
      fileName: fehler.bild,
      istFehlermelder: istFehlermelder,
    );
    fehlerliste!
        .removeWhere((aktuellerFehler) => aktuellerFehler.id == fehler.id);
    fehlerlisteSink.add(fehlerliste);
    notifyListeners();
    return status;
  }

  /// Fügt einen Fehler mit schreibeFehler.php hinzu
  Future<String> schreibeFehler({
    required String id,
    required String datum,
    required String raum,
    required String beschreibung,
    required String gefixt,
    required String bild,
  }) async {
    // die URL, die aufgerufen werden muss (mit den Argumenten implementiert)
    var url =
        "https://www.icanfixit.eu/schreibeFehler.php?id=$id&datum=$datum&raum=$raum&beschreibung=$beschreibung&gefixt=$gefixt&bild=$bild&schule=$schule&token=$token";
    var answer = await http.get(Uri.parse(url));
    return answer.body;
  }

  /// Löscht einen Fehler mit entferneFehler.php
  Future<String> entferneFehler({
    required String id,
    required String fileName,
    required bool istFehlermelder,
  }) async {
    var url =
        "https://www.icanfixit.eu/entferneFehler.php?id=$id&fileName=$fileName&schule=$schule&token=$token";
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
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
    // das ist der Wert, der für das automatische Löschen von Fehlermeldungen zuständig ist
    // sobald eine Fehlermeldung als gefixt gekennzeichnet wurde, wird dieser Wert jedes Mal dann erhöht, wenn der Autor dieser
    // Fehlermeldung die App öffnet
    // sobald er dies 3 Mal getan hat (der Wert also auf 3 ist), wird die Fehlermeldung mit dem Schließen der App gelöscht
    // idsList.add("0");

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

  Future<void> setzeFehlermeldungsZaehlerZurueck() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    fehlermeldungsZaehler = 0;
    await sharedPreferences.setInt(
        "fehlermeldungsZaehler", fehlermeldungsZaehler);
  }

  Future<void> setzeFehlerbehebungsZaehlerZurueck() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    fehlerbehebungsZaehler = 0;
    await sharedPreferences.setInt(
        "fehlerbehebungsZaehler", fehlerbehebungsZaehler);
  }

  Future<void> entferneGeloeschteFehlermeldungenIDs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> aktuelleFehlermeldungenIDs = [];
    if (fehlerliste != null) {
      aktuelleFehlermeldungenIDs =
          fehlerliste!.map((aktuellerFehler) => aktuellerFehler.id).toList();
    }
    List<String> gespeicherteEigeneFehlermeldungenIDs =
        sharedPreferences.getStringList("eigeneFehlermeldungenIDs") ?? [];
    List<String> eigeneFehlermeldungenIDsInFunktion = [];
    for (String i in gespeicherteEigeneFehlermeldungenIDs) {
      if (aktuelleFehlermeldungenIDs.contains(i)) {
        eigeneFehlermeldungenIDsInFunktion.add(i);
      }
    }
    await sharedPreferences.setStringList(
        "eigeneFehlermeldungenIDs", eigeneFehlermeldungenIDsInFunktion);
    eigeneFehlermeldungenIDs = eigeneFehlermeldungenIDsInFunktion;
  }
}
