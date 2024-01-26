// fertigButton.dart
import '../imports.dart';
import "package:flutter/cupertino.dart";

//Tutorial gefunden unter: https://blog.usejournal.com/keyboard-done-button-ux-in-flutter-ios-app-3b29ad46bacc
//der "Fertig" Knopf, den man in fehlermeldungVorlage über jeder Tastatur auftauchen lässt
//schließt die Tastatur
class FertigButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
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
              //die Zeile habe ich noch nicht verstanden
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Text(
              "Fertig",
              style: thema.textTheme.displaySmall,
            ),
          ),
        ),
      ),
    );
  }
}
