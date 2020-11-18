// gemeldeteFehler.dart
import "../../imports.dart";

class GemeldeteFehler extends StatefulWidget {
  @override
  _GemeldeteFehlerState createState() => _GemeldeteFehlerState();
}

class _GemeldeteFehlerState extends State<GemeldeteFehler> {
  Future<void> refresh() async {}

  @override
  Widget build(BuildContext context) {
    print("building GemeldeteFehler");
    ThemeData thema = Theme.of(context);

    var appBar = AppBar(
      title: Text(
        "FixIt",
        style: thema.textTheme.headline1,
      ),
    );
    return Scaffold(
      appBar: appBar,
      // Seitenmenü
      drawer: Seitenmenue(
        aktuelleSeite: "/gemeldeteFehler",
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),

          // Liste mit gemeldeten Fehlern
          child: Fehlerliste(
            appBarHoehe: appBar.preferredSize.height,
          ),
        ),
      ),
      floatingActionButton: FABHome(),
    );
  }
}
