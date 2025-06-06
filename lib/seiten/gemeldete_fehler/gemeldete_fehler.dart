// gemeldeteFehler.dart
import 'package:fixit/imports.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

/// Startseite der App
class GemeldeteFehler extends StatefulWidget {
  const GemeldeteFehler({super.key, required this.fehlerlisteProvider});
  final FehlerlisteProvider fehlerlisteProvider;

  @override
  State<GemeldeteFehler> createState() => _GemeldeteFehlerState();
}

class _GemeldeteFehlerState extends State<GemeldeteFehler>
    with WidgetsBindingObserver {
  bool fehlerGeholt = false;
  Sortierung _popupMenuButtonValue = Sortierung.datum_absteigend;

  List<List> sortierungsmoeglichkeiten = [
    [Sortierung.datum_absteigend, "Datum Absteigend"],
    [Sortierung.datum_aufsteigend, "Datum Aufsteigend"],
    [Sortierung.nicht_gefixt, "Nicht Gefixt"],
    // [Sortierung.raume_aufsteigend, "Räume"],
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // löscht die zu entfernenden Fehler, wenn der Benutzer die App schließt
    if (state == AppLifecycleState.paused) {
      widget.fehlerlisteProvider.entferneZuEntfernendeFehlermeldungen();
    }
  }

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
        style: thema.textTheme.displayLarge,
      ),
      backgroundColor: thema.colorScheme.primary,
      centerTitle: true,
      leading: Builder(builder: (BuildContext currentContext) {
        return IconButton(
          icon: Icon(Icons.menu),
          tooltip: "Menü",
          color: thema.colorScheme.onPrimary,
          onPressed: () => Scaffold.of(currentContext).openDrawer(),
        );
      }),
      actions: [
        PopupMenuButton<Sortierung>(
          tooltip: "Sortieren",
          color: thema.colorScheme.onPrimary,
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
          child: Icon(
            Icons.sort,
            color: thema.colorScheme.onPrimary,
          ),
        ),
        Container(
          width: 10.0,
        ),
        Builder(builder: (currentContext) {
          return IconButton(
            icon: Icon(Icons.refresh),
            tooltip: "Neu laden",
            color: thema.colorScheme.onPrimary,
            onPressed: () async {
              if (await ueberpruefeInternetVerbindung(
                      currentContext: currentContext) ==
                  false) {
                return;
              }
              fehlerlisteProvider.fehlerliste.clear();
              await fehlerlisteProvider.holeFehler();
              return;
            },
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

    if (schule != "" && fehlerGeholt == false) {
      fehlerlisteProvider.schule = schule;
      // holt die Fehler vom Server
      // fehlerlisteProvider.holeFehler();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
          fehlerlisteProvider
              .holeFehlerUndEntferneAutomatischGefixteMeldungen());
      setState(() {
        fehlerGeholt = true;
      });
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: appBar,
      drawer: const Seitenmenue(
        aktuelleSeite: "/",
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            // nur dafür da, um die Demo verlassen zu können
            schule == "demo"
                ? Flexible(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton.extended(
                        label: Text(
                          "Demo verlassen",
                          style: TextStyle(
                            color: thema.colorScheme.onPrimary,
                          ),
                        ),
                        backgroundColor: thema.colorScheme.primary,
                        onPressed: () =>
                            benutzerInfoProvider.benutzerMeldetSichAb(),
                      ),
                    ),
                  )
                : Container(),
            Align(
              alignment: Alignment.bottomRight,
              child: FABHome(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Builder(builder: (currentContext) {
        // überprüft, ob die laufende Version der App noch von Serverseite aus unterstützt wird
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (await benutzerInfoProvider.istUnterstuetzteVersion(
                  currentContext: context) ==
              false) {
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
                  fehlerlisteProvider: fehlerlisteProvider,
                  automatischesEntfernenVonGefixtenMeldungen:
                      fehlerlisteProvider
                          .holeFehlerUndEntferneAutomatischGefixteMeldungen,
                )
              // Ladedonut in der Mitte der Seite mit Option zum neuladen
              : Builder(builder: (BuildContext currentContext) {
                  WidgetsBinding.instance.addPostFrameCallback((_) =>
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
                      primary: false,
                      children: <Widget>[
                        SizedBox(
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
                                  style: thema.textTheme.bodyLarge,
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
