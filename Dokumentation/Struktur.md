# Struktur
In diesem Dokument wird kurz und knapp erklärt, wie FixIT aufgebaut ist und wie unsere Flutter Widgets aufgebaut sind.

## FixIt Aufbau
FixIt startet mit dem Home Widget. Zur Navigation gibt es ein Seitenmenü, über das man zu den folgenden Seiten gelangt:
- Gemeldete Fehler (Home Widget)
- Soforthilfe
- Wie funktioniert's (Tutorial Widget)
- Statistiken
- Über uns

## Projekt Aufbau
- seiten: alle Seiten der App
- klassen: sowohl alle Provider als auch andere Modelle, wie die Klasse Fehler
- widgets_und_funktionen: alle Widgets und Funktionen, die auf mehreren Seiten verwendet werden
- sonstiges: selbsterklärend

## Widgets Aufbau
- alle Variablen
- Constructor(s)
- getter und setter (wenn vorhanden)
- Funktionen
- spezielle Funktionen, wie initState(), didUpdateWidget() oder dispose()
- build() Methode

## build() Methode Aufbau
- lokale Variablen
- lokale Funktionen
- Rückgabewert

