// registrierung.dart
import "../imports.dart";

class Registrierung extends StatefulWidget {
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
  final _masterpasswortController = TextEditingController();

  // wird ausgeführt, wenn man einen anderen RadioButton auswählt
  void _radioButtonChanged(int value) {
    print(value.toString());
    setState(() {
      _radioGroupValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    // Provider, der alle benötigten Daten und Funktionen für die Anmeldung hat
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context);

    // Methoden für die Validation der Form Textfelder
    // String _validateBenutzernameTextfeld({String benutzername}) {
    //   return benutzername.isEmpty ? "Bitte einen Benutzernamen eingeben" : null;
    // }

    String _validateMasterpasswortTextfeld({
      @required String masterpasswort,
      @required bool istFehlermelder,
    }) {
      if (masterpasswort == "") {
        return "Bitte das Masterpasswort eingeben";
      }
      switch (istFehlermelder) {
        case true:
          return masterpasswort == "fixit" ? null : "Falsches Masterpasswort";
        case false:
          return masterpasswort == "Fixit" ? null : "Falsches Masterpasswort";
        default:
          return null;
      }
    }

    void _userRegistriertSich() {
      if (_formKey.currentState.validate()) {
        print("userRegistriertSich");
        benutzerInfoProvider.istBenuterRegistriertSink.add(true);
        benutzerInfoProvider.istRegistriert = true;
        if (_radioGroupValue == 0) {
          benutzerInfoProvider.istFehlermelder = true;
        } else {
          benutzerInfoProvider.istFehlermelder = false;
        }
        benutzerInfoProvider.ueberschreibeUserInformation();
      }
    }

    // zeigt eine Alert Dialog mit Hilfe zum Benutzernamen
    // void _zeigeBenutzernameHilfe() {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: Text("Benutzername Hilfe"),
    //       content: Text("Hier steht ein erklärender Text zum Benutzernamen"),
    //       actions: <Widget>[
    //         FlatButton(
    //           child: Text("OK"),
    //           onPressed: () => Navigator.pop(context),
    //         )
    //       ],
    //     ),
    //   );
    // }

    // zeigt eine Alert Dialog mit Hilfe zum Benutzernamen
    void _zeigeMasterpasswortHilfe() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Masterpasswort Hilfe"),
          content: Text("Hier steht ein erklärender Text zum Masterpasswort"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Registrierung bei FixIt"),
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
                  // Container mit Benutzername Textfeld
                  // Row(
                  //   children: <Widget>[
                  //     Flexible(
                  //       child: TextFormField(
                  //         decoration: InputDecoration(
                  //             labelText: "Benutzername",
                  //             hintText: "Herr/Frau IHR NAME"),
                  //         validator: (value) => _validateBenutzernameTextfeld(
                  //             benutzername: value),
                  //         autocorrect: false,
                  //         controller: _benutzernameController,
                  //       ),
                  //     ),
                  //     IconButton(
                  //       icon: Icon(
                  //         Icons.help,
                  //         color: thema.accentIconTheme.color,
                  //       ),
                  //       tooltip: "Benutzername Hilfe",
                  //       onPressed: () => _zeigeBenutzernameHilfe(),
                  //     ),
                  //   ],
                  // ),
                  // Container mit Masterpasswort Textfeld
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Masterpasswort",
                              hintText: "Sollte Ihnen mitgeteilt worden sein"),
                          validator: (value) => _validateMasterpasswortTextfeld(
                            masterpasswort: value,
                            istFehlermelder: _radioGroupValue == 0,
                          ),
                          autocorrect: false,
                          controller: _masterpasswortController,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.help,
                          // TODO: bei eventuellem darkmode das hier updaten
                          color: Colors.black,
                        ),
                        tooltip: "Masterpasswort Hilfe",
                        onPressed: () => _zeigeMasterpasswortHilfe(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
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
                  const SizedBox(
                    height: 10.0,
                  ),
                  // TODO: das hier beim Release entfernen
                  Text(
                    "Zum Debuggen: \nPasswort Fehlermelder: fixit, \nPasswort Fehlerbeheber: Fixit",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: thema.textTheme.bodyText1,
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
