// anmeldung.dart
import "dart:io";
import "../imports.dart";
import "package:flutter/gestures.dart";

class Anmeldung extends StatefulWidget {
  @override
  _AnmeldungState createState() => _AnmeldungState();
}

class _AnmeldungState extends State<Anmeldung> {
  /// Key für die Form (wird benötigt)
  final _formKey = GlobalKey<FormState>();

  /// GroupValue für die Radio-Buttons
  int? _radioGroupValue = 0;

  /// TextEditingController für das Passwort Textfeld
  final TextEditingController _passwortController = TextEditingController();

  /// TextEditingController für das Schule Textfeld
  final TextEditingController _schuleController = TextEditingController();

  /// boolean Wert, der speichert, ob das Passwort sichtbar oder verdeckt ist
  bool _passwortIstVerdeckt = true;

  /// Icon für den rechtes Rand des Passwort Textfeldes
  ///
  /// zeigt an, ob das Passwort sichtbar oder verdeckt ist
  Icon _passwortIcon = Icon(
    Icons.visibility,
    color: Colors.black,
  );

  /// GestureRecognizer für den Link zu der Datenschutz Erklärung
  TapGestureRecognizer? _datenschutzErklaerungRecognizer;

  @override
  void initState() {
    super.initState();
    _datenschutzErklaerungRecognizer = TapGestureRecognizer()
      ..onTap = () async => await oeffneURL(
            adresse: adresse,
            pfad: serverScripts.datenschutz,
          );
  }

  @override
  void dispose() {
    _datenschutzErklaerungRecognizer!.dispose();
    super.dispose();
  }

  /// wird ausgeführt, wenn man einen anderen RadioButton auswählt
  void _radioButtonChanged(int? value) {
    setState(() {
      _radioGroupValue = value;
    });
  }

  /// Validator für das Passwort Textfeld
  String? _validierePasswortTextfeld({
    required bool istFehlermelder,
    required String? passwort,
  }) {
    if (passwort == "") {
      return "Bitte das Passwort eingeben";
    } else {
      return null;
    }
  }

