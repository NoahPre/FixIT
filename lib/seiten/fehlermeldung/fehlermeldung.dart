// fehlermeldungVorlage.dart
import "../../imports.dart";
import "../../main.dart";
import "package:flutter/cupertino.dart";
import "package:intl/intl.dart";
import "package:image_picker/image_picker.dart";
import "package:keyboard_visibility/keyboard_visibility.dart";
import "package:path/path.dart" show join;
import "package:path_provider/path_provider.dart";
import "package:uuid/uuid.dart";

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

  /// Fehler, der auf dieser Seite gemeldet wird
  Fehler neuerFehler = Fehler(
    id: Uuid().v1().replaceAll("-", "_"),
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

  // Controller für die Kamera
  CameraController controller;
  String pfadZumBild = "";

  @override
  void initState() {
    super.initState();
    try {
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } catch (error) {
      print(error.toString());
    }
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // updatet die Überschrift und den Text des Dropdown Buttons
  void updateText({
    String textInTextfield,
  }) {
    setState(() {
      _ueberschrift = "Fehler in Raum " + textInTextfield;
      neuerFehler.raum = textInTextfield;
    });
  }

  // lässt den Benutzer ein Bild aufnehmen
  void bildAufnehmen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Kamera"),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.camera_alt),
              // Provide an onPressed callback.
              onPressed: () async {
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Construct the path where the image should be saved using the path
                  // package.
                  final path = join(
                    // Store the picture in the temp directory.
                    // Find the temp directory using the `path_provider` plugin.
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png',
                  );

                  // Attempt to take a picture and log where it's been saved.
                  await controller.takePicture(path);

                  Navigator.pop(context);

                  setState(() {
                    pfadZumBild = path;
                  });
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // lässt den Benutzer das Bild auswählen
  void chooseImage() {
    setState(() {
      //TODO: das hier auf ImagePicker.getImage() updaten
      file = ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
      status = "Bild ausgewählt";
    });
  }

  // zeigt das aufgenommene Bild
  Widget zeigeAufgenommenesBild() {
    return Image.file(File(pfadZumBild));
  }

  // zeigt das gewählte Bild
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

  // zeigt je nach Betriebssystem einen Auswahldialog
  Future<void> zeigeBilderAuswahl({BuildContext currentContext}) async {
    showModalBottomSheet(
      isDismissible: false,
      context: currentContext,
      builder: (BuildContext context) => BottomSheet(
        onClosing: () {},
        builder: (BuildContext context) {
          return Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 100.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        bildAufnehmen();
                      },
                    ),
                  ),
                ),
                Container(
                  height: 100.0,
                  width: 2.0,
                  color: Colors.black,
                ),
                Expanded(
                  child: Container(
                    height: 100.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.collections,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        chooseImage();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);

    var appBar = AppBar(
      title: Text(
        _ueberschrift,
        style: thema.textTheme.headline1,
      ),
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
          if (_formKey.currentState.validate() == false) {
            return;
          }
          setState(() {
            neuerFehler.beschreibung = _beschreibungController.text;
            // fehler.melder = benutzerInfoProvider.benutzername;
          });
          if (status == "") {
            if (pfadZumBild == "") {
              fehlerlisteProvider.fehlerGemeldet(
                fehler: neuerFehler,
              );
            } else {
              fehlerlisteProvider.fehlerGemeldet(
                fehler: neuerFehler,
                image: File(pfadZumBild),
              );
            }
          } else {
            fehlerlisteProvider.fehlerGemeldet(
                fehler: neuerFehler, image: tmpFile);
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
                        width: mediaQuery.size.width * 0.04,
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
                  Builder(
                    builder: (BuildContext currentContext) => RaisedButton(
                      child: Text("Bild hinzufügen"),
                      onPressed: () async {
                        await zeigeBilderAuswahl(
                            currentContext: currentContext);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  pfadZumBild == "" ? showImage() : zeigeAufgenommenesBild(),
                ],
              ),
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
