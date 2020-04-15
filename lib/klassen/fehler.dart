class Fehler {
  Fehler({
    this.id = 0,
    this.datum = "20200101",
    this.melder = "",
    this.raum = "",
    this.beschreibung = "",
    this.gefixt = "0",
  });

  // was automatisch an die Fehlermeldung angehängt wird
  // wir benutzen als ID einfach DateTime.now().millisecondsSinceEpoch
  int id;
  String datum;
  String melder;
  // was der User eingibt
  String raum;
  String beschreibung;
  // "0"= nicht gefixt; "1" = gefixt
  String gefixt;
}
