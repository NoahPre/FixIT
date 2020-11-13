// fehlerliste.dart
import "../../imports.dart";
import "package:http/http.dart" as http;

// TODO: beim fixen des Fehlers Kommentar hinterlassen Funktion hinzufügen

class Fehlerliste extends StatefulWidget {
  @override
  _FehlerlisteState createState() => _FehlerlisteState();
}

class _FehlerlisteState extends State<Fehlerliste> {
  @override
  Widget build(BuildContext context) {
    // aus provider.dart und fehlerlisteProvider.dart
    final FehlerlisteProvider fehlerlisteProvider =
        Provider.of<FehlerlisteProvider>(context);
    final BenutzerInfoProvider benutzerInfoProvider =
        Provider.of<BenutzerInfoProvider>(context);
    Size _size = MediaQuery.of(context).size;
    ThemeData thema = Theme.of(context);

    // aktualisiert die Liste
    Future<void> refresh() async {
      fehlerlisteProvider.fehlerliste.clear();
      await fehlerlisteProvider.holeFehler();
      return null;
    }

    return StreamBuilder(
      stream: fehlerlisteProvider.fehlerlisteStream,
      initialData: fehlerlisteProvider.fehlerliste,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        String datumInSchoen(Fehler fehler) {
          String tag = fehler.datum.split("")[6] + fehler.datum.split("")[7];
          String monat = fehler.datum.split("")[4] + fehler.datum.split("")[5];
          String jahr = fehler.datum.split("")[0] +
              fehler.datum.split("")[1] +
              fehler.datum.split("")[2] +
              fehler.datum.split("")[3];
          String gesamt = tag + "." + monat + "." + jahr;
          return gesamt;
        }

        return snapshot.hasData
            ? snapshot.data.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text("Noch keine Fehler gemeldet"),
                      ),
                    ],
                  )
                // Widget für den Scrollbalken am Rand
                : Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: () => refresh(),
                      child: ListView(
                        children: snapshot.data.map<Widget>(
                          (Fehler fehler) {
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
                                  onDismissed: (DismissDirection direction) {
                                    print(fehler.id.toString());
                                    fehlerlisteProvider.fehlerGeloescht(
                                      fehler: fehler,
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
                                              if (benutzerInfoProvider
                                                          .istFehlermelder ==
                                                      false &&
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        const SizedBox(width: 3.0),
                                        Hero(
                                          tag: "CircleAvatar${fehler.id}",
                                          child: CircleAvatar(
                                            radius: _size.width * 0.1,
                                            backgroundColor: thema.primaryColor,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(width: 4.0),
                                                  // TODO: Warum funktioniert das hier?
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Vorschau der Fehlerbeschreibung
                                                        Text(
                                                          fehler.beschreibung,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: thema.textTheme
                                                              .bodyText1,
                                                        ),

                                                        // Datumsangabe der Fehlermeldung
                                                        Text(
                                                          datumInSchoen(fehler),
                                                          maxLines: 1,
                                                          style: thema.textTheme
                                                              .bodyText1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Icon(
                                                      fehler.gefixt == "0"
                                                          ? Icons.cached
                                                          : Icons.done,
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
                          },
                        ).toList(),
                      ),
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
