// benutzer_info_provider.dart
import "../../imports.dart";
import "package:http/http.dart" as http;
import 'package:crypto/crypto.dart';
import "package:package_info/package_info.dart";

/// Dieser Provider enthält die Informationen über den Benutzer, so etwa
/// - ob der Benutzer Fehlermelder oder -beheber ist
/// - das Authentifizierungstoken
/// - die Schule des Benutzers
///
/// für eine Erklärung der Provider siehe Dokumentation/Provider.md
class BenutzerInfoProvider with ChangeNotifier {
  BenutzerInfoProvider({required this.fehlerlisteProvider}) {
    holeUserInformationUndAuthentifiziere();
  }

  /// Der FehlerlisteProvider
  final FehlerlisteProvider fehlerlisteProvider;

  /// ob der Benutzer als Fehlermelder oder Fehlerbeheber angemeldet ist
  bool istFehlermelder = true;

  /// Schule des Benutzers
  String schule = "";

  /// Token zur Authentifizierung
  String token = "";

  /// ob die Authentifizierung mit den in SharedPreferences gespeicherten Werten erfolgreich war
  bool? istAuthentifiziert;

  /// StreamController zum Verwalten der Authentifizierung des Benutzers:
  StreamController<bool> authentifizierungController = StreamController<bool>();
  Sink<bool> get authentifizierungSink => authentifizierungController.sink;
  Stream<bool> get authentifizierungStream =>
      authentifizierungController.stream;

  /// StreamController für die Schule des Benutzers
  StreamController<String> schuleController = StreamController<String>();
  Sink<String> get schuleSink => schuleController.sink;
  Stream<String> get schuleStream => schuleController.stream;

