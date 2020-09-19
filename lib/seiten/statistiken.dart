// statistiken.dart
import "../imports.dart";

class Statistiken extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Statistiken",
          style: thema.textTheme.headline1,
        ),
      ),
      drawer: Seitenmenue(
        aktuelleSeite: "/statistiken",
      ),
      body: Center(
        child: Text(
          "Noch keine Statistiken verfügbar",
          style: thema.textTheme.bodyText1,
        ),
      ),
    );
  }
}
