// gemeldeteFehler.dart
import "../../imports.dart";

class GemeldeteFehler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    var appBar = AppBar(
      title: Text(
        "FixIt",
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
          // Seitenmenü
          drawer: Seitenmenue(
            aktuelleSeite: "/",
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),

              // Liste mit gemeldeten Fehlern
              child: snapshot.hasData
                  ? Fehlerliste(
                      appBarHoehe: appBar.preferredSize.height,
                    )
                  : RefreshIndicator(
                      onRefresh: () => erneutAuthentifizieren(),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            height: mediaQueryData.size.height -
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
          floatingActionButton: FABHome(),
        );
      },
    );
  }
}
