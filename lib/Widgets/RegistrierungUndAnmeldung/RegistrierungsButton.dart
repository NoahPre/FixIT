import "package:flutter/material.dart";

//unsere files
import "./Registrierungsvorlage.dart";


//der Button, der bewirkt, dass ein Bottom Sheet mit der Registrierungsvorlage auftaucht
//wird nur angezeigt, wenn der Benutzer nicht registriert wird
class RegistrierungsButton extends StatelessWidget {

  final masterpasswort;

  RegistrierungsButton({this.masterpasswort});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Jetzt Registrieren"),
      color: Theme.of(context).buttonColor,
      textTheme: Theme.of(context).buttonTheme.textTheme,
      onPressed: () {
        print("RegistrierungsButton pressed");
        showBottomSheet(
          context: context,
          builder: (context) => Registrierungsvorlage(masterpasswort: masterpasswort,),
        );
      },
    );
  }
}
