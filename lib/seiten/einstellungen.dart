// einstellungen.dart
import "../imports.dart";

class Einstellungen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Einstellungen",
          style: thema.textTheme.headline1,
        ),
      ),
      drawer: Seitenmenue(
        aktuelleSeite: "/einstellungen",
      ),
      body: ListView(
        children: [
          Center(
            child: Text("Einstellungen"),
          ),
        ],
      ),
    );
  }
}
