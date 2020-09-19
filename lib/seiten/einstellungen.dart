// einstellungen.dart
import "../imports.dart";

class Einstellungen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context);

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
          ListTile(
            title: Text("Abmelden"),
            trailing: Icon(Icons.exit_to_app),
            onTap: () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.setBool(
                "istRegistriert",
                false,
              );
              benutzerInfoProvider.istBenuterRegistriertSink.add(false);
            },
          ),
        ],
      ),
    );
  }
}
