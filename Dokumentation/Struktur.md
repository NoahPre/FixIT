# Struktur
In diesem Dokument wird kurz und knapp erklärt, wie FixIT und unsere Flutter Widgets aufgebaut sind. Die folgenden Beschreibungen sind der Optimalzustand, in der Realität kann der Code auch mal anders aussehen ;)

## Aufbau von FixIT
FixIt startet mit dem Home Widget. Zur Navigation gibt es ein Seitenmenü, über das man zu den folgenden Seiten gelangt:
- Gemeldete Fehler (Home Widget)
- Soforthilfe (noch nicht eingebaut)
- Wie funktioniert's (Tutorial Widget)
- Statistiken (noch nicht eingebaut)
- Über uns

## Aufbau von lib (Ordner mit den Codefiles)
- seiten: alle Seiten der App
- klassen: sowohl alle Provider als auch andere Modelle, wie die Klasse Fehler
- widgets_und_funktionen: alle Widgets und Funktionen, die auf mehreren Seiten verwendet werden
- sonstiges: selbsterklärend

## Aufbau der Widgets
- alle Variablen
- Constructor(s)
- getter und setter (wenn vorhanden)
- Funktionen
- spezielle Funktionen, wie initState(), didUpdateWidget() oder dispose()
- build() Methode

## Aufbau der build()-Methode
- lokale Variablen
- lokale Funktionen
- Rückgabewert

