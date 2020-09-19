// tutorial.dart
import "../imports.dart";

class Tutorial extends StatelessWidget {

  Tutorial({this.istFehlermelder = false});

  final bool istFehlermelder;

  @override
  Widget build(BuildContext context) {
        ThemeData thema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Wie funktioniert's", style: thema.textTheme.headline1,),
      ),
      drawer: Seitenmenue(aktuelleSeite: "/tutorial",),
      body: Column(
        children: <Widget>[
          Image(
            image: AssetImage("assets/MeldeAblauf.jpg"),
          ),
          istFehlermelder
          ? Text("Hier wird dann später die Hilfe für die Fehlermelder angezeigt", style: thema.textTheme.bodyText1,)
          : Text("Hier wird dann später die Hilfe für die Fehlerbeheber angezeigt", style: thema.textTheme.bodyText1,)
        ],
      ),
    );
  }
}
