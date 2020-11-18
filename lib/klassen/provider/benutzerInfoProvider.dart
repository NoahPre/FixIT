// benutzerInfoProvider.dart
import "../../imports.dart";
import "package:http/http.dart" as http;

// für eine Erklärung der Provider siehe README.md
class BenutzerInfoProvider with ChangeNotifier {
  BenutzerInfoProvider() {
    holeUserInformation();
  }

  // bool _istAngemeldet = true;
  // String _benutzername = "";
  bool istFehlermelder = true;

  // bool get istAngemeldet => _istAngemeldet;
  // // String get benutzername => _benutzername;
  // bool get istFehlermelder => _istFehlermelder;

  // set istAngemeldet(bool value) {
  //   _istAngemeldet = value;
  //   notifyListeners();
  // }

  // set benutzername(String value) {
  //   _benutzername = value;
  //   notifyListeners();
  // }

  // überschreibt im Constructor die Variablen mit den entsprechenden Werten aus SharedPreferences
  Future<void> holeUserInformation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // _istAngemeldet = sharedPreferences.getBool("istAngemeldet") ?? false;

    // _benutzername = sharedPreferences.getString("benutzername") ?? "";
    istFehlermelder = sharedPreferences.getBool("istFehlermelder") ?? true;
  }

  /// überschreibt die gespeicherten Werte in sharedPreferences mit den gegebenen
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

  // wird in home.dart aufgerufen, um zu überprüfen, ob der Benutzer angemeldet ist
  // Future<bool> istBenutzerAngemeldet() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   return sharedPreferences.getBool("istAngemeldet") ?? false;
  // }
  /// authentifiziert den Benutzer mit den gegebenen Werten
  // wird in registrierung.dart benutzt, um eingangs das eingegebene Passwort zu überprüfen
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

  /// authentifiziert den Benutzer mit den in SharedPreferences gespeicherten Werten
  // wird in home.dart verwendet, um sich beim Start der App sicherzugehen, dass das gespeicherte Passwort richtig ist
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
    // TODO: warum wird hier von authentifizierung.php immer ein s mit ausgegeben
    if (response.body == "1") {
      return true;
    } else {
      return false;
    }
  }
}
