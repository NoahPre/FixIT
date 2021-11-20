// datum_in_schoen.dart
import "package:fixit/klassen/fehler.dart";

// das Datum in schön
// TODO: evtl. das intelligenter lösen

/// Nimmt das in der Form YYYYMMDD gespeicherte Datum und formatiert es neu
String datumInSchoen({required Fehler fehler}) {
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
