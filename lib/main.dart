import "package:flutter/material.dart";

import "./Widgets/Fehlermeldungsvorlage/Fehlermeldungsvorlage.dart";
import "./Widgets/Fehlermeldungsvorlage/FABforFehlermeldungsvorlage.dart";

void main() => runApp(FixIt());

//das hier ist ein StatelessWidget, da dies nie neu gerendert werden muss
class FixIt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("built");
    return MaterialApp(
      home: FixItHomePage(),
      //!!!funktioniert irgendwie bei mir nicht; Error: Color not a subtype of MaterialColor!!!
      // das Theme ist eine Klasse, auf die man im ganzen Projekt zugreifen kann
      // hier kann man z.B. einen Standard für alle Titel oder Buttons festlegen
      // man erreicht den hier vorgegebenen Stil mit Theme.of(context).?
      // theme: ThemeData(
      //   primarySwatch: Colors.black,
      //   accentColor: Colors.red,
      //   textTheme: TextTheme(
      //       title: TextStyle(
      //         fontWeight: FontWeight.bold,
      //       ),
      //       button: TextStyle(
      //         color: Theme.of(context).accentColor,
      //       )),
      // ),
    );
  }
}

//muss stateful sein, da wir Content updaten (da wir ein BottomSheet benutzen)
class FixItHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FixItHomePageState();
  }
}


class _FixItHomePageState extends State<FixItHomePage> {
  //wahrscheinlich überflüssig
  // //lässt ein Eingabefeld über der Tastatur erscheinen;
  // //wird ausgeführt, wenn der Floating Action Button gedrückt wird
  // void _neueFehlermeldung(BuildContext ctx) {
  //   showBottomSheet(
  //       context: ctx,
  //       builder: (_) {
  //         return GestureDetector(
  //           child: Fehlermeldungsvorlage(),
  //           behavior: HitTestBehavior.opaque,
  //           onTap: () {},
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FixIt",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      //der FloatingActionButton (kurz: FAB) wird in einem anderen File definiert
      floatingActionButton: FABforFehlermeldungsvorlage(),
      //hier soll später eine Liste mit den Meldungen des Users hin
      body: Center(
        child: Text("Fix It"),
      ),
    );
  }
}


