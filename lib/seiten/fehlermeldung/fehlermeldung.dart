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
  // dynamische Überschrift
  String _ueberschrift = "Fehler in Raum ";
  // Zeugs fürs Beschreibungstextfeld
  TextEditingController _beschreibungController = TextEditingController();
  FocusNode _beschreibungNode = FocusNode();

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

  @override
  Widget build(BuildContext context) {
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context);

    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(_ueberschrift),
        actions: <Widget>[
          FlatButton(
            child: Row(
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
              setState(() {
                fehler.beschreibung = _beschreibungController.text;
                // fehler.melder = benutzerInfoProvider.benutzername;
              });
              fehlerlisteProvider.fehlerGemeldet(fehler: fehler);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              RaumnummerEingabe(
                updateText: updateText,
              ),
              TextField(
                controller: _beschreibungController,
                decoration: InputDecoration(
                  labelText: "Beschreibung",
                  hintText: "",
                ),
                focusNode: _beschreibungNode,
                keyboardType: TextInputType.text,
                maxLines: null,
                // textInputAction: TextInputAction.newline,
              ),
            ],
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
