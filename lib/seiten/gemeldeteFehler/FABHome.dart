// FABHome.dart
import "../../imports.dart";

/// FloatingActionButton für GemeldeteFehler
class FABHome extends StatelessWidget {
  const FABHome();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "FloatingActionButton",
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
              return Fehlermeldung();
            },
          ),
        );
      },
    );
  }
}
