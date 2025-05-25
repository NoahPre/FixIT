// fehlerliste_eintrag.dart
import "package:fixit/imports.dart";

class FehlerlisteEintrag extends StatelessWidget {
  final Fehler fehler;
  const FehlerlisteEintrag({super.key, required this.fehler});

  @override
  Widget build(BuildContext context) {
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(
      context,
      listen: false,
    );
    Size size = MediaQuery.of(context).size;
    ThemeData thema = Theme.of(context);
    return Column(
      children: [
        const SizedBox(
          height: 4,
        ),
        Dismissible(
          background: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          secondaryBackground: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          confirmDismiss: (_) async {
            // wird ausgeführt, wenn
            // - der Fehler nicht vom Benutzer ist und der Benutzer Fehlermelder ist
            // - das Gerät nicht mit dem Internet verbunden ist
            if ((fehlerlisteProvider.eigeneFehlermeldungenIDs
                            .contains(fehler.id) ==
                        false &&
                    benutzerInfoProvider.istFehlermelder == true) ||
                await ueberpruefeInternetVerbindung(currentContext: context) ==
                    false) {
              zeigeSnackBarNachricht(
                nachricht: "Nur eigene Fehlermeldungen können gelöscht werden",
                context: context,
                istError: true,
              );

              return false;
            }
            bool? returnValue;
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
                            onPressed: () {
                              Navigator.pop(context);
                              returnValue = true;
                            },
                          ),
                          SimpleDialogOption(
                            child: Text("Abbrechen"),
                            onPressed: () {
                              Navigator.pop(context);
                              returnValue = false;
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                });
            return returnValue;
          },
          onDismissed: (DismissDirection direction) async {
            String serverAntwort = await fehlerlisteProvider.fehlerGeloescht(
              fehler: fehler,
              istFehlermelder: benutzerInfoProvider.istFehlermelder,
            );
            ueberpruefeServerAntwort(
              antwort: serverAntwort,
              currentContext: context,
              schule: fehlerlisteProvider.schule,
            );
          },
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {
              // Fehlermelder können nur eigene Meldungen sehen, Fehlerbeheber alle Meldungen
              if (benutzerInfoProvider.istFehlermelder == true &&
                  fehlerlisteProvider.eigeneFehlermeldungenIDs
                          .contains(fehler.id) ==
                      false) {
                zeigeSnackBarNachricht(
                  nachricht:
                      "Nur eigene Fehlermeldungen können angeschaut werden",
                  context: context,
                  istError: false,
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (context) {
                      // zeigt nur Fehlerbehebung an, wenn der Benutzer ein Fehlerbeheber ist
                      if (benutzerInfoProvider.istFehlermelder == false) {
                        return Fehlerbehebung(
                          fehler: fehler,
                        );
                      } else {
                        return FehlerDetailansicht(
                          fehler: fehler,
                        );
                      }
                    }),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(width: 3.0),
                Hero(
                  tag: "CircleAvatar${fehler.id}",
                  child: CircleAvatar(
                    radius: size.width * 0.1,
                    backgroundColor: thema.colorScheme.primary,
                    child: Text(
                      fehler.raum,
                      style: thema.textTheme.headlineMedium,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                Flexible(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: SizedBox(
                      // die gleiche Höhe wie das CircularAvatar
                      height: size.width * 0.2,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 4.0),
                          // TODO: Warum funktioniert das hier?
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Vorschau der Fehlerbeschreibung
                                Text(
                                  fehler.beschreibung,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: thema.textTheme.bodyLarge,
                                ),

                                // Datumsangabe der Fehlermeldung
                                Text(
                                  datumInSchoen(fehler: fehler),
                                  maxLines: 1,
                                  style: thema.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              fehler.gefixt == "0" ? Icons.cached : Icons.done,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          key: Key(
            fehler.id.toString(),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
      ],
    );
  }
}
