// fehlermeldungVorlage.dart
import "dart:typed_data";
import "../../imports.dart";
import "../../main.dart";
import "package:flutter/cupertino.dart";
import "package:intl/intl.dart";
import "package:image_picker/image_picker.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";

import "package:uuid/uuid.dart";

// Seite, auf der der Benutzer seine Fehlermeldung abschicken kann
class Fehlermeldung extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FehlermeldungState();
  }
}

class _FehlermeldungState extends State<Fehlermeldung> {
  /// Variablen für das Error Handling
  bool errorVorhanden = false;
  String errorNachricht = "";

  /// GlobalKey für das Form Widget
  final _formKey = GlobalKey<FormState>();

  /// dynamische Überschrift, die sich nach jeder Eingabe aktualisiert
  String _ueberschrift = "Fehler in Raum ";

  /// Variablen für das Beschreibungstextfeld
  final TextEditingController _beschreibungController = TextEditingController();
  final FocusNode _beschreibungNode = FocusNode();

  /// Variablen für die Raumnummerneingabe
  final TextEditingController _raumController = TextEditingController();
  final FocusNode _raumNode = FocusNode();
  String? _dropdownButtonText = "";

  /// Fehler, der auf dieser Seite gemeldet wird
  Fehler neuerFehler = Fehler(
    id: Uuid().v1().replaceAll("-", "_"),
    datum: DateFormat("yyyyMMdd").format(DateTime.now()).toString(),
    //das muss man noch updaten
    gefixt: "0",
  );

  /// Variablen für das Hochladen des aufgenommenen / ausgewählten Bildes via php
  Future<PickedFile?>? ausgewaehltesBild;
  String status = '';
  String? base64Bild;
  PickedFile? temporaeresBild;
  String bildErrorNachricht = 'Error Uploading Image';

