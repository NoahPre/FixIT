# Strukturierung
In diesem Dokument wird kurz erklärt, wie FixIt aufgebaut ist und wie unsere Flutter Widgets aufgebaut sind.

## FixIt Aufbau
FixIt startet mit dem Home Widget. Zur Navigation gibt es ein Seitenmenü, über das man zu den folgenden Seiten gelangt:
- Gemeldete Fehler (Home Widget)
- Soforthilfe
- Wie funktioniert's (Tutorial Widget)
- Statistiken
- Über uns

## Projekt Aufbau
- seiten: alle Seiten der App
- klasse: sowohl alle Provider als auch andere Modelle, wie die Klasse Fehler
- widgets: alle Widgets, die auf mehreren Seiten verwendet werden
- sonstiges: selbsterklärend

## Widgets Aufbau
- alle Variablen
- getter und setter
- Constructor(s)
- Funktionen
- spezielle Funktionen, wie initState(), didUpdateWidget() oder dispose()
- build() Methode

