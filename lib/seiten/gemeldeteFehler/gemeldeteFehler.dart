// gemeldeteFehler.dart
import "../../imports.dart";

/// Startseite der App
class GemeldeteFehler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(
      context,
      listen: false,
    );
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    var appBar = AppBar(
      title: Text(
        "FixIT",
        style: thema.textTheme.headline1,
      ),
    );

    Future<void> erneutAuthentifizieren() async {
      await benutzerInfoProvider.authentifizierung();
      return;
    }

    return StreamBuilder<bool>(
      stream: benutzerInfoProvider.authentifizierungStream,
      initialData: benutzerInfoProvider.istAuthentifiziert,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == false) {
          return Registrierung();
        }
        return Scaffold(
          appBar: appBar,
          drawer: const Seitenmenue(
            aktuelleSeite: "/",
          ),
          floatingActionButton: FABHome(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: snapshot.hasData
                  // Liste mit gemeldeten Fehlern
                  ? Fehlerliste(
                      appBarHoehe: appBar.preferredSize.height,
                    )
                  // Ladedonut in der Mitte der Seite mit Option zum neuladen
                  : RefreshIndicator(
                      onRefresh: () => erneutAuthentifizieren(),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            height: mediaQueryData.size.height -
                                appBar.preferredSize.height -
                                mediaQueryData.padding.top -
                                mediaQueryData.padding.bottom,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