  // Controller für die Kamera
  CameraController? kameraController;
  String _pfadZumBild = "";
  void setzePfadZumBild(String pfad) {
    setState(() {
      _pfadZumBild = pfad;
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      kameraController = CameraController(cameras[0], ResolutionPreset.high);
      kameraController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } catch (error) {
      print(error.toString());
      errorVorhanden = true;
      errorNachricht = error.toString();
    }
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool isVisible) {
      if (isVisible) {
        zeigeFertigButton();
      } else {
        entferneFertigButton();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    kameraController?.dispose();
  }

  /// updatet die Überschrift und den Text des Dropdown Buttons
  void updateText({
    String? textInTextfield,
  }) {
    setState(() {
      _ueberschrift = "Fehler in Raum " + textInTextfield!;
      neuerFehler.raum = textInTextfield;
    });
  }

  /// zeigt das aufgenommene Bild
  Widget zeigeAufgenommenesBild() {
    return Image.file(
      File(_pfadZumBild),
    );
  }

  void setzeBildWerte({
    required PickedFile temporaeresBild,
    required String base64Bild,
  }) {
    // TODO: warum muss man hier kein setState() benutzen?
    this.temporaeresBild = temporaeresBild;
    this.base64Bild = base64Bild;
  }

  /// lässt den Benutzer das Bild aus der Gallerie des Geräts auswählen
  void bildAusGallerieAuswaehlen() {
    setState(() {
      //TODO: das hier auf ImagePicker.getImage() updaten
      ausgewaehltesBild = ImagePicker().getImage(
        source: ImageSource.gallery,
      );
      status = "Bild ausgewählt";
    });
  }

  // für die Logik vom Fertig Button über der Tastatur:
  /// overlayEntry property für die Fertig Button Widget Logik
  OverlayEntry? overlayEntry;

  /// zeigt den Fertig Button über dem Zahlenfeld an (iOS bietet hier keinen Button, der die Eingabe beendet, Android schon)
  void zeigeFertigButton() {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context)!;
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: FertigButton());
    });

    overlayState.insert(overlayEntry!);
  }

  /// entfernt den Fertig Button über dem Zahlenfeld
  void entferneFertigButton() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  // Validatoren:
  /// Validator für die Raumnummer des Fehlers
  String? _uerberpruefeRaumnummer(String raumnummer) {
    if (raumnummer.isEmpty || raumnummer == "") {
      return "Bitte eine Raumnummer eingeben";
    } else if (raumnummer.length > 3 || int.parse(raumnummer) > 420) {
      return "Bitte eine gültige Raumnummer eingeben";
    } else {
      return null;
    }
  }

  /// Validator für die Beschreibung des Fehlers
  String? _ueberpruefeBeschreibung(String beschreibung) {
    if (beschreibung.isEmpty || beschreibung == "") {
      return "Bitte eine Beschreibung eingeben";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    MediaQueryData mediaQuery = MediaQuery.of(context);
    // listen ist false, da dieses Widget hier nicht auf Werte aus dem Provider zugreift, sondern nur dessen Funktionen aufruft
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(
      context,
      listen: false,
    );

    var appBar = AppBar(
      title: Text(
        _ueberschrift,
        style: thema.textTheme.headline1,
      ),
      backgroundColor: thema.colorScheme.primary,
    );
    return Scaffold(
      appBar: appBar,
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
            SizedBox(width: mediaQuery.size.width * 0.01),
            Icon(
              Icons.send,
              color: Colors.white,
            ),
          ],
        ),
        onPressed: () {
          if (_formKey.currentState!.validate() == false) {
            return;
          }
          setState(() {
            neuerFehler.beschreibung = _beschreibungController.text;
          });
          if (status == "") {
            if (_pfadZumBild == "") {
              fehlerlisteProvider.fehlerGemeldet(
                fehler: neuerFehler,
              );
            } else {
              fehlerlisteProvider.fehlerGemeldet(
                fehler: neuerFehler,
                image: File(_pfadZumBild),
              );
            }
          } else {
            fehlerlisteProvider.fehlerGemeldet(
                fehler: neuerFehler, pickedImage: temporaeresBild);
          }
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Container(
          //TODO: dieses Problem hier kann glaube ich noch eleganter gelöst werden
          height: mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top -
              mediaQuery.padding.bottom,
          child: SingleChildScrollView(
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
                            "T",
                          ].map((value) {
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            updateText(
                              textInTextfield: value! + _raumController.text,
                            );
                            setState(() {
                              _dropdownButtonText = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: mediaQuery.size.width * 0.04,
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: _raumController,
                          decoration: InputDecoration(
                            labelText: "Raumnummer",
                            labelStyle: TextStyle(
                              color: thema.colorScheme.primary,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: thema.colorScheme.primary),
                            ),
                          ),
                          focusNode: _raumNode,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          onChanged: (_) => updateText(
                            textInTextfield:
                                _dropdownButtonText! + _raumController.text,
                          ),
                          validator: (String? raumnummer) =>
                              _uerberpruefeRaumnummer(raumnummer!),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _beschreibungController,
                    decoration: InputDecoration(
                      labelText: "Beschreibung",
                      labelStyle: TextStyle(
                        color: thema.colorScheme.primary,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: thema.colorScheme.primary),
                      ),
                    ),
                    focusNode: _beschreibungNode,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    validator: (String? beschreibung) =>
                        _ueberpruefeBeschreibung(beschreibung!),
                  ),
                  SizedBox(height: 10),
                  Builder(
                    builder: (BuildContext currentContext) => ElevatedButton(
                      child: Text("Bild hinzufügen"),
                      onPressed: () async {
                        await zeigeBilderAuswahl(
                          currentContext: currentContext,
                          pfadZumBild: (String pfad) => setzePfadZumBild(pfad),
                          controller: kameraController,
                          bildAusGallerieAuswaehlen: bildAusGallerieAuswaehlen,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  _pfadZumBild == ""
                      ? zeigeAusgewaehltesBild(
                          ausgewaehltesBild: ausgewaehltesBild,
                          setzeBildWerte: setzeBildWerte,
                        )
                      : zeigeAufgenommenesBild(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
