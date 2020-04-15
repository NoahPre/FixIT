// anmeldungProvider.dart
// 1
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

// für eine Erklärung der Provider siehe README.md
class AnmeldungProvider with ChangeNotifier {
  AnmeldungProvider() {
    holeUserInformation();
  }

  bool _istAngemeldet = false;
  String _benutzername = "";
  String _passwort = "";
  bool _istFehlermelder = true;

  bool get istAngemeldet => _istAngemeldet;
  String get benutzername => _benutzername;
  String get passwort => _passwort;
  bool get istFehlermelder => _istFehlermelder;

  set istAngemeldet(bool value) {
    _istAngemeldet = value;
    notifyListeners();
  }

  set benutzername(String value) {
    _benutzername = value;
    notifyListeners();
  }

  set passwort(String value) {
    _passwort = value;
    notifyListeners();
  }

  set istFehlermelder(bool value) {
    _istFehlermelder = value;
    notifyListeners();
  }

  // überschreibt im Constructor die Variablen mit den entsprechenden Werten aus SharedPreferences
  void holeUserInformation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    this._istAngemeldet = sharedPreferences.getBool("istAngemeldet") ?? false;
    this._benutzername = sharedPreferences.getString("benutzername") ?? "";
    this._passwort = sharedPreferences.getString("passwort") ?? "";
    this._istFehlermelder = sharedPreferences.getBool("istFehlermelder") ?? true;
    print(this._benutzername);
    print(this._passwort);
    print("istAngemeldet = ${this._istAngemeldet}");
  }

  // diese Funktion überschreibt die Werte in SharedPreferences mit den aktuellen Werten dieser Klasse
  // um die korrekten Werte zu überschreiben, muss man also bevor man diese Funktion aufruft die entsprechenden Variablen überschreiben
  void ueberschreibeUserInformation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
      "istAngemeldet",
      this._istAngemeldet,
    );
    sharedPreferences.setString(
      "benutzername",
      this._benutzername,
    );
    sharedPreferences.setString(
      "passwort",
      this._passwort,
    );
    sharedPreferences.setBool(
      "istFehlermelder",
      this._istFehlermelder,
    );
    notifyListeners();
  }
}
