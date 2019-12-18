import "package:flutter/material.dart";

//unsere files
import "./Registrierungsvorlage.dart";


//der Button, der bewirkt, dass ein Bottom Sheet mit der Registrierungsvorlage auftaucht
//wird nur angezeigt, wenn der Benutzer nicht registriert wird
// class RegistrierungsButton extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _RegistrierungsButtonState();
//   }
// }

// class _RegistrierungsButtonState extends State<RegistrierungsButton> {
//   Widget build(BuildContext context) {
//     return RaisedButton(
//       child: Text("Jetzt Registrieren"),
//       onPressed: () {
//         print("RegistrierungsButton pressed");
//         showBottomSheet(
//           context: context,
//           builder: (context) => Registrierungsvorlage(),
//         );
//       },
//     );
//   }
// }

class RegistrierungsButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Jetzt Registrieren"),
      onPressed: () {
        print("RegistrierungsButton pressed");
        showBottomSheet(
          context: context,
          builder: (context) => Registrierungsvorlage(),
        );
      },
    );
  }
}
