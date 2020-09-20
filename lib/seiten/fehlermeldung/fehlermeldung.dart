// fehlermeldungVorlage.dart
import "../../imports.dart";
import "package:intl/intl.dart";

class Fehlermeldung extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FehlermeldungState();
  }
}

class _FehlermeldungState extends State<Fehlermeldung> {
  // globalKey für das Form Widget
  final _formKey = GlobalKey<FormState>();
  // dynamische Überschrift
  String _ueberschrift = "Fehler in Raum ";
  // Zeugs fürs Beschreibungstextfeld
  TextEditingController _beschreibungController = TextEditingController();
  FocusNode _beschreibungNode = FocusNode();
  // für die Raumnummerneingabe
  TextEditingController _raumController = TextEditingController();
  FocusNode _raumNode = FocusNode();
  String _dropdownButtonText = "";

  // Fehler, der auf dieser Seite gemeldet wird
  Fehler fehler = Fehler(
    id: DateTime.now().millisecondsSinceEpoch,
    datum: DateFormat("yyyyMMdd").format(DateTime.now()).toString(),
    //das muss man noch updaten
    gefixt: "0",
  );

  @override
  void initState() {
    super.initState();

    // TODO: muss man diesen Listener hier entfernen?
    //sorgt dafür, dass man weiß, wann die Tastatur zu sehen ist
    KeyboardVisibilityNotification().addNewListener(
      onShow: () {
        zeigeFertigButton(context);
      },
      onHide: () {
        entferneFertigButton();
      },
    );
  }

  // updatet die Überschrift und den Text des Dropdown Buttons
  void updateText({
    String textInTextfield,
  }) {
    setState(() {
      _ueberschrift = "Fehler in Raum " + textInTextfield;
      fehler.raum = textInTextfield;
    });
  }

  // Validatoren:
  String _uerberpruefeRaumnummer(String raumnummer) {
    if (raumnummer.isEmpty || raumnummer == "") {
      return "Bitte eine Raumnummer eingeben";
    }
    else if (raumnummer.length > 3 || int.parse(raumnummer) > 420) {
      return "Bitte eine gültige Raumnummer eingeben";
    }
    else {
      return null;
    }
  }

  String _ueberpruefeBeschreibung(String beschreibung) {
    if (beschreibung.isEmpty || beschreibung == "") {
      return "Bitte eine Beschreibung eingeben";
    }
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    Size _size = MediaQuery.of(context).size;
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);

    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _ueberschrift,
          style: thema.textTheme.headline1,
        ),
      ),
      // Button um den Fehler zu melden
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "FloatingActionButton",
        label: Row(
          children: <Widget>[
            Text(
              "Senden",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(width: deviceSize.width * 0.01),
            Icon(
              Icons.send,
              color: Colors.white,
            ),
          ],
        ),
        onPressed: () {
          if (_formKey.currentState.validate() == false) {
            return;
          }
          setState(() {
            fehler.beschreibung = _beschreibungController.text;
            // fehler.melder = benutzerInfoProvider.benutzername;
          });
          fehlerlisteProvider.fehlerGemeldet(fehler: fehler);
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Form(
            key: _formKey,
            child: Column(

              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade100,
                      ),
                      padding: EdgeInsets.all(4.0),
                      child: DropdownButton<String>(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        elevation: 8,
                        value: _dropdownButtonText,
                        hint: Text("Präfix"),
                        items: [
                          "",
                          "K",
                          "N",
                          "Z",
                        ].map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (String value) {
                          updateText(
                            textInTextfield: value + _raumController.text,
                          );
                          setState(() {
                            _dropdownButtonText = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: _size.width * 0.04,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: _raumController,
                        decoration: InputDecoration(
                          labelText: "Raumnummer",
                          hintText: "",
                        ),
                        focusNode: _raumNode,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => updateText(
                          textInTextfield:
                              _dropdownButtonText + _raumController.text,
                        ),
                        validator: (String raumnummer) => _uerberpruefeRaumnummer(raumnummer),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _beschreibungController,
                  decoration: InputDecoration(
                    labelText: "Beschreibung",
                    hintText: "",
                  ),
                  focusNode: _beschreibungNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (String beschreibung) => _ueberpruefeBeschreibung(beschreibung),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // für die Logik vom Fertig Button über der Tastatur:
  //overlayEntry property für die Fertig Button Widget Logik
  OverlayEntry overlayEntry;

  //helfen, den Fertig Button über dem Zahlenfeld anzuzeigen
  void zeigeFertigButton(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: FertigButton());
    });

    overlayState.insert(overlayEntry);
  }

  //lässt den Fertig Button über dem Zahlenfeld erscheinen
  void entferneFertigButton() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }
}
