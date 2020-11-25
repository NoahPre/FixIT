// benutzerInfoProvider.dart
import "../../imports.dart";
import "package:http/http.dart" as http;

// für eine Erklärung der Provider siehe README.md
class BenutzerInfoProvider with ChangeNotifier {
  BenutzerInfoProvider() {
    holeUserInformationUndAuthentifiziere();
  }

  /// ob der Benutzer als Fehlermelder oder Fehlerbeheber angemeldet ist
  bool istFehlermelder = true;

  /// ob die Authentifizierung mit den in SharedPreferences gespeicherten Werten erfolgreich war
  bool istAuthentifiziert = true;

  /// StreamController zum Verwalten der Authentifizierung des Benutzers:
  StreamController authentifizierungController =
      StreamController<bool>.broadcast();
  Sink get authentifizierungSink => authentifizierungController.sink;
  Stream get authentifizierungStream => authentifizierungController.stream;

  /// überschreibt im Constructor die Variablen mit den entsprechenden Werten aus SharedPreferences &
  /// authentifiziert den Benutzer außerdem mit den in SharedPreferences gespeicherten Credentials und aktualisiert authentifizierungStream
  Future<void> holeUserInformationUndAuthentifiziere() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    istFehlermelder = sharedPreferences.getBool("istFehlermelder") ?? true;
    istAuthentifiziert = await authentifizierung();
  }

  /// wird aufgerufen, wenn der Benutzer sich erfolgreich registriert und damit authentifiziert hat &
  /// überschreibt die gespeicherten Werte in SharedPreferences mit ueberschreibeUserInformation() &
  /// setzt istAuthentifiziert auf true &
  /// aktualisiert authentifizierungStream
  Future<void> benutzerRegistriertSich({
    @required bool istFehlermelderInFunktion,
    @required String passwortInFunktion,
  }) async {
    await ueberschreibeUserInformation(
      istFehlermelderInFunktion: istFehlermelderInFunktion,
      passwortInFunktion: passwortInFunktion,
    );
    istAuthentifiziert = true;
    authentifizierungSink.add(true);
    notifyListeners();
  }

  /// überschreibt die gespeicherten Werte in sharedPreferences mit den gegebenen Werten
  Future<void> ueberschreibeUserInformation({
    @required bool istFehlermelderInFunktion,
    @required String passwortInFunktion,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.setBool(
    //   "istAngemeldet",
    //   this._istAngemeldet,
    // );
    // sharedPreferences.setString(
    //   "benutzername",
    //   this._benutzername,
    // );
    sharedPreferences.setBool(
      "istFehlermelder",
      istFehlermelderInFunktion,
    );
    sharedPreferences.setString(
      "passwort",
      passwortInFunktion,
    );
    notifyListeners();
  }

  /// authentifiziert den Benutzer mit den in SharedPreferences gespeicherten Werten
  Future<bool> authentifizierung() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool istFehlermelder = sharedPreferences.getBool("istFehlermelder") ?? true;
    String passwort = sharedPreferences.getString("passwort") ?? "";
    // schickt eine Anfrage mit den folgenden Informationen an den Server:
    // - ob der Benutzer Fehlermelder ist
    // - das Passwort, das der Benutzer beim ersten Starten bei der Registrierung eingegeben hat
    String url =
        "https://www.icanfixit.eu/authentifizierung.php?istFehlermelder=${istFehlermelder.toString()}&passwort=${passwort.toString()}";
    http.Response response = await http.get(url);
    print("response: " + response.body);
    // überprüft die Ausgabe des Scripts
    if (response.body == "1") {
      authentifizierungSink.add(true);
      return true;
    } else {
      authentifizierungSink.add(false);
      return false;
    }
  }

  /// authentifiziert den Benutzer mit den gegebenen Werten
  // wird in registrierung.dart benutzt, um anfangs das eingegebene Passwort zu überprüfen
  Future<bool> authentifizierungMitWerten({
    @required bool istFehlermelderInFunktion,
    @required String passwortInFunktion,
  }) async {
    print(istFehlermelderInFunktion.toString());
    // schickt eine Anfrage mit den folgenden Informationen an den Server:
    // - ob der Benutzer Fehlermelder ist
    // - das Passwort, das der Benutzer beim ersten Starten bei der Registrierung eingegeben hat
    String url =
        "https://www.icanfixit.eu/authentifizierung.php?istFehlermelder=${istFehlermelderInFunktion.toString()}&passwort=$passwortInFunktion";
    http.Response response = await http.get(url);
    print("response: " + response.body);
    // überprüft die Ausgabe des Scripts
    // TODO: warum wird hier von authentifizierung.php immer ein s mit ausgegeben
    if (response.body == "1") {
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    super.dispose();
    authentifizierungController.close();
  }
}
