import "package:flutter/material.dart";

//unsere files
import "./Anmeldungsvorlage.dart";


//der Button, der bewirkt, dass ein Bottom Sheet mit der Anmeldungsvorlage auftaucht
//wird nur angezeigt, wenn der Benutzer auf "Jezt anmelden" klickt
class AnmeldungsButton extends StatelessWidget {

  final masterpasswort;

  AnmeldungsButton({this.masterpasswort});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Jetzt Anmelden"),
      color: Theme.of(context).buttonColor,
      textTheme: Theme.of(context).buttonTheme.textTheme,
      onPressed: () {
        print("AnmeldungsButton pressed");
        showBottomSheet(
          context: context,
          builder: (context) => Anmeldungsvorlage(masterpasswort: masterpasswort,),
        );
      },
    );
  }
}
