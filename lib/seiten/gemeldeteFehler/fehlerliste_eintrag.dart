// fehlerliste_eintrag.dart
import "package:fixit/imports.dart";

class FehlerlisteEintrag extends StatelessWidget {
  final Fehler fehler;
  FehlerlisteEintrag({required this.fehler});
  // konvertiert das Datum aus dem gegebenen Fehler zu einem schönen String
  String datumInSchoen(Fehler fehler) {
    try {
      String tag = fehler.datum.split("")[6] + fehler.datum.split("")[7];
      String monat = fehler.datum.split("")[4] + fehler.datum.split("")[5];
      String jahr = fehler.datum.split("")[0] +
          fehler.datum.split("")[1] +
          fehler.datum.split("")[2] +
          fehler.datum.split("")[3];
      String gesamt = tag + "." + monat + "." + jahr;
      return gesamt;
    } catch (error) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(
      context,
      listen: false,
    );
    Size _size = MediaQuery.of(context).size;
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
            if (fehlerlisteProvider.eigeneFehlermeldungenIDs
                        .contains(fehler.id) ==
                    false &&
                benutzerInfoProvider.istFehlermelder == true) {
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
            fehlerlisteProvider.fehlerGeloescht(
              fehler: fehler,
              istFehlermelder: benutzerInfoProvider.istFehlermelder,
            );
          },
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: false,
                    builder: (context) {
                      // zeigt nur Fehlerbehebung an, wenn der Benutzer ein Fehlerbeheber ist und der Fehler noch nicht behoben wurde
                      if (benutzerInfoProvider.istFehlermelder == false &&
                          fehler.gefixt == "0") {
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
                    radius: _size.width * 0.1,
                    backgroundColor: thema.colorScheme.primary,
                    child: Text(
                      fehler.raum,
                      style: thema.textTheme.headline4,
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
                    child: Container(
                      // die gleiche Höhe wie das CircularAvatar
                      height: _size.width * 0.2,
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
                                  style: thema.textTheme.bodyText1,
                                ),

                                // Datumsangabe der Fehlermeldung
                                Text(
                                  datumInSchoen(fehler),
                                  maxLines: 1,
                                  style: thema.textTheme.bodyText1,
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
                            width: 4.0,
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
