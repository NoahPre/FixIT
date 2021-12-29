// gemeldeteFehler.dart
import '../../imports.dart';

/// Startseite der App
class GemeldeteFehler extends StatefulWidget {
  @override
  State<GemeldeteFehler> createState() => _GemeldeteFehlerState();
}

class _GemeldeteFehlerState extends State<GemeldeteFehler> {
  Sortierung _popupMenuButtonValue = Sortierung.datum_absteigend;

  List<List> sortierungsmoeglichkeiten = [
    [Sortierung.datum_absteigend, "Datum Absteigend"],
    [Sortierung.datum_aufsteigend, "Datum Aufsteigend"],
    [Sortierung.nicht_gefixt, "Nicht Gefixt"],
    // [Sortierung.raume_aufsteigend, "Räume"],
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    final bool? istAuthentifiziert = Provider.of<bool?>(context);
    final String schule = Provider.of<String>(context);
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context);
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
        PopupMenuButton<Sortierung>(
          tooltip: "Filter",
          icon: Icon(Icons.sort),
          color: thema.colorScheme.background,
          itemBuilder: (context) =>
              sortierungsmoeglichkeiten.map((List eintrag) {
            return PopupMenuItem<Sortierung>(
                value: eintrag[0],
                // padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: Row(
                  children: [
                    Text(
                      eintrag[1],
                      style: TextStyle(
                        fontSize: 14.0,
                        // fontWeight: ,
                        color: thema.colorScheme.primary,
                      ),
                    ),
                    _popupMenuButtonValue == eintrag[0]
                        ? Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.check,
                                color: thema.colorScheme.primary,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ));
          }).toList(),
          onSelected: (Sortierung value) {
            fehlerlisteProvider.sortierung = value;
            setState(() {
              _popupMenuButtonValue = value;
            });
          },
        ),
        Builder(builder: (currentContext) {
          return IconButton(
            onPressed: () async {
              if (await ueberpruefeInternetVerbindung(
                      currentContext: currentContext) ==
                  false) {
                return;
              }
              fehlerlisteProvider.fehlerliste.clear();
              await fehlerlisteProvider.holeFehler();
              return null;
            },
            icon: Icon(Icons.refresh),
            tooltip: "Neu laden",
          );
        }),
      ],
    );

    Future<void> erneutAuthentifizieren() async {
      await benutzerInfoProvider.authentifizierung();
      return;
    }

    // benutzerInfoProvider.authentifizierung();

    if (istAuthentifiziert == false) {
      fehlerlisteProvider.fehlerliste = [];
      return Anmeldung();
    }

    if (schule != "") {
      fehlerlisteProvider.schule = schule;
      fehlerlisteProvider.holeFehler();
    }

    return Scaffold(
      appBar: appBar,
      drawer: const Seitenmenue(
        aktuelleSeite: "/",
      ),
      floatingActionButton: FABHome(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Builder(builder: (currentContext) {
        // überprüft, ob die laufende Version der App noch von Serverseite aus unterstützt wird
        WidgetsBinding.instance?.addPostFrameCallback((_) async {
          if (await benutzerInfoProvider.istUnterstuetzteVersion() == "false") {
            await showDialog(
              barrierDismissible: false,
              context: currentContext,
              builder: (context) => AlertDialog(
                title: Text(
                  "Nicht unterstützte Version",
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  "Bitte laden Sie sich die neueste Version von FixIT herunter",
                  textAlign: TextAlign.justify,
                ),
              ),
            );
          }
        });

        return Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: (istAuthentifiziert != null &&
                  istAuthentifiziert == true &&
                  schule != "")
              // Liste mit gemeldeten Fehlern
              ? Fehlerliste(
                  appBarHoehe: appBar.preferredSize.height,
                  nachrichtVomServer: benutzerInfoProvider.nachrichtVomServer,
                  automatischesEntfernenVonGefixtenMeldungen:
                      fehlerlisteProvider
                          .automatischesEntfernenVonGefixtenMeldungen,
                )
              // Ladedonut in der Mitte der Seite mit Option zum neuladen
              : Builder(builder: (BuildContext currentContext) {
                  WidgetsBinding.instance?.addPostFrameCallback((_) =>
                      ueberpruefeInternetVerbindung(
                          currentContext: currentContext));
                  return RefreshIndicator(
                    onRefresh: () async {
                      if (await ueberpruefeInternetVerbindung(
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    thema.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  "Authentifizierung",
                                  style: thema.textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
        );
      }),
    );
  }
}
