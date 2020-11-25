// registrierung.dart
import "../imports.dart";
import "package:url_launcher/url_launcher.dart";
import "package:flutter/gestures.dart";

class Registrierung extends StatefulWidget {
  @override
  _RegistrierungState createState() => _RegistrierungState();
}

class _RegistrierungState extends State<Registrierung> {
  /// Key für die Form (wird benötigt)
  final _formKey = GlobalKey<FormState>();

  /// GroupValue für die Radio-Buttons
  int _radioGroupValue = 0;

  /// TextEditingController für das Passwort Textfeld
  final _passwortController = TextEditingController();

  /// GestureRecognizer für den Link zu der Datenschutz Erklärung
  TapGestureRecognizer _datenschutzErklaerungRecognizer;

  @override
  void initState() {
    super.initState();
    _datenschutzErklaerungRecognizer = TapGestureRecognizer()
      ..onTap = _oeffneDatenschutzErklaerung;
  }

  @override
  void dispose() {
    _datenschutzErklaerungRecognizer.dispose();
    super.dispose();
  }

  /// wird ausgeführt, wenn man einen anderen RadioButton auswählt
  void _radioButtonChanged(int value) {
    setState(() {
      _radioGroupValue = value;
    });
  }

  /// Validator für das Passwort Textfeld
  String _validierePasswortTextfeld({
    @required bool istFehlermelder,
    @required String passwort,
  }) {
    if (passwort == "") {
      return "Bitte das Passwort eingeben";
    } else {
      return null;
    }
  }

  /// zeigt eine Alert Dialog mit Hilfe zum Passwort
  Future<void> _zeigePasswortHilfe(
      {@required BuildContext currentContext}) async {
    await showDialog(
      context: currentContext,
      builder: (context) => AlertDialog(
        title: Text("Passwort Hilfe"),
        content: Text(
            "Das Passwort sollte Ihnen entweder via E-Mail oder von einem unserer Administratoren genannt worden sein"),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  Future<void> _passwortIstFalsch(
      {@required BuildContext currentContext}) async {
    await showDialog(
      context: currentContext,
      builder: (context) => AlertDialog(
        title: Text("Authentifizierung fehlgeschlagen"),
        content: Text(
            "Das eingegebene Passwort für den angegebenen Benutzer ist falsch. Bitte versuchen Sie es erneut."),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  /// öffnet die Datenschutz Erklärung von FixIT im Standardbrowser des Benutzers
  void _oeffneDatenschutzErklaerung() async {
    const url = "https://www.icanfixit.eu/datenschutz.html";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch: $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    // Provider, der alle benötigten Daten und Funktionen für die Anmeldung hat
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context);

    // diese beiden Funktionen müssen in build() stehen, da sie auf benutzerInfoProvider zugreifen
    /// überprüft das gegebene Passwort
    Future<bool> _ueberpruefePasswort({
      @required bool istFehlermelderInFunktion,
      @required String passwortInFunktion,
    }) async {
      // sendet eine Anfrage mit den eingegebenen Informationen an den Server
      bool istAuthentifiziert =
          await benutzerInfoProvider.authentifizierungMitWerten(
        istFehlermelderInFunktion: istFehlermelderInFunktion,
        passwortInFunktion: passwortInFunktion,
      );

      return istAuthentifiziert;
    }

    /// wird ausgeführt, wenn das eingegebene Passwort erfolgreich von _ueberpruefePasswort() geprüft wurde
    Future<void> _userRegistriertSich() async {
      // macht eine Anfangsüberprüfung
      if (_formKey.currentState.validate()) {
        bool istFehlermelderInFunktion;
        String passwortInFunktion = _passwortController.text;

        if (_radioGroupValue == 0) {
          istFehlermelderInFunktion = true;
        } else {
          istFehlermelderInFunktion = false;
        }
        // überprüft das eingegebene Passwort
        if (await _ueberpruefePasswort(
          istFehlermelderInFunktion: istFehlermelderInFunktion,
          passwortInFunktion: passwortInFunktion,
        )) {
          print("userRegistriertSich");
          await benutzerInfoProvider.benutzerRegistriertSich(
            istFehlermelderInFunktion: istFehlermelderInFunktion,
            passwortInFunktion: passwortInFunktion,
          );
        }
        // informiert den Benutzer, dass sein Passwort falsch ist
        else {
          await _passwortIstFalsch(currentContext: context);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Registrierung bei FixIT"),
        // ist nur da, damit der Zurückpfeil nicht angezeigt wird
        leading: Container(
          color: thema.primaryColor,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Ich bin ",
                    style: thema.textTheme.bodyText1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 0,
                        groupValue: _radioGroupValue,
                        onChanged: (value) {
                          _radioButtonChanged(value);
                        },
                      ),
                      Text(
                        "Fehlermelder",
                        style: thema.textTheme.bodyText1,
                      ),
                      Radio(
                        value: 1,
                        groupValue: _radioGroupValue,
                        onChanged: (int value) {
                          _radioButtonChanged(value);
                        },
                      ),
                      Text(
                        "Fehlerbeheber",
                        style: thema.textTheme.bodyText1,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Masterpasswort",
                              hintText: "Sollte Ihnen mitgeteilt worden sein"),
                          validator: (value) {
                            return _validierePasswortTextfeld(
                              passwort: value,
                              istFehlermelder: _radioGroupValue == 0,
                            );
                          },
                          autocorrect: false,
                          controller: _passwortController,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.help,
                          color: Colors.black,
                        ),
                        tooltip: "Masterpasswort Hilfe",
                        onPressed: () => _zeigePasswortHilfe(
                          currentContext: context,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Datenschutz Erklärung Disclaimer
                  RichText(
                    maxLines: 10,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        text: "Indem Sie fortfahren stimmen Sie unserer ",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "Datenschutz Erklärung",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                            recognizer: _datenschutzErklaerungRecognizer,
                          ),
                          TextSpan(text: " zu.")
                        ]),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Text(
                      "Registrieren",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: thema.primaryColor,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: thema.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(18.0)),
                    onPressed: () => _userRegistriertSich(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
