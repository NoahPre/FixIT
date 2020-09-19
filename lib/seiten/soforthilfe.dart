// soforthilfe.dart
// 1
import "../imports.dart";

class Soforthilfe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Soforthilfe",
          style: thema.textTheme.headline1,
        ),
      ),
      drawer: Seitenmenue(
        aktuelleSeite: "/soforthilfe",
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              "Noch keine Soforthilfe verfügbar",
              style: thema.textTheme.bodyText1,
            ),
          ),
        ),
      ),
    );
  }
}
