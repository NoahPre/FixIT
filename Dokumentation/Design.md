# Design
Generell kann man das meiste des Designs von FixIT in der Variable thema in thema.dart abändern.

## Farben
FixIT nutzt ein ColorScheme mit einer primären Farbe, einer sekundären Farbe (und noch je eine andere Variante), eine Hintergrundfarbe, eine Error Farbe und zu jeder dieser Farben je die Farbe, die der Text auf ihr haben soll (onPrimary, onSecondary).
Die primäre Farbe wird für die Hintergrundfarbe der AppBar, die sekundäre Farbe zum Beispiel für Knöpfe und die Variante der primären Farbe für die Kreise auf denen die Raumnummern stehen benutzt.
Im Code werden die Farben demnach nicht direkt fest hineingeschrieben, sondern stattdessen wird eine Referenz zum entsprechenden Wert des ColorSchemes in der thema Variable erstellt. Dadurch kann man einfach die Farben der App ändern, ohne durch den ganzen Code gehen zu müssen.

## Text Style
### Headlines
displayLarge ist die größte Überschrift in FixIt und wird für den Titel der AppBars verwendet. Mit absteigender Zahl werden die headline Werte immer kleiner. Der kleinste Wert ist headline6. Bei einer ungeraden Zahl ist der Text weiß, bei einer geraden schwarz.
### Normaler Text
bodyLarge ist der normal benutzte Text in FixIT (schwarz, 14 pt). bodyMedium ist weiß und wird auf dunklen Oberflächen benutzt.
### Untertitel
titleMedium (dunkelgrau, 14 pt) ist der TextStlye, der für die Überschriften auf der Über uns Seite verwendet wird. titleSmall ist eine kleinere Version davon mit 12 pt

## Divider
Die Divider (schmale Linien zum Trennen von Listeneinträgen) sind in FixIT dunkelgrau und recht dünn. Diese Eigenschaften können in thema.dart geändert werden.


## Darkmode
Ein Darkmode wird von FixIT zur Zeit noch nicht unterstützt, die Grundlagen dafür können aber in der Variable dunklesThema in thema.dart gemacht werden.