  /// zeigt einen Alert Dialog mit Hilfe zum Passwort
  Future<void> _zeigePasswortHilfe(
      {required BuildContext currentContext}) async {
    await showDialog(
      context: currentContext,
      builder: (context) => AlertDialog(
        title: Text("Passwort Hilfe"),
        content: Text(
            "Das Passwort sollte Ihnen entweder via E-Mail oder von einem unserer Administratoren genannt worden sein"),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }

  /// zeigt einen Alert Dialog mit Hilfe zum Schul-Textfeld
  Future<void> _zeigeSchuleHilfe({required BuildContext currentContext}) async {
    await showDialog(
      context: currentContext,
      builder: (context) => AlertDialog(
        title: Text("Schulauswahl Hilfe"),
        content: Text(
          "Geben Sie bitte das Kürzel Ihrer Schule an: \n\n" +
              "Maria Theresia Gymnasium -> mtg",
          style: Theme.of(currentContext).textTheme.bodyLarge,
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text(
                "OK",
                style: Theme.of(currentContext).textTheme.bodyLarge,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _anmeldungFehlgeschlagen({
    required BuildContext currentContext,
    required String anzuzeigenderText,
  }) async {
    await showDialog(
      context: currentContext,
      builder: (context) => AlertDialog(
        title: Text(
          "Anmeldung fehlgeschlagen",
          textAlign: TextAlign.center,
        ),
        content: Text(
          anzuzeigenderText + " Bitte versuchen Sie es erneut.",
          textAlign: TextAlign.justify,
          style: Theme.of(currentContext).textTheme.bodyLarge,
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text(
                "OK",
                style: Theme.of(currentContext).textTheme.bodyLarge,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    // Provider, der alle benötigten Daten und Funktionen für die Anmeldung hat
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context);

    // diese beiden Funktionen müssen in build() stehen, da sie auf benutzerInfoProvider zugreifen
    /// überprüft das gegebene Passwort
    Future<String> _ueberpruefePasswort({
      required bool istFehlermelderInFunktion,
      required String schuleInFunktion,
      required String passwortInFunktion,
      required BuildContext currentContext,
    }) async {
      try {
        // sendet eine Anfrage mit den eingegebenen Informationen an den Server
        String istAuthentifiziert =
            await benutzerInfoProvider.authentifizierungMitWerten(
          istFehlermelderInFunktion: istFehlermelderInFunktion,
          schuleInFunktion: schuleInFunktion,
          passwortInFunktion: passwortInFunktion,
        );
        return istAuthentifiziert;
      } on SocketException catch (_) {
        zeigeSnackBarNachricht(
          nachricht: "Nicht mit dem Internet verbunden",
          context: currentContext,
          istError: true,
        );
        return "keine_internetverbindung";
      } catch (error) {
        print(error.toString());
        return "error";
      }
    }

    Future<void> _benutzerMeldetSichAn(
        {required BuildContext currentContext}) async {
      // macht eine Anfangsüberprüfung
      if (_formKey.currentState!.validate()) {
        bool istFehlermelderInFunktion;
        String schuleInFunktion = _schuleController.text.toLowerCase();
        String passwortInFunktion = _passwortController.text;

        if (_radioGroupValue == 0) {
          istFehlermelderInFunktion = true;
        } else {
          istFehlermelderInFunktion = false;
        }
        // überprüft das eingegebene Passwort
        switch (await _ueberpruefePasswort(
          istFehlermelderInFunktion: istFehlermelderInFunktion,
          schuleInFunktion: schuleInFunktion,
          passwortInFunktion: passwortInFunktion,
          currentContext: currentContext,
        )) {
          case "true":
            await benutzerInfoProvider.benutzerMeldetSichAn(
              istFehlermelderInFunktion: istFehlermelderInFunktion,
              schuleInFunktion: schuleInFunktion,
              passwortInFunktion: passwortInFunktion,
            );
            print("benutzerMeldetSichAn");
            break;
          case "falsche_schule":
            // informiert den Benutzer darüber, dass er das falsche Schulkürzel eingegeben hat
            await _anmeldungFehlgeschlagen(
                currentContext: currentContext,
                anzuzeigenderText:
                    "Die angegebene Schule ist nicht bei FixIT registriert.");
            break;
          case "falsches_token":
            // informiert den Benutzer darüber, dass er das falsche Passwort eingegeben hat
            await _anmeldungFehlgeschlagen(
                currentContext: currentContext,
                anzuzeigenderText:
                    "Das Passwort für die angegebene Schule und die ausgewählte Rolle ist falsch.");
            break;
          default:
            await _anmeldungFehlgeschlagen(
                currentContext: currentContext,
                anzuzeigenderText: "Etwas ist schiefgelaufen.");
            break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Anmeldung bei FixIT"),
        // ist nur da, damit der Zurückpfeil nicht angezeigt wird
        leading: Container(
          color: thema.colorScheme.primary,
        ),
        backgroundColor: thema.colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("FixIT ausprobieren"),
        tooltip: "Demo-Modus von FixIT",
        backgroundColor: thema.colorScheme.secondary,
        onPressed: () {
          benutzerInfoProvider.benutzerMeldetSichAn(
              istFehlermelderInFunktion: false,
              schuleInFunktion: "demo",
              passwortInFunktion:
                  "b29f63636a8d56a4dbaa9123ff7afe8cb601c1104d40f34c1a3226b572b60341");
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false,
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
                    style: thema.textTheme.bodyLarge,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 0,
                        groupValue: _radioGroupValue,
                        activeColor: thema.colorScheme.primary,
                        onChanged: (dynamic value) {
                          _radioButtonChanged(value);
                        },
                      ),
                      TextButton(
                        child: Text(
                          "Fehlermelder",
                          style: thema.textTheme.bodyLarge,
                        ),
                        onPressed: () => _radioButtonChanged(0),
                      ),
                      Radio(
                        value: 1,
                        groupValue: _radioGroupValue,
                        activeColor: thema.colorScheme.primary,
                        onChanged: (int? value) {
                          _radioButtonChanged(value);
                        },
                      ),
                      TextButton(
                        child: Text(
                          "Fehlerbeheber",
                          style: thema.textTheme.bodyLarge,
                        ),
                        onPressed: () => _radioButtonChanged(1),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Schule",
                            labelStyle: TextStyle(
                              color: thema.colorScheme.primary,
                            ),
                            hintText: "Das Kürzel Ihrer Schule",
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: thema.colorScheme.primary),
                            ),
                          ),
                          autocorrect: false,
                          maxLines: 1,
                          controller: _schuleController,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.help,
                          color: Colors.black,
                        ),
                        tooltip: "Schulauswahl Hilfe",
                        onPressed: () => _zeigeSchuleHilfe(
                          currentContext: context,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Passwort",
                            labelStyle: TextStyle(
                              color: thema.colorScheme.primary,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: thema.colorScheme.primary),
                            ),
                            suffix: IconButton(
                              icon: _passwortIcon,
                              onPressed: () {
                                setState(() {
                                  if (_passwortIstVerdeckt == true) {
                                    _passwortIstVerdeckt = false;
                                    _passwortIcon = Icon(
                                      Icons.visibility_off,
                                      color: Colors.black,
                                    );
                                  } else {
                                    _passwortIstVerdeckt = true;
                                    _passwortIcon = Icon(
                                      Icons.visibility,
                                      color: Colors.black,
                                    );
                                  }
                                });
                              },
                            ),
                          ),
                          obscureText: _passwortIstVerdeckt,
                          autocorrect: false,
                          maxLines: 1,
                          controller: _passwortController,
                          validator: (value) {
                            return _validierePasswortTextfeld(
                              passwort: value,
                              istFehlermelder: _radioGroupValue == 0,
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.help,
                          color: Colors.black,
                        ),
                        tooltip: "Passwort Hilfe",
                        onPressed: () => _zeigePasswortHilfe(
                          currentContext: context,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
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
                            text: "Datenschutzerklärung",
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
                  Builder(
                    builder: (BuildContext currentContext) => ElevatedButton(
                      child: Text(
                        "Anmelden",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: thema.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: thema.colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      onPressed: () => _benutzerMeldetSichAn(
                        currentContext: currentContext,
                      ),
                    ),
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
