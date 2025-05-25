// benutzer_info_provider.dart
import "dart:convert";
import "dart:async";
import "package:fixit/imports.dart";
import 'package:crypto/crypto.dart';
import "package:package_info_plus/package_info_plus.dart";

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
    await fehlerlisteProvider.holeFehler();
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
    try {
      // schickt eine Anfrage mit den folgenden Informationen an den Server:
      // - ob der Benutzer Fehlermelder ist
      // - das Passwort, das der Benutzer beim ersten Starten bei der Registrierung eingegeben hat
      String status = await kontaktiereServer(
          pfad: serverScripts.authentifizierung,
          parameter: {
            "istFehlermelder": istFehlermelder.toString(),
            "schule": schule,
            "token": token
          });
      // überprüft die Ausgabe des Scripts
      if (status == "1") {
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

  /// Authentifiziert den Benutzer mit den gegebenen Werten
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

    String status = await kontaktiereServer(
        pfad: serverScripts.authentifizierung,
        parameter: {
          "istFehlermelder": istFehlermelderInFunktion.toString(),
          "schule": schuleInFunktion,
          "token": token.toString(),
        });
    // überprüft die Ausgabe des Scripts
    if (status == "1") {
      return "true";
    } else if (status == "falsche_schule") {
      return "falsche_schule";
    } else if (status == "falsches_token") {
      return "falsches_token";
    } else {
      return "false";
    }
  }

  /// Ruft die Schuldaten einer Schule vom Server ab (z.B. Raumnummern-Bereich)
  Future<Map<String, dynamic>> holeSchuldaten({required String schule}) async {
    String status = await kontaktiereServer(
      pfad: serverScripts.gibSchuldaten,
      parameter: {
        "schule": schule,
      },
      trotzdemErlauben: true,
    );
    if ((status == "") ||
        (status == "falsche_schule") ||
        (status == "falsches_token")) {
      return {};
    } else {
      try {
        return jsonDecode(status)[0];
      } catch (error) {
        print(error.toString());
        return {};
      }
    }
  }

  // überprüft, ob die laufende Version der App noch von Serverseite unterstützt wird
  // nimmt den Wert aus gibUnterstuetzteVersion.php
  Future<bool> istUnterstuetzteVersion(
      {required BuildContext currentContext}) async {
    try {
      var packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      List<int> versionAsList = [];
      versionAsList.add(int.parse(version.split(".")[0]));
      versionAsList.add(int.parse(version.split(".")[1]));
      versionAsList.add(int.parse(version.split(".")[2]));
      String antwort = await kontaktiereServer(
        pfad: serverScripts.gibUnterstuetzteVersion,
        parameter: {},
      );
      List<int> responseAsList = [];
      responseAsList.add(int.parse(antwort.split(".")[0]));
      responseAsList.add(int.parse(antwort.split(".")[1]));
      responseAsList.add(int.parse(antwort.split(".")[2]));
      if (responseAsList[0] < versionAsList[0]) {
        return true;
      } else {
        if (responseAsList[1] < versionAsList[1]) {
          return true;
        } else {
          if (responseAsList[2] <= versionAsList[2]) {
            return true;
          } else {
            return false;
          }
        }
      }
    } catch (error) {
      print(error.toString());
      zeigeSnackBarNachricht(
        nachricht: error.toString(),
        context: currentContext,
        istError: true,
      );
      return true;
    }
  }

  // schaut, ob es eine neue Nachricht für die Benutzer auf dem Server gibt
  Future<Map<String, dynamic>?> nachrichtVomServer() async {
    String antwort = await kontaktiereServer(
      pfad: serverScripts.gibNachrichtVomServer,
      parameter: {"schule": schule, "token": token},
    );
    if ((antwort == "") ||
        (antwort == "1") ||
        (antwort == "falsche_schule") ||
        (antwort == "falsches_token")) {
      return null;
    } else {
      try {
        return jsonDecode(antwort);
      } catch (error) {
        print(error.toString());
        return {};
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    authentifizierungController.close();
    schuleController.close();
  }
}
