# Wichtige Werte
## bei der Kommunikation mit dem Server
* "1" (= true): keine Probleme
* "0" (= false): undefinierter Fehler
* "falsche_schule": die Schule des Benutzers existiert nicht
* "falsches_token": das Token für die angegebene Schule ist falsch
* "Error: DATENBANKFEHLER": es gab ein Problem beim Ausführen des SQL Querys in der Datenbank

## lokal auf dem Gerät gespeicherte Daten
Die Namen der Files, die lokal auf dem Gerät gespeichert werden
* "schuldaten.json": enthält alle Daten der Schule des Benutzers 
    * kuerzel: Kürzel der Schule (z.B. mtg) 
    * praefixe: Liste der Präfixe der Schule (z.B. ["N", "Z", "K", "T"])
    * raumnummern_art: String; Möglichkeiten: zahl, buchstabe, alles (ob die Räume mit Zahlen, Buchstaben oder beidem bezeichnet werden)
    * raumnummern_bereich: Liste aus zwei Bestandteilen, der erste Teil gibt die untere Grenze, der zweite Teil die obere Grenze der Raumnummern an (natürlich nur verfügbar, wenn art = zahl ist)
* "server_nachrichten.json": enthält Informationen über vom Server angezeigten Nachrichten
    * wenn eine neue Nachricht des Servers angezeigt wurde, wird in diesem File der Hash der Nachricht gespeichert (damit die Nachricht nicht öfter angezeigt wird)
    * wenn eine neue Nachricht des Servers angezeigt wurde, wird der alte Hash der Nachricht gelöscht (damit wir nicht sinnlos viel Platz verbrauchen)
    * Datenstruktur in diesem File: {"letzteNachrichtSHA1": "SHA1-HASH-DER-LETZTEN-NACHRICHT"}