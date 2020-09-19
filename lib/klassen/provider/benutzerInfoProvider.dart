// anmeldungProvider.dart
import "../../imports.dart";

// für eine Erklärung der Provider siehe README.md
class BenutzerInfoProvider with ChangeNotifier {
  BenutzerInfoProvider() {
    holeUserInformation();
  }

  bool _istRegistriert = false;
  // String _benutzername = "";
  bool _istFehlermelder = true;

  // StreamController zum Managen des Registrierungs Status
  StreamController<bool> _istBenutzerRegistriertController =
      StreamController<bool>();
  Sink<bool> get istBenuterRegistriertSink =>
      _istBenutzerRegistriertController.sink;
  Stream<bool> get istBenutzerRegistriertStream =>
      _istBenutzerRegistriertController.stream;

  bool get istRegistriert => _istRegistriert;
  // String get benutzername => _benutzername;
  bool get istFehlermelder => _istFehlermelder;

  set istRegistriert(bool value) {
    _istRegistriert = value;
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
    _istRegistriert = sharedPreferences.getBool("istRegistriert") ?? false;
    // _benutzername = sharedPreferences.getString("benutzername") ?? "";
    _istFehlermelder = sharedPreferences.getBool("istFehlermelder") ?? true;
    istBenuterRegistriertSink.add(_istRegistriert);
    print("istRegistriert = $_istRegistriert");
  }

  // diese Funktion überschreibt die Werte in SharedPreferences mit den aktuellen Werten dieser Klasse
  // um die korrekten Werte zu überschreiben, muss man also bevor man diese Funktion aufruft die entsprechenden Variablen überschreiben
  void ueberschreibeUserInformation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(
      "istRegistriert",
      this._istRegistriert,
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

  // schließt die StreamController
  @override
  void dispose() {
    super.dispose();
    _istBenutzerRegistriertController.close();
  }
}
