import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

//unsere files
import "./MitteilungsFunktionen.dart";

class Anmeldungsvorlage extends StatefulWidget {
  final masterpasswort;

  Anmeldungsvorlage({this.masterpasswort});

  @override
  State<StatefulWidget> createState() {
    return _AnmeldungsvorlageState();
  }
}

class _AnmeldungsvorlageState extends State<Anmeldungsvorlage> {
  //Textfieldcontroller für das username Textfeld
  final _benutzernameController = TextEditingController();

  final _passwortController = TextEditingController();

  final _masterpasswortController = TextEditingController();

  benutzerHatSichAngemeldet() async {
    SharedPreferences sharedPreferencesInstance =
        await SharedPreferences.getInstance();
    String benutzername = sharedPreferencesInstance.getString("benutzername");
    String passwort = sharedPreferencesInstance.getString("passwort");
    bool istRegistriert = sharedPreferencesInstance.getBool("istRegistriert");

    //überprüft, ob der User sich überhaupt schonmal registriert hat
    //nur nötig, wenn wir die Daten lokal auf dem Gerät speichern, also nur vorübergehend
    if (istRegistriert != true) {
      benutzerIstNichtRegistriertMitteilung(context);
      return;
    }

    //überprüft, ob die eingetippten Daten mit den gespeicherten übereinstimmen
    //im Moment werden die Daten noch lokal auf dem Gerät gespeichert, später auf dem Server
    if (benutzername != _benutzernameController.text ||
        passwort != _passwortController.text ||
        widget.masterpasswort != _masterpasswortController.text) {
      falscheEingabeMitteilung(context);
      return;
    }

    sharedPreferencesInstance.setBool('istAngemeldet', true);

    print("benutzerHatSichAngemeldet");

    setState(() {
      this.benutzernameAufScreen =
          sharedPreferencesInstance.getString("benutzername");
    });
  }

  //nur zur Probe
  String benutzernameAufScreen = "abc";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          TextField(
            controller: _benutzernameController,
            decoration: InputDecoration(labelText: "Benutzername"),
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: _passwortController,
            decoration: InputDecoration(labelText: "Passwort"),
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: _masterpasswortController,
            decoration: InputDecoration(labelText: "Masterpasswort"),
            keyboardType: TextInputType.text,
          ),
          RaisedButton(
              child: Text("Anmeldung abschließen"),
              color: Theme.of(context).buttonColor,
              onPressed: () {
                benutzerHatSichAngemeldet();
              }),
          Center(
            child: Text(benutzernameAufScreen),
          ),
        ],
      ),
    );
  }
}
