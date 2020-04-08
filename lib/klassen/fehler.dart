class Fehler {

  Fehler({this.raum = "", this.beschreibung = "", this.id = "", this.date, this.user, this.gefixt});

  // was automatisch an die Fehlermeldung angehängt wird
  var id;
  DateTime date;
  var user;
  bool gefixt;
  // was der User eingibt
  String raum;
  String beschreibung;
  

}