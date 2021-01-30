// dummyFehler.dart
import '../klassen/fehler.dart';

List fehlerliste = [
  Fehler(
    id: "0",
    datum: "2020/01/01",
    beschreibung: "Erster Fehler",
    fixer: "Martin",
    gefixt: "1",
    gefixtDatum: "2020/01/03",
    kommentar: "kein Kommentar",
    raum: "K21",
  ),
  Fehler(
    id: "1",
    datum: "2020/01/03",
    beschreibung: "Zweiter Fehler",
    fixer: "Noah",
    gefixt: "1",
    gefixtDatum: "2020/01/07",
    kommentar: "kein Kommentar",
    raum: "N41",
  ),
  Fehler(
    id: "2",
    datum: "2020/01/02",
    beschreibung: "Dritter Fehler",
    fixer: "",
    gefixt: "0",
    gefixtDatum: "",
    kommentar: "",
    raum: "K21",
  ),
  Fehler(
    id: "3",
    datum: "2020/01/05",
    beschreibung: "Vierter Fehler",
    fixer: "",
    gefixt: "0",
    gefixtDatum: "",
    kommentar: "",
    raum: "K21",
  ),
];
