// FABHome.dart
import '../../imports.dart';

/// FloatingActionButton für GemeldeteFehler
class FABHome extends StatelessWidget {
  const FABHome({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    return FloatingActionButton(
      heroTag: "FloatingActionButton",
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
      child: Icon(
        Icons.add,
        color: thema.colorScheme.onSecondary,
      ),
    );
  }
}
