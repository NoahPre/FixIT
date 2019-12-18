import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class Registrierungsvorlage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrierungsvorlageState();
  }
}

class _RegistrierungsvorlageState extends State<Registrierungsvorlage> {
  //Textfieldcontroller für das username Textfeld
  final _benutzernameController = TextEditingController();

  benutzerHatSichRegistriert() async {
    SharedPreferences sharedPreferencesInstance = await SharedPreferences.getInstance();
    sharedPreferencesInstance.setBool('istRegistriert', true);
    sharedPreferencesInstance.setString(
      "benutzername",
      _benutzernameController.text,
    );
    print("benutzerHatSichRegistriert");

  speicherBenutzernamen() async {
        SharedPreferences sharedPreferencesInstance = await SharedPreferences.getInstance();

        String benutzername = sharedPreferencesInstance.getString('benutzername');
        bool istRegistriert = sharedPreferencesInstance.getBool("istRegistriert");

        if (istRegistriert == false) {
          print("istRegistriert == false in Registrierungsbutton");
        }

        this.benutzernameAufScreen = benutzername;
      }

    setState(() {
      speicherBenutzernamen();
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
          RaisedButton(
              child: Text("Registrierung abschließen"),
              color: Colors.red,
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
