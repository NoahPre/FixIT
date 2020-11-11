// fehlermeldungVorlage.dart
import "../../imports.dart";
import "package:intl/intl.dart";
import "package:image_picker/image_picker.dart";
import "package:http/http.dart" as http;

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

  // Variablen fürs Uploaden der Bilder via php
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  @override
  void initState() {
    super.initState();

    // TODO: muss man diesen Listener hier entfernen?
/*    //sorgt dafür, dass man weiß, wann die Tastatur zu sehen ist
    KeyboardVisibilityNotification().addNewListener(
      onShow: () {
        zeigeFertigButton(context);
      },
      onHide: () {
        entferneFertigButton();
      },
    );
    */
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

  // lässt den Benutzer das Bild auswählen
  void chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery, );
      
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
         
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  // Validatoren:
  String _uerberpruefeRaumnummer(String raumnummer) {
    if (raumnummer.isEmpty || raumnummer == "") {
      return "Bitte eine Raumnummer eingeben";
    } else if (raumnummer.length > 3 || int.parse(raumnummer) > 420) {
      return "Bitte eine gültige Raumnummer eingeben";
    } else {
      return null;
    }
  }

  String _ueberpruefeBeschreibung(String beschreibung) {
    if (beschreibung.isEmpty || beschreibung == "") {
      return "Bitte eine Beschreibung eingeben";
    } else {
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
          fehlerlisteProvider.fehlerGemeldet(fehler: fehler, image: tmpFile);
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
                        validator: (String raumnummer) =>
                            _uerberpruefeRaumnummer(raumnummer),
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
                  validator: (String beschreibung) =>
                      _ueberpruefeBeschreibung(beschreibung),
                ),
                SizedBox(height: 10),
                RaisedButton(
                  child: Text("Bild hochladen"),
                  onPressed: () => chooseImage(),
                ),
                const SizedBox(height: 10),
                showImage(),
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
