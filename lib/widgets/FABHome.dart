// FABHome.dart
// 1
import "package:flutter/material.dart";
// 2
import "../seiten/fehlermeldung.dart";

class FABHome extends StatelessWidget {
  FABHome({this.fehlerGemeldet});

  final fehlerGemeldet;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
      ),
      tooltip: "Fehler melden",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Fehlermeldung(
                fehlerGemeldet: fehlerGemeldet,
              );
            },
          ),
        );
      },
    );
  }
}
