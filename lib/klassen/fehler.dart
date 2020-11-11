class Fehler {
  Fehler({
    this.id = 0,
    this.datum = "",
    this.raum = "",
    this.beschreibung = "",
    this.gefixt = "0",
    this.fixer = "",
    this.gefixtDatum = "",
    this.kommentar = "",
    this.bild = ""
  });

  // was automatisch an die Fehlermeldung angehängt wird
  // wir benutzen als ID einfach DateTime.now().millisecondsSinceEpoch
  int id;
  String datum;
  // was der User eingibt
  String raum;
  String beschreibung;
  // "0"= nicht gefixt; "1" = gefixt
  String gefixt;
  // die Angaben zur Fehlerbehebung
  String fixer;
  String gefixtDatum;
  String kommentar;
  String bild;
}
