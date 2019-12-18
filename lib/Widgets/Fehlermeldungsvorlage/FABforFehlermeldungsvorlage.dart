import "package:flutter/material.dart";

import "./Fehlermeldungsvorlage.dart";


//dieser Floating Action Button bewirkt, dass ein Bottom Sheet mit der Fehlermeldungsvorlage angezeigt wird
//dieses BottomSheet beinhaltet dann die Fehlermeldungsvorlage
class FABforFehlermeldungsvorlage extends StatefulWidget {
  @override
  _FABforFehlermeldungsvorlageState createState() => _FABforFehlermeldungsvorlageState();
}

//muss stateful sein, da man den Wert von showingFloatingActionButton immer updaten müssen
//wenn das BottomSheet auftaucht, muss der FAB ausgeblendet werden
//wenn das BottomSheet verschwindet, muss der FAB wieder auftauchen
class _FABforFehlermeldungsvorlageState extends State<FABforFehlermeldungsvorlage> {
  
  //true: FAB ist zu sehen; false: FAB ist nicht zu sehen
  bool showingFloatingActionButton = true;


  @override
  Widget build(BuildContext context) {

    //kontrolliert, ob showingFloatingActionButton wahr ist
    return showingFloatingActionButton
        ? FloatingActionButton(
            onPressed: () {
              var bottomSheetController = showBottomSheet(
                  context: context,
                  builder: (context) => Fehlermeldungsvorlage()
              );
              //setzt showingFloatingActionButton auf false, da der FAB nicht mehr zu sehen ist
              setShowingFloatingActionButton(toValue: false);
              //showBottomSheet erzeugt einen PersistentBottomSheetController
              //wir "abonnieren" diesen und merken somit, wann das BottomSheet wieder geschlossen wird
              //.closed ist vom Typ Future, deswegen wird .then erst in der Zukunft ausgeführt
              //bin mir hierbei noch nicht sicher!!!
              bottomSheetController.closed.then((value) {
                setShowingFloatingActionButton(toValue: true);
              });
            },
            child: Icon(Icons.add),
          )
        : Container();
  }

  //updatet den Wert 
  void setShowingFloatingActionButton({bool toValue}) {
    setState(() {
      showingFloatingActionButton = toValue;
    });
  }
}