import "package:flutter/material.dart";
//für die iOS Widgets
import "package:flutter/cupertino.dart";

//der "Fertig" Knopf, den man in Fehlermeldungsvorlage über jedem Keyboard auftauchen lässt
//schließt das Keyboard
class FertigButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Fertig Button erstellt");
    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: CupertinoButton(
            padding: EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
            onPressed: () {
              //Martin: die Zeile habe ich noch nicht verstanden
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Text("Fertig",
                style: TextStyle(
                    color: Theme.of(context).textTheme.title.color,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
