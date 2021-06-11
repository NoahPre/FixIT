// gemeldeteFehler.dart
import '../../imports.dart';

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
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(
      context,
      listen: false,
    );
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    var appBar = AppBar(
      title: Text(
        "FixIT",
        style: thema.textTheme.headline1,
      ),
      backgroundColor: thema.colorScheme.primary,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () async {
            if (fehlerlisteProvider.fehlerliste != null) {
              fehlerlisteProvider.fehlerliste!.clear();
            }
            await fehlerlisteProvider.holeFehler();
            return null;
          },
          icon: Icon(Icons.refresh),
          tooltip: "Neu laden",
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );

    Future<void> erneutAuthentifizieren() async {
      await benutzerInfoProvider.authentifizierung();
      return;
    }

    Future<bool> _ueberpruefeInternetVerbindung(
        {required BuildContext currentContext}) async {
      try {
        final result = await InternetAddress.lookup("google.com");
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
        // probably unnecessary
        else {
          zeigeSnackBarNachricht(
            nachricht: "Nicht mit dem Internet verbunden",
            context: currentContext,
            istError: true,
          );

          return false;
        }
      } on SocketException catch (error) {
        print(error.toString());
        zeigeSnackBarNachricht(
          nachricht: "Nicht mit dem Internet verbunden",
          context: currentContext,
          istError: true,
        );
        return false;
      } catch (error) {
        zeigeSnackBarNachricht(
          nachricht: error.toString(),
          context: currentContext,
          istError: true,
        );
        return false;
      }
    }

    return StreamBuilder<bool>(
      stream: benutzerInfoProvider.authentifizierungStream as Stream<bool>?,
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
              child: snapshot.hasData && snapshot.data == true
                  // Liste mit gemeldeten Fehlern
                  ? Fehlerliste(
                      appBarHoehe: appBar.preferredSize.height,
                    )
                  // Ladedonut in der Mitte der Seite mit Option zum neuladen
                  : Builder(
                      builder: (BuildContext currentContext) =>
                          RefreshIndicator(
                        onRefresh: () async {
                          if (await _ueberpruefeInternetVerbindung(
                                currentContext: currentContext,
                              ) ==
                              true) {
                            erneutAuthentifizieren();
                          }
                        },
                        color: thema.colorScheme.primary,
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
                                    thema.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
