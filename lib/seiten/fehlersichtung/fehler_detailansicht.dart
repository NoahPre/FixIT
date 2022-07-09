// fehlerDetailansicht.dart
import '../../imports.dart';

// TODO: bei Änderungen hier, auch den Code in FehlerBehebung aktualisieren

class FehlerDetailansicht extends StatelessWidget {
  FehlerDetailansicht({
    required this.fehler,
    this.fehlerliste,
  });

  final Fehler fehler;
  final List<Fehler>? fehlerliste;

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    Size deviceSize = MediaQuery.of(context).size;
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context, listen: false);
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);
    final String urlZumBild = Uri.https(adresse, serverScripts.gibBild, {
      "schule": fehlerlisteProvider.schule,
      "token": fehlerlisteProvider.token,
      "bild": fehler.bild,
    }).toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fehler Detailansicht",
          style: thema.textTheme.headline1,
        ),
        backgroundColor: thema.colorScheme.primary,
        actions: <Widget>[
          Builder(builder: (currentContext) {
            return IconButton(
                icon: Icon(
                  Icons.delete,
                  color: thema.colorScheme.onPrimary,
                ),
                tooltip: "Fehler löschen",
                onPressed: () async {
                  if (await ueberpruefeInternetVerbindung(
                          currentContext: currentContext) ==
                      false) {
                    return;
                  }
                  await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: Text("Fehler wirklich löschen?"),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SimpleDialogOption(
                                  child: Text(
                                    "Bestätigen",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    try {
                                      String serverAntwort =
                                          await fehlerlisteProvider
                                              .fehlerGeloescht(
                                        fehler: fehler,
                                        istFehlermelder: benutzerInfoProvider
                                            .istFehlermelder,
                                      );
                                      ueberpruefeServerAntwort(
                                        antwort: serverAntwort,
                                        currentContext: currentContext,
                                      );

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                    // TODO: braucht man das?!
                                    on Exception catch (error) {
                                      Navigator.pop(context);
                                      print(error);
                                      zeigeSnackBarNachricht(
                                        nachricht:
                                            "Nur eigene Fehlermeldungen können gelöscht werden",
                                        context: context,
                                        istError: true,
                                      );
                                    }
                                  },
                                ),
                                SimpleDialogOption(
                                  child: Text("Abbrechen"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                });
          }),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 5.0,
              ),
              Row(
                children: <Widget>[
                  Hero(
                    tag: "CircleAvatar${fehler.id}",
                    child: CircleAvatar(
                      backgroundColor: thema.colorScheme.primary,
                      radius: deviceSize.width * 0.1,
                      child: Text(
                        fehler.raum,
                        style: thema.textTheme.headline4,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.025,
                  ),
                  Text(
                    "gemeldet am: " + datumInSchoen(fehler: fehler),
                    style: thema.textTheme.bodyText1,
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Beschreibung:",
                style: thema.textTheme.headline5,
              ),

              Text(
                fehler.beschreibung,
                style: thema.textTheme.bodyText1,
              ),
              const SizedBox(
                height: 10.0,
              ),

              // überprüft, ob der Fehler ein Bild hat und lädt dieses im entsprechenden Fall
              (fehler.bild.isEmpty || fehler.bild == "")
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Kein Bild gemeldet",
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                      ],
                    )

                  // lädt das Bild und gibt beim Fehlschlagen einen Error aus
                  : Flexible(
                      fit: FlexFit.loose,
                      child: GestureDetector(
                        onTap: () {
                          // zeigt nach Tippen das Bild im Vollbild an
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: false,
                              builder: (BuildContext context) =>
                                  BildDetailansicht(
                                urlZumBild: urlZumBild,
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: Hero(
                            tag: urlZumBild,
                            child: Image.network(
                              urlZumBild,
                              fit: BoxFit.contain,
                              loadingBuilder: (
                                BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress,
                              ) {
                                // zeigt das Bild an, wenn es fertig heruntergeladen ist
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return CircularProgressIndicator(
                                    // valueColor: AlwaysStoppedAnimation<Color>(
                                    //   thema.primaryColor,
                                    // ),
                                    );
                              },
                              errorBuilder: (BuildContext currentContext,
                                  Object exception, StackTrace? stackTrace) {
                                print(exception.toString());
                                return Text(
                                  "Bild konnte nicht geladen werden",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
