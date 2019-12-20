//flutter packages
import "package:flutter/material.dart";
import "package:flutter/services.dart";
//3rd party packages
import 'package:keyboard_visibility/keyboard_visibility.dart';

//unsere Widgets
import "../Allgemein/FertigButton.dart";

//muss stateful sein, da wir weiter unten Textfelder haben
class Fehlermeldungsvorlage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FehlermeldungsvorlageState();
  }
}


class _FehlermeldungsvorlageState extends State<Fehlermeldungsvorlage> {
  //der TextEditingController speichert den getippten Text als String
  //Controller für das Textfeld, in das man die Raumnummer eingibt
  //final _raumController = TextEditingController();

  final _fehlerartController = TextEditingController();

  final _fehlerBeschreibungController = TextEditingController();

  //speichert den Text der Überschrift
  String _ueberschrift = "Fehler in Raum";

  //overlayEntry property für die "Fertig" Button Widget Logik
  OverlayEntry overlayEntry;

  //Funktion, die den Text unter dem Textfeld updated
 /* void _updateText(String textInTextfield) {
    setState(() {
      _ueberschrift = "Fehler in Raum     " + textInTextfield;
    });
  }*/

  //helfen, den "Fertig" Button über dem Zahlenfeld anzuzeigen
  void showOverlay(BuildContext context) {
    print("showOverlay executed");
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

  void removeOverlay() {
    print("removeOverlay executed");
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onShow: () {
        print("onShow");
        showOverlay(context);
      },
      onHide: () {
        print("onHide");
        removeOverlay();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //die Größe des Gerätes als double
    var deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      //bewirkt, dass das gesamte Scaffold auf dem Screen zu sehen ist
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(0),
          child: Padding(
            child: Column(
              children: [
                //Textfeld mit dem Text "Raum"

                Container(
                  child: Text(
                    _ueberschrift,
                    style: Theme.of(context).textTheme.title,
                  ),
                  height: MediaQuery.of(context).size.height / 10,
                ),
           /* TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Raum:',
              ),
            ),*/
          new DropdownButton<String>(
            items: <String>['K21', '110', '120', '120','130','K21', '110', '120', '120','130','K21', '110', '120', '120','130','K21', '110', '120', '120','130','K21', '110', '120', '120','130'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
                //Eingabefeld, in das man die Raumnummer eingibt
               /* Container(
                  child: TextField(
                    //der TextEditingController speichert den getippten Text als String
                    controller: _raumController,
                    //macht die Tastatur zum Zahlenfeld
                    keyboardType: TextInputType.number,
                    //zeigt den Text "Raum" als Platzhalter an
                    decoration: InputDecoration(labelText: "Raum"),
                    //die Methode, die ausgeführt wird, wenn die Eingabe beendet wurde
                    onSubmitted: (_) => _updateText(_raumController.text),
                  ),
                ), */

                //Container, der die Textfelder voneinander trennt
                Container(
                  height: deviceHeight * 0.02,
                ),

                //Eingabefeld, in das man die Fehlerart eingibt
                //wird evtl. noch zu Picker oder Dropdown Menü
                Container(
                  child: TextField(
                    //der TextEditingController speichert den getippten Text als String
                    controller: _fehlerartController,
                    //zeigt den Text "Fehlerbeschreibung" als Platzhalter an
                    decoration: InputDecoration(
                      labelText: "Fehlerart",
                      //wenn man einen Rand um das Textfeld haben will ...
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.all(
                      //     Radius.circular(4.0),
                      //   ),
                      // ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),

                //Container, der die Textfelder voneinander trennt
                Container(
                  height: deviceHeight * 0.02,
                ),

                //Eingabefeld, in das man die Fehlerbeschreibung eingibt
                Container(
                  child: TextField(
                    //der TextEditingController speichert den getippten Text als String
                    controller: _fehlerBeschreibungController,
                    //zeigt den Text "Fehlerbeschreibung" als Platzhalter an
                    decoration: InputDecoration(
                      labelText: "Fehlerbeschreibung",
                      //wenn man einen Rand um das Textfeld haben will ...
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.all(
                      //     Radius.circular(4.0),
                      //   ),
                      // ),
                    ),
                    keyboardType: TextInputType.multiline,
                    //setzt die maximale Anzahl an Zeilen auf 10
                    maxLines: 10,
                    //setzt die minimale Anzahl an Zeilen auf 1
                    minLines: 1,
                  ),
                ),

              ],

            ),
            padding: EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
