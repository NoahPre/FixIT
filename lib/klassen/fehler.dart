class Fehler {
  Fehler({
    this.id = "",
    this.datum = "",
    this.raum = "",
    this.beschreibung = "",
    this.gefixt = "0",
    this.fixer = "",
    this.gefixtDatum = "",
    this.kommentar = "",
    this.bild = "",
  });

  factory Fehler.from(dynamic json) {
    return Fehler(
      id: json["id"]?.toString() ?? "",
      datum: json["datum"]?.toString() ?? "",
      raum: json["raum"]?.toString() ?? "",
      beschreibung: json["beschreibung"]?.toString() ?? "",
      gefixt: json["gefixt"]?.toString() ?? "",
      fixer: json["fixer"]?.toString() ?? "",
      gefixtDatum: json["gefixtDatum"]?.toString() ?? "",
      kommentar: json["kommentar"]?.toString() ?? "",
      bild: json["bild"]?.toString() ?? "",
    );
  }

  // was automatisch an die Fehlermeldung angehängt wird:

  /// wir benutzen als ID die uuid.v4() aus dem uuid Package von pub.dev
  String id;
  String datum;

  // was der User eingibt
  String raum;
  String beschreibung;
  // "0"= nicht gefixt; "1" = gefixt
  String gefixt;
  // die Angaben zur Fehlerbehebung:
  // werden im Moment noch nicht unterstützt
  String? fixer;
  String? gefixtDatum;
  String? kommentar;
  //TODO: dieser Wert ist eigentlich überflüssig, da die Information ja eigentlich schon in id gespeichert ist
  String bild;
}
