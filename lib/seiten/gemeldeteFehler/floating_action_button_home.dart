// FABHome.dart
import '../../imports.dart';

/// FloatingActionButton für GemeldeteFehler
class FABHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    return FloatingActionButton(
      heroTag: "FloatingActionButton",
      child: Icon(
        Icons.add,
        color: thema.colorScheme.onSecondary,
      ),
      backgroundColor: thema.colorScheme.primary,
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
