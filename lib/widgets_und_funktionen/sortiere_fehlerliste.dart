// sortiere_fehlerliste.dart
import "package:fixit/imports.dart";

enum Sortierung {
  /// sortiert die Fehler von neu nach alt
  datum_absteigend,

  /// sortiert die Fehler von alt nach neu
  datum_aufsteigend,

  /// sortiert die Fehler von nicht gefixt nach gefixt
  nicht_gefixt,

  /// sortiert die Fehler aufsteigend nach Räumen
  raume_aufsteigend
}

void sortiereFehlerliste({
  required Sortierung sortierung,
  required List<Fehler> zuSortierendeListe,
}) {
  zuSortierendeListe.sort((Fehler ersterFehler, Fehler zweiterFehler) {
    try {
      switch (sortierung) {
        case Sortierung.datum_absteigend:
          return -int.parse(ersterFehler.datum)
              .compareTo(int.parse(zweiterFehler.datum));
        case Sortierung.datum_aufsteigend:
          return int.parse(ersterFehler.datum)
              .compareTo(int.parse(zweiterFehler.datum));
        case Sortierung.nicht_gefixt:
          if (ersterFehler.gefixt == "0") {
            return -1;
          } else {
            return 1;
          }
        // case Sortierung.raume_aufsteigend:
        //   RegExp regex = RegExp(r'[0-9]');
        //   return ersterFehler.raum.compareTo(zweiterFehler.raum);
        // der default ist einfach datum_absteigend
        default:
          return -int.parse(ersterFehler.datum)
              .compareTo(int.parse(zweiterFehler.datum));
      }
    } catch (error) {
      print(error.toString());
      return 1;
    }
  });
}
