import "package:flutter/material.dart";
import "package:flutter/services.dart";

//muss stateful sein, da wir weiter unten Textfelder haben
class Fehlermeldungsvorlage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FehlermeldungsvorlageState();
  }
}

class _FehlermeldungsvorlageState extends State<Fehlermeldungsvorlage> {
  //Controller für das Textfeld, in das man die Raumnummer eingibt
  //der TextEditingController speichert den getippten Text als String
  final _raumController = TextEditingController();

  final _fehlerBeschreibungController = TextEditingController();

  String _ueberschrift = "Fehler in Raum";

  //Funktion, die den Text unter dem Textfeld updated
  void _updateText(String textInTextfield) {
    setState(() {
      _ueberschrift = "Fehler in Raum " + textInTextfield;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(0),
            //stehengeblieben 4.12. beim Versuch die SingleChildScrollView bei der Eingabe mit der Tastatur übers ganze Display anzeigen zu lassen
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
                //Eingabefeld, in das man die Raumnummer eingibt
                Container(
                  child: TextField(
                    //der TextEditingController speichert den getippten Text als String
                    controller: _raumController,
                    //macht die Tastatur zum Zahlenfeld
                    keyboardType: TextInputType.text,
                    //zeigt den Text "Raum" als Platzhalter an
                    decoration: InputDecoration(labelText: "Raum"),
                    //die Methode, die ausgeführt wird, wenn die Eingabe beendet wurde
                    onSubmitted: (_) => _updateText(_raumController.text),
                  ),
                ),
                Container(
                  child: TextField(
                    //der TextEditingController speichert den getippten Text als String
                    controller: _fehlerBeschreibungController,
                    //zeigt den Text "Fehlerbeschreibung" als Platzhalter an
                    decoration:
                        InputDecoration(labelText: "Fehlerbeschreibung"),
                  ),
                ),
              ],
            ),
          ),

      ),
    );
  }
}
