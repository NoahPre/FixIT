// anmeldungProvider.dart

import "../../imports.dart";

// für eine Erklärung der Provider siehe README.md
class BenutzerInfoProvider with ChangeNotifier {
  BenutzerInfoProvider() {
    holeUserInformation();
  }

  bool _istAngemeldet = false;
  // String _benutzername = "";
  bool _istFehlermelder = true;

  bool get istAngemeldet => _istAngemeldet;
  // String get benutzername => _benutzername;
  bool get istFehlermelder => _istFehlermelder;

  set istAngemeldet(bool value) {
    _istAngemeldet = value;
    notifyListeners();
  }

  // set benutzername(String value) {
  //   _benutzername = value;
  //   notifyListeners();
  // }

  set istFehlermelder(bool value) {
    _istFehlermelder = value;
    notifyListeners();
  }

  // überschreibt im Constructor die Variablen mit den entsprechenden Werten aus SharedPreferences
  void holeUserInformation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _istAngemeldet = sharedPreferences.getBool("istAngemeldet") ?? false;
    // _benutzername = sharedPreferences.getString("benutzername") ?? "";
    _istFehlermelder = sharedPreferences.getBool("istFehlermelder") ?? true;
  }

  // diese Funktion überschreibt die Werte in SharedPreferences mit den aktuellen Werten dieser Klasse
  // um die korrekten Werte zu überschreiben, muss man also bevor man diese Funktion aufruft die entsprechenden Variablen überschreiben
  void ueberschreibeUserInformation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
      "istAngemeldet",
      this._istAngemeldet,
    );
    // sharedPreferences.setString(
    //   "benutzername",
    //   this._benutzername,
    // );
    sharedPreferences.setBool(
      "istFehlermelder",
      this._istFehlermelder,
    );
    notifyListeners();
  }

  // wird in home.dart aufgerufen, um zu überprüfen, ob der Benutzer angemeldet ist
  Future<bool> istBenutzerAngemeldet() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("istRegistriert");
  }
}
