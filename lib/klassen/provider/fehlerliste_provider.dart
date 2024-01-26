// fehlerliste_provider.dart
import "dart:convert";
import "dart:io";
import "dart:async";
import "package:fixit/imports.dart";
import 'package:fixit/klassen/thema.dart';
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

  /// ob der Benutzer als Fehlermelder oder Fehlerbeheber angemeldet ist
  bool istFehlermelder = true;

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

  /// Liste aller Fehler, die vom Server für die Institution des Benutzers empfangen wurden
  List<Fehler> fehlerliste = [];

  /// Sortierte Liste der Fehler, die dem Benutzer auf der Startseite angezeigt werden
  List<Fehler> angezeigteFehlerliste = [];

  /// Sortierung der angezeigten Fehler
  Sortierung _sortierung = Sortierung.datum_absteigend;

  Sortierung get sortierung {
    return _sortierung;
  }

  set sortierung(Sortierung sortierungInFunktion) {
    _sortierung = sortierungInFunktion;
    sortiereFehlerliste(
        sortierung: sortierungInFunktion,
        zuSortierendeListe: angezeigteFehlerliste);
    fehlerlisteSink.add(angezeigteFehlerliste);
  }

  /// Instanz von LokaleDatenbank zum Zugreifen auf lokal gespeicherte Daten
  LokaleDatenbank lokaleDatenbank = LokaleDatenbank();

  Map<String, dynamic> lokaleFehlerdaten = {
    "eigene_gefixte_fehlermeldungen": [],
    "eigene_fehlermeldungen_ids": [],
  };

  /// IDs der Fehlermeldungen des Benutzers
  List<dynamic> eigeneFehlermeldungenIDs = [];

  /// Zähler, der die Anzahl an abgesendeten Fehlermeldungen speichert
  int fehlermeldungsZaehler = 0;

  /// Zähler, der bei Fehlerbehebern die Anzahl an gelöschten (behobenen) Fehlermeldungen speichert
  int fehlerbehebungsZaehler = 0;

  /// Liste an Fehlern, die beim Schließen der App entfernt werden
  List<Fehler> zuEntfernendeFehlermeldungen = [];

  Future<void> holeToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token") ?? "";
  }

  // wird ganz am Anfang ausgeführt und holt alle Fehler vom Server
  Future<String> holeFehler() async {
    String jsonString = await kontaktiereServer(
      pfad: serverScripts.gibAlleFehler,
      parameter: {"schule": schule, "token": token},
      trotzdemErlauben: true,
    );
    // TODO: Error beim ersten Starten mit "falsches_token" beheben
    try {
      var jsonObjekt = jsonDecode(jsonString);

      // überschreibt fehlerliste mit den Werten aus der Datenbank
      fehlerliste = List.generate(jsonObjekt.length, (int index) {
        // erstellt für jeden in gibAlleFehler.php zurückgegebenen Eintrag einen Fehler in fehlerliste
        return Fehler.from(jsonObjekt[index]);
      });
      angezeigteFehlerliste = [];
      sortiereGefixteFehlerAus();
      sortiereFehlerliste(
          sortierung: _sortierung, zuSortierendeListe: angezeigteFehlerliste);
      // fügt die geholten Fehler dem fehlerlisteController hinzu und aktualisiert damit das Widget Fehlerliste
      fehlerlisteSink.add(angezeigteFehlerliste);
      // räumt die lokal gespeicherte Liste der eigenen Fehlermeldungen auf (eigeneFehlermeldungenIDs, gespeichert in SharedPreferences)
      await entferneGeloeschteFehlermeldungenIDs();
      notifyListeners();
      return jsonString;
    } catch (e) {
      return "";
    }
  }

  /// ruft lokale Daten aus dem Speicher ab, z.B. eigeneFehlermeldungenIDs, die Werte der verschiedenen Zähler und die Schuldaten
  Future<void> holeLokaleDaten() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    istFehlermelder = sharedPreferences.getBool("istFehlermelder") ?? true;
    lokaleFehlerdaten = await lokaleDatenbank.holeLokaleFehlerdaten();
    eigeneFehlermeldungenIDs =
        lokaleFehlerdaten["eigene_fehlermeldungen_ids"] ?? [];
    fehlermeldungsZaehler =
        sharedPreferences.getInt("fehlermeldungsZaehler") ?? 0;
    fehlerbehebungsZaehler =
        sharedPreferences.getInt("fehlerbehebungsZaehler") ?? 0;
    schuldaten = await lokaleDatenbank.holeLokaleSchuldaten();
    notifyListeners();
  }

  void sortiereGefixteFehlerAus() {
    if (istFehlermelder == true) {
      //TODO: kann man das hier noch eleganter oder sparsamer lösen (sodass das nicht jedes Mal wiederholt wird)?
      for (Fehler aktuellerFehler in fehlerliste) {
        if (aktuellerFehler.gefixt == "0" ||
            eigeneFehlermeldungenIDs.contains(aktuellerFehler.id)) {
          angezeigteFehlerliste.add(aktuellerFehler);
        }
      }
    } else {
      angezeigteFehlerliste = List.from(fehlerliste);
    }
  }

  /// Sendet den übergebenen Fehler an den Server
  ///
  /// Es kann immer nur entweder image oder pickedImage angegeben werden
  Future<String> fehlerGemeldet(
      {required Fehler fehler, File? image, XFile? pickedImage}) async {
    String dateiname = "";
    // TODO: das hier alles ein wenig sicherer und generell besser machen
    // Bild wird hochgeladen, wenn eins aufgenommen wurde
    // image vs pickedImage: eines ist direkt von der Kamera aufgenommen, das andere aus der Galerie ausgesucht
    if (image != null) {
      // erstellt den Dateinamen des Bildes
      dateiname = fehler.id + "." + image.path.split('/').last.split(".")[1];
      fehler.bild = dateiname;
      await starteUpload(
        fehler: fehler,
        base64EncodedImage: base64Encode(
          await image.readAsBytes(),
        ),
        pfad: image.path,
        dateiname: dateiname,
      );
    }
    if (pickedImage != null) {
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

    // sendet den Fehler zum Server mit schreibeFehler(.php)
    String status = await kontaktiereServer(
      pfad: serverScripts.schreibeFehler,
      parameter: {
        "schule": schule,
        "token": token,
        "id": fehler.id,
        "datum": fehler.datum,
        "raum": fehler.raum,
        "beschreibung": fehler.beschreibung,
        "gefixt": fehler.gefixt,
        "bild": dateiname,
      },
    );

    fehlerliste.add(fehler);
    angezeigteFehlerliste.insert(0, fehler);
    fehlerlisteSink.add(angezeigteFehlerliste);
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
    return bildHochladen(
      pfad: serverScripts.schreibeBild,
      schule: schule,
      token: token,
      dateiname: dateiname,
      base64Image: base64EncodedImage,
    );
  }

  /// Ändert den Status des Fehlers mit der angegebenen ID (mit behebeFehler(.php))
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
    String status = await kontaktiereServer(
      pfad: serverScripts.behebeFehler,
      parameter: {"schule": schule, "token": token, "id": id, "gefixt": gefixt},
    );
    holeFehler();

    return status;
  }

  /// Löscht den übergebenen Fehler mit entferneFehler(.php)
  Future<String> fehlerGeloescht({
    required Fehler fehler,
    required bool istFehlermelder,
  }) async {
    String status = await kontaktiereServer(
      pfad: serverScripts.entferneFehler,
      parameter: {
        "schule": schule,
        "token": token,
        "id": fehler.id,
        "fileName": fehler.bild
      },
    );

    fehlerliste.removeWhere(
        (Fehler aktuellerFehler) => aktuellerFehler.id == fehler.id);
    angezeigteFehlerliste.removeWhere(
        (Fehler aktuellerFehler) => aktuellerFehler.id == fehler.id);
    fehlerlisteSink.add(angezeigteFehlerliste);
    notifyListeners();
    return status;
  }

  void dispose() {
    super.dispose();
    fehlerlisteController.close();
    // entferneZuEntfernendeFehlermeldungen();
  }

  Future<void> entferneZuEntfernendeFehlermeldungen() async {
    for (Fehler zuEntfernenderFehler in zuEntfernendeFehlermeldungen) {
      fehlerGeloescht(
        fehler: zuEntfernenderFehler,
        istFehlermelder: istFehlermelder,
      );
    }
    zuEntfernendeFehlermeldungen.clear();
  }

  /// Speichert die ID einer Fehlermeldung lokal auf dem Gerät, wenn ein Fehler gemeldet wurde
  Future<void> speichereFehlerID({required String neueID}) async {
    eigeneFehlermeldungenIDs.add(neueID);
    lokaleFehlerdaten["eigene_fehlermeldungen_ids"] = eigeneFehlermeldungenIDs;
    await lokaleDatenbank.schreibeLokaleFehlerdaten(lokaleFehlerdaten);
    notifyListeners();
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

  /// Entfernt die IDs der Fehlermeldungen des Benutzers, die von ihm oder von Fehlerbehebern gelöscht wurden
  /// aus fehlerdaten.json (sowohl aus "eigene_gefixte_fehlermeldungen" und "eigene_fehlermeldungen_ids")
  Future<void> entferneGeloeschteFehlermeldungenIDs() async {
    List<String> aktuelleFehlermeldungenIDs = [];
    aktuelleFehlermeldungenIDs =
        fehlerliste.map((aktuellerFehler) => aktuellerFehler.id).toList();
    List<dynamic> gespeicherteEigeneFehlermeldungenIDs =
        lokaleFehlerdaten["eigene_fehlermeldungen_ids"] ?? [];
    List<String> eigeneFehlermeldungenIDsInFunktion = [];
    for (String i in gespeicherteEigeneFehlermeldungenIDs) {
      if (aktuelleFehlermeldungenIDs.contains(i)) {
        eigeneFehlermeldungenIDsInFunktion.add(i);
      }
    }
    eigeneFehlermeldungenIDs = eigeneFehlermeldungenIDsInFunktion;
    lokaleFehlerdaten["eigene_fehlermeldungen_ids"] =
        eigeneFehlermeldungenIDsInFunktion;
    List<Map<String, dynamic>> eigeneGefixteFehlermeldungenInFunktion = [];
    for (Map<String, dynamic> eintrag
        in lokaleFehlerdaten["eigene_gefixte_fehlermeldungen"] ?? {}) {
      if (aktuelleFehlermeldungenIDs.contains(eintrag["id"] ?? "") == true) {
        eigeneGefixteFehlermeldungenInFunktion.add(eintrag);
      }
    }
    lokaleFehlerdaten["eigene_gefixte_fehlermeldungen"] =
        eigeneGefixteFehlermeldungenInFunktion;
    await lokaleDatenbank.schreibeLokaleFehlerdaten(lokaleFehlerdaten);
  }

  /// Diese Funktion entfernt (löscht) automatisch als gefixt markierte Fehlermeldungen des Benutzers nach einer bestimmten Zeit
  Future<void> holeFehlerUndEntferneAutomatischGefixteMeldungen() async {
    await holeFehler();
    List<String> eigeneGefixteFehlermeldungenIDs = [];
    for (Fehler aktuellerFehler in fehlerliste) {
      if (eigeneFehlermeldungenIDs.contains(aktuellerFehler.id) &&
          aktuellerFehler.gefixt == "1") {
        eigeneGefixteFehlermeldungenIDs.add(aktuellerFehler.id);
      }
    }
    List<dynamic> eigeneGefixteFehlermeldungen =
        lokaleFehlerdaten["eigene_gefixte_fehlermeldungen"] ?? [];
    List<String> alteEintraege = [];
    List<Map<String, dynamic>> zuEntfernendeEintraege = [];
    for (Map<String, dynamic> eintrag in eigeneGefixteFehlermeldungen) {
      if (eigeneGefixteFehlermeldungenIDs.contains(eintrag["id"].toString())) {
        alteEintraege.add(eintrag["id"]);
        // erhöht den Anzahl Wert um 1
        eintrag["anzahl"] = eintrag["anzahl"] + 1;
        // löscht Fehlermeldungen, deren Anzahl größer als 1 ist
        if (eintrag["anzahl"] > 1) {
          zuEntfernendeFehlermeldungen.add(fehlerliste.singleWhere(
              (Fehler fehler) => fehler.id == eintrag["id"].toString()));
          zuEntfernendeEintraege.add(eintrag);
        }
      }
    }
    // TODO: Einträge aus dem JSON hier auch entfernen, wenn der Benutzer eine eigene gefixte Fehlermeldung löscht
    // muss so sein, da man, wenn man die Einträge im for loop oben entfernen würde, die geloopte Liste während des Loops verändern würde
    for (Map<String, dynamic> eintrag in zuEntfernendeEintraege) {
      eigeneGefixteFehlermeldungen.remove(eintrag);
    }

    for (String aktuelleID in eigeneGefixteFehlermeldungenIDs) {
      if (alteEintraege.contains(aktuelleID) == false) {
        eigeneGefixteFehlermeldungen.add({"id": aktuelleID, "anzahl": 0});
        showSimpleNotification(
          Text("Ihre Fehlermeldung wurde gefixt!"),
          background: thema.colorScheme.secondary,
          duration: Duration(seconds: 6),
          slideDismissDirection: DismissDirection.up,
        );
      }
    }
    lokaleFehlerdaten["eigene_gefixte_fehlermeldungen"] =
        eigeneGefixteFehlermeldungen;
    await lokaleDatenbank.schreibeLokaleFehlerdaten(lokaleFehlerdaten);
  }
}
