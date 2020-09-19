// benutzerInfoProvider.dart
// 1
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";


// brauchen wir vielleicht gar nicht
class BenutzerInfoProvider with ChangeNotifier {
  BenutzerInfoProvider() {
    holeUserInformation();
  }

  String _benutzername = "";
  String _passwort = "";
  bool _istFehlermelder = true;

  String get benutzername => _benutzername;
  String get passwort => _passwort;
  bool get istFehlermelder => _istFehlermelder;

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
    this._benutzername = sharedPreferences.getString("benutzername") ?? "";
    this._passwort = sharedPreferences.getString("passwort") ?? "";
    this._istFehlermelder = sharedPreferences.getBool("istFehlermelder") ?? true;
    print(this._benutzername);
    print(this._passwort);
  }



}


