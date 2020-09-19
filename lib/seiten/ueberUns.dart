// ueberUns.dart
import "../imports.dart";

class UeberUns extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Über uns",
          style: thema.textTheme.headline1,
        ),
      ),
      drawer: Seitenmenue(
        aktuelleSeite: "/ueberUns",
      ),
      body: Center(
        child: Text(
          "entwickelt von Noah und Martin",
          style: thema.textTheme.bodyText1,
        ),
      ),
    );
  }
}
