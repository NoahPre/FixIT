# fixit

FixIt ist ein Schulprojekt. Die fertige App soll helfen, technische Fehler und andere Defekte zu melden und eine schnelle Beseitigung dieser zu gewährleisten.

## Zur Orientierung

Dieses Projekt ist ein Flutter Projekt. Für mehr Informationen siehe: https://flutter.dev/

### Ordnerstruktur:

in /lib/:
- main.dart: Startpunkt der App
- klassen: Definitionen von Klassen
- netzwerk: Netzwerk und co
- seiten: alle Seiten der App
- sonstiges: sontiges
- widgets: Widgets, die zu groß/komplex sind

sonstige Ordner:
- assets: Bilder und andere Daten

Ordnerstruktur nach dem Vorbild von https://www.oreilly.com/library/view/beginning-flutter/9781119550822/ Kapitel 4 "CREATING AND ORGANIZING FOLDERS AND FILES"
alternativ: https://medium.com/flutter-community/flutter-code-organization-revised-b09ad5cef7f6

### Aufbau von Dokumenten
#### Klassen
Innerhalb der Klassendefinition haben wir uns auf folgende Reihenfolge der Klassenbestandteile geeinigt:
1. Constructor
2. Variablen
3. Methoden
 - initState(), dispose()
 - eigene Methoden
 - build()
4. am Ende kann man eventuell unwichtiges Zeug ablagern

#### Importe
- 1

 1st party packages
- 2

 unsere Dokumente
- 3

 3rd party packages


## Schreibweisen

Dateinamen und Ordnernamen werden auf Deutsch geschrieben.

Kommentare werden auf Deutsch, Variablen und Funktionen in camelCase und auch auf Deutsch geschrieben (damit wir ein bisschen einheitlich sind).

## Aufbau der App