  /// überschreibt im Constructor die Variablen mit den entsprechenden Werten aus SharedPreferences &
  /// authentifiziert den Benutzer außerdem mit den in SharedPreferences gespeicherten Credentials und aktualisiert authentifizierungStream
  Future<void> holeUserInformationUndAuthentifiziere() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    istFehlermelder = sharedPreferences.getBool("istFehlermelder") ?? true;
    schule = sharedPreferences.getString("schule") ?? "mtg";
    token = sharedPreferences.getString("token") ?? "";
    schuleSink.add(schule);
    // TODO: bald entfernen!
    await setzeSchuleGleichMTG();
    istAuthentifiziert = await authentifizierung();
  }

  // Übergangsfunktion
  // setzt den Wert "schule" in SharedPreferences auf "mtg"
  // wird benötigt, damit sich nicht jeder erneut anmelden muss
  Future<void> setzeSchuleGleichMTG() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? schuleInFunktion = sharedPreferences.getString("schule");
    if (schuleInFunktion == null) {
      sharedPreferences.setString("schule", "mtg");
    }
  }

  /// wird aufgerufen, wenn der Benutzer sich erfolgreich anmeldet und damit authentifiziert hat &
  /// überschreibt die gespeicherten Werte in SharedPreferences mit ueberschreibeUserInformation() &
  /// setzt istAuthentifiziert auf true &
  /// aktualisiert authentifizierungStream
  Future<void> benutzerMeldetSichAn({
    required bool istFehlermelderInFunktion,
    required String schuleInFunktion,
    required String passwortInFunktion,
  }) async {
    await ueberschreibeUserInformation(
      istFehlermelderInFunktion: istFehlermelderInFunktion,
      schuleInFunktion: schuleInFunktion,
      passwortInFunktion: passwortInFunktion,
    );
    schule = schuleInFunktion;
    schuleSink.add(schuleInFunktion);
    // holt die spezifischen Schuldaten von gibSchuldaten.php
    Map<String, dynamic> schuldaten =
        await holeSchuldaten(schule: schuleInFunktion);
    LokaleDatenbank lokaleDatenbank = LokaleDatenbank();
    await lokaleDatenbank.schreibeLokaleSchuldaten(schuldaten);
    // aktualisiert fehlerlisteProvider
    await fehlerlisteProvider.holeToken();
    await fehlerlisteProvider.holeLokaleDaten();
    print("snons");
    istAuthentifiziert = true;
    authentifizierungSink.add(true);
    notifyListeners();
  }

  /// Meldet den Benutzer ab.
  Future<void> benutzerMeldetSichAb() async {
    await ueberschreibeUserInformation(
      istFehlermelderInFunktion: true,
      schuleInFunktion: "",
      passwortInFunktion: "",
      andereWerteZuruecksetzen: true,
    );
    istAuthentifiziert = false;
    authentifizierungSink.add(false);
    // setzt andere Werte in FehlerlisteProvider zurück
    fehlerlisteProvider.fehlerliste = [];
    fehlerlisteProvider.angezeigteFehlerliste = [];
    fehlerlisteProvider.fehlerlisteSink
        .add(fehlerlisteProvider.angezeigteFehlerliste);
    fehlerlisteProvider.eigeneFehlermeldungenIDs = [];
    fehlerlisteProvider.fehlermeldungsZaehler = 0;
    fehlerlisteProvider.fehlerbehebungsZaehler = 0;
    notifyListeners();
  }

  /// Überschreibt die gespeicherten Werte in sharedPreferences mit den gegebenen Werten und berechnet das Authentifizierungs Token
  ///
  /// entfernt außerdem alle lokal gespeicherten Daten in LokaleDatenbank
  Future<void> ueberschreibeUserInformation({
    required bool istFehlermelderInFunktion,
    required String schuleInFunktion,
    required String passwortInFunktion,
    bool andereWerteZuruecksetzen = false,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    istFehlermelder = istFehlermelderInFunktion;
    schule = schuleInFunktion;
    String tokenInFunktion =
        sha256.convert(utf8.encode(passwortInFunktion)).toString();
    sharedPreferences.setBool(
      "istFehlermelder",
      istFehlermelderInFunktion,
    );
    sharedPreferences.setString(
      "schule",
      schuleInFunktion,
    );
    sharedPreferences.setString(
      "token",
      tokenInFunktion,
    );
    if (andereWerteZuruecksetzen == true) {
      sharedPreferences.setInt("fehlermeldungsZaehler", 0);
      sharedPreferences.setInt("fehlerbehebungsZaehler", 0);
      LokaleDatenbank lokaleDatenbank = LokaleDatenbank();
      await lokaleDatenbank.schreibeLokaleFehlerdaten({});
      await lokaleDatenbank.schreibeLokaleSchuldaten({});
      await lokaleDatenbank.schreibeLokaleServerNachrichtenDaten({});
    }
    notifyListeners();
  }

  /// authentifiziert den Benutzer mit den in SharedPreferences gespeicherten Werten
  Future<bool> authentifizierung() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // bool istFehlermelder = sharedPreferences.getBool("istFehlermelder") ?? true;
    // String schule = sharedPreferences.getString("schule") ?? "";
    // String tokenInFunktion = sharedPreferences.getString("token") ?? "";
    try {
      // schickt eine Anfrage mit den folgenden Informationen an den Server:
      // - ob der Benutzer Fehlermelder ist
      // - das Passwort, das der Benutzer beim ersten Starten bei der Registrierung eingegeben hat
      String url =
          "https://www.icanfixit.eu/authentifizierung.php?istFehlermelder=$istFehlermelder&schule=$schule&token=$token";
      http.Response response = await http.get(Uri.parse(url));
      // überprüft die Ausgabe des Scripts
      if (response.body == "1") {
        authentifizierungSink.add(true);
        return true;
      } else {
        authentifizierungSink.add(false);
        return false;
      }
    } catch (error) {
      await Future.delayed(const Duration(seconds: 3), () {});
      holeUserInformationUndAuthentifiziere();
      return false;
    }
  }

  /// authentifiziert den Benutzer mit den gegebenen Werten
  // wird in registrierung.dart benutzt, um anfangs das eingegebene Passwort zu überprüfen
  Future<String> authentifizierungMitWerten({
    required bool istFehlermelderInFunktion,
    required String schuleInFunktion,
    required String passwortInFunktion,
  }) async {
    var token = sha256.convert(utf8.encode(passwortInFunktion));
    // schickt eine Anfrage mit den folgenden Informationen an den Server:
    // - ob der Benutzer Fehlermelder ist
    // - das Passwort, das der Benutzer beim ersten Starten bei der Registrierung eingegeben hat
    String url =
        "https://www.icanfixit.eu/authentifizierung.php?istFehlermelder=${istFehlermelderInFunktion.toString()}&schule=${schuleInFunktion.toString()}&token=$token";
    http.Response response = await http.get(Uri.parse(url));
    // überprüft die Ausgabe des Scripts
    if (response.body == "1") {
      return "true";
    } else if (response.body == "falsche_schule") {
      return "falsche_schule";
    } else if (response.body == "falsches_token") {
      return "falsches_token";
    } else {
      return "false";
    }
  }

  Future<Map<String, dynamic>> holeSchuldaten({required String schule}) async {
    String url = "https://www.icanfixit.eu/gibSchuldaten.php?schule=$schule";
    http.Response response = await http.get(Uri.parse(url));
    if ((response.body == "") ||
        (response.body == "falsche_schule") ||
        (response.body == "falsches_token")) {
      return {};
    } else {
      try {
        return jsonDecode(response.body)[0];
      } catch (error) {
        print(error.toString());
        return {};
      }
    }
  }

  // überprüft, ob die laufende Version der App noch von Serverseite unterstützt wird
  // nimmt den Wert aus gibUnterstuetzteVersion.php
  Future<String> istUnterstuetzteVersion() async {
    try {
      var packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      List<int> versionAsList = [];
      versionAsList.add(int.parse(version.split(".")[0]));
      versionAsList.add(int.parse(version.split(".")[1]));
      versionAsList.add(int.parse(version.split(".")[2]));
      String url = "https://www.icanfixit.eu/gibUnterstuetzteVersion.php";
      http.Response response = await http.get(Uri.parse(url));
      List<int> responseAsList = [];
      responseAsList.add(int.parse(response.body.split(".")[0]));
      responseAsList.add(int.parse(response.body.split(".")[1]));
      responseAsList.add(int.parse(response.body.split(".")[2]));
      if (responseAsList[0] <= versionAsList[0]) {
        if (responseAsList[1] <= versionAsList[1]) {
          if (responseAsList[2] <= versionAsList[2]) {
            return "true";
          } else {
            return "false";
          }
        } else {
          return "false";
        }
      } else {
        return "false";
      }
    } catch (error) {
      print(error.toString());
      return "error";
    }
  }

  // schaut, ob es eine neue Nachricht für die Benutzer auf dem Server gibt
  Future<Map<String, dynamic>?> nachrichtVomServer() async {
    String url =
        "https://www.icanfixit.eu/gibNachrichtVomServer.php?schule=$schule&token=$token";
    http.Response response = await http.get(Uri.parse(url));
    if ((response.body == "") ||
        (response.body == "falsche_schule") ||
        (response.body == "falsches_token")) {
      return null;
    } else {
      try {
        return jsonDecode(response.body);
      } catch (error) {
        print(error.toString());
        return {};
      }
    }
  }

  void dispose() {
    super.dispose();
    authentifizierungController.close();
    schuleController.close();
  }
}
