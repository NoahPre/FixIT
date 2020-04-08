// registrierung.dart
// 1
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
// 2
import "../klassen/provider/anmeldungProvider.dart";
// 3
import "package:provider/provider.dart";

class Registrierung extends StatefulWidget {
  Registrierung({
    this.userWurdeAngemeldet,
    this.benutzername,
    this.passwort,
    this.istAngemeldet,
  });
  // lässt Home() neu bilden
  final userWurdeAngemeldet;
  // Benutzername und Passwort für die Anmeldung
  final String benutzername;
  final String passwort;
  final bool istAngemeldet;

  @override
  _RegistrierungState createState() => _RegistrierungState();
}

class _RegistrierungState extends State<Registrierung> {
  // Key für die Form (wird benötigt)
  final _formKey = GlobalKey<FormState>();
  // GroupValue für die Radio-Buttons
  int _radioGroupValue = 0;

  // TextEditingController für die vier Textfelder
  final _benutzernameController = TextEditingController();
  final _passwortController = TextEditingController();
  final _passwortWiederholenController = TextEditingController();
  final _masterpasswortController = TextEditingController();

  // wird ausgeführt, wenn man einen anderen RadioButton auswählt
  void _radioButtonChanged(int value) {
    print(value.toString());
    setState(() {
      _radioGroupValue = value;
    });
  }

  // Methoden für die Validation der Form Textfelder
  String _validateBenutzernameTextfeld({String benutzername}) {
    return benutzername.isEmpty ? "Bitte einen Benutzernamen eingeben" : null;
  }

  String _validatePasswortTextfeld({String passwort}) {
    return passwort.isEmpty ? "Bitte ein Passwort eingeben" : null;
  }

  String _validatePasswortWiederholenTextfeld({String passwort}) {
    return passwort.isEmpty
        ? "Bitte ein Passwort eingeben"
        : passwort == _passwortController.text
            ? null
            : "Ihre Passwörter müssen übereinstimmen";
  }

  String _validateMasterpasswortTextfeld({String masterpasswort}) {
    return masterpasswort == "fixit" ? null : "Falsches Masterpasswort";
  }

  @override
  Widget build(BuildContext context) {
    // Provider, der alle benötigten Daten und Funktionen für die Anmeldung hat
    final AnmeldungProvider anmeldungProvider =
        Provider.of<AnmeldungProvider>(context);

    // checkt, ob der eingegebene Benutzername und das eingegebene Passwort mit dem richtigen Benutzernamen und dem richtigen Passwort übereinstimmt
    bool kannUserSichAnmelden() {
      if (anmeldungProvider.benutzername == _benutzernameController.text &&
          anmeldungProvider.passwort == _passwortController.text) {
        return true;
      } else {
        return false;
      }
    }

    void userMeldetSichAn() {
      if (_formKey.currentState.validate()) {
        if (kannUserSichAnmelden()) {
          print("User hat sich angemeldet");
          anmeldungProvider.istAngemeldet = true;
          anmeldungProvider.ueberschreibeUserInformation();
        } else {
          //zeigt einen Dialog, der dem User sagt, dass er etwas falsch eingegeben hat
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Fehler"),
              content: Text(
                  "Benutzername und Passwort stimmen nicht überein. Haben Sie sich vielleicht vertippt?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          );
        }
      }
    }

    void userRegistriertSich() {
      if (_formKey.currentState.validate()) {
        print("User hat sich registriert");
        anmeldungProvider.istAngemeldet = true;
        anmeldungProvider.benutzername = _benutzernameController.text;
        anmeldungProvider.passwort = _passwortController.text;
        if (_radioGroupValue == 0) {
          anmeldungProvider.istFehlermelder = true;
        } else {
          anmeldungProvider.istFehlermelder = false;
        }
        anmeldungProvider.ueberschreibeUserInformation();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Registrierung bei FixIt"),
        // ist nur da, damit der Zurückpfeil nicht angezeigt wird
        leading: Container(
          color: Colors.blue,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Container mit Benutzername Textfeld
                  Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "Benutzername",
                          hintText: "Herr/Frau IHR NAME"),
                      validator: (value) =>
                          _validateBenutzernameTextfeld(benutzername: value),
                      autocorrect: false,
                      controller: _benutzernameController,
                    ),
                  ),
                  // Container mit Passwort Textfeld
                  Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "Passwort",
                          hintText: "Geben Sie ein starkes Passwort ein"),
                      validator: (value) =>
                          _validatePasswortTextfeld(passwort: value),
                      autocorrect: false,
                      controller: _passwortController,
                    ),
                  ),
                  // Container mit Passwort wiederholen Textfeld
                  Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Passwort wiederholen",
                        hintText: "Wiederholen Sie ihr Passwort",
                      ),
                      validator: (value) =>
                          _validatePasswortWiederholenTextfeld(passwort: value),
                      autocorrect: false,
                      controller: _passwortWiederholenController,
                    ),
                  ),
                  // Container mit Masterpasswort Textfeld
                  Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "Masterpasswort",
                          hintText: "Sollte Ihnen mittgeteilt worden sein"),
                      validator: (value) =>
                          _validateMasterpasswortTextfeld(masterpasswort: value),
                      autocorrect: false,
                      controller: _masterpasswortController,
                    ),
                  ),
                  Divider(),
                  Text("Ich bin "),
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
                      Text("Fehlermelder"),
                      Radio(
                        value: 1,
                        groupValue: _radioGroupValue,
                        onChanged: (int value) {
                          _radioButtonChanged(value);
                        },
                      ),
                      Text("Fehlerbeheber"),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FlatButton(
                          child: Text("Stattdessen anmelden"),
                          onPressed: () => userMeldetSichAn(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                          child: Text("Registrieren"),
                          onPressed: () => userRegistriertSich(),
                        ),
                      ),
                    ],
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
