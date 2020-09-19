// FABHome.dart
// 1
import "../../imports.dart";

class FABHome extends StatelessWidget {
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
              return Fehlermeldung();
            },
          ),
        );
      },
    );
  }
}
