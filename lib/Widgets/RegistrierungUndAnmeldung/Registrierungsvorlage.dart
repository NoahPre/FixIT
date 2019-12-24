import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

//unsere files
import "./MitteilungsFunktionen.dart";

class Registrierungsvorlage extends StatefulWidget {

  final masterpasswort;

  Registrierungsvorlage({this.masterpasswort});

  @override
  State<StatefulWidget> createState() {
    return _RegistrierungsvorlageState();
  }
}

class _RegistrierungsvorlageState extends State<Registrierungsvorlage> {
  //Textfieldcontroller für das Benutzername Textfeld
  final _benutzernameController = TextEditingController();

  final _passwortController = TextEditingController();

  final _passwortWiederholenController = TextEditingController();

  final _masterpasswortController = TextEditingController();

  benutzerHatSichRegistriert() async {
    SharedPreferences sharedPreferencesInstance =
        await SharedPreferences.getInstance();
    bool istRegistriert = sharedPreferencesInstance.getBool("istRegistriert");
    //kontrolliert, ob der User nicht schon registriert ist
    //muss später abgeändert werden
    if (istRegistriert != true) {
      schonRegistriertMitteilung(context);
      return;
    }

    //kontrolliert, ob alle Passwörter übereinstimmen bzw. richtig sind
    if (_passwortController.text != _passwortWiederholenController.text || _masterpasswortController.text != widget.masterpasswort) {
      falscheEingabeMitteilung(context);
      return;
    }
    sharedPreferencesInstance.setBool('istAngemeldet', true);
    sharedPreferencesInstance.setBool("istRegistriert", true);
    sharedPreferencesInstance.setString(
      "benutzername",
      _benutzernameController.text,
    );
    sharedPreferencesInstance.setString("passwort", _passwortController.text);
    print("benutzerHatSichRegistriert");

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
            controller: _passwortWiederholenController,
            decoration: InputDecoration(labelText: "Passwort Wiederholen"),
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: _masterpasswortController,
            decoration: InputDecoration(labelText: "Masterpasswort"),
            keyboardType: TextInputType.text,
          ),
          //ist später nicht mehr zu sehen
          Center(
            child: Text("Das Masterpasswort ist fixit"),
          ),
          RaisedButton(
              child: Text("Registrierung abschließen"),
              color: Theme.of(context).buttonColor,
              onPressed: () {
                benutzerHatSichRegistriert();
              }),
          Center(
            child: Text(benutzernameAufScreen),
          ),
        ],
      ),
    );
  }
}
