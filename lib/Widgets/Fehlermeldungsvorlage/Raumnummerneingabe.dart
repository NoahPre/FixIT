import "package:flutter/material.dart";

//Widget aus Performancegründen ausgelagert
class Raumnummerneingabe extends StatefulWidget {

  final updateText;

  Raumnummerneingabe(this.updateText);

  @override
  State<StatefulWidget> createState() {
    return _RaumnummerneingabeState();
  }
}

class _RaumnummerneingabeState extends State<Raumnummerneingabe> {

  //Controller für das Textfeld, in das man die Raumnummer eingibt
  final _raumController = TextEditingController();

  //speichert den Text der Überschrift
  String _ueberschrift = "Fehler in Raum";

  //speichert den Text des Dropdown Buttons
  String _dropdownButtonText = "";


@override
  Widget build(BuildContext context) {


    var deviceWidth = MediaQuery.of(context).size.width;

    return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //Dropdown Button:
                  Container(
                    child: DropdownButton<String>(
                      icon: Row(
                        children: [
                          Text(_dropdownButtonText),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      items: <String>[
                        "",
                        "K ",
                        "N ",
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        widget.updateText(
                          textInTextfield: _raumController.text,
                          textInDropDownButton: value,
                        );
                      },
                    ),
                  ),
                  Container(
                    width: deviceWidth * 0.04,
                  ),
                  Container(
                    //braucht eine feste Breite!
                    //besser wäre etwas wie: width: deviceSize.fit
                    //
                    width: deviceWidth * 0.3,
                    child: TextField(
                      //der TextEditingController speichert den getippten Text als String
                      controller: _raumController,
                      //macht die Tastatur zum Zahlenfeld
                      keyboardType: TextInputType.number,
                      //zeigt den Text "Raum" als Platzhalter an
                      decoration: InputDecoration(labelText: "Raum"),
                      //die Methode, die ausgeführt wird, wenn die Eingabe beendet wurde
                      onChanged: (_) => widget.updateText(
                        textInTextfield: _raumController.text,
                        textInDropDownButton: _dropdownButtonText,
                      ),
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ],
              );
  }

}