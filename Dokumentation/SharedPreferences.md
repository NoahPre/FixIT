# Shared Preferences
FixIT benutzt das Flutter Plugin [shared_preferences](https://pub.dev/packages/shared_preferences), um kleine Datenmengen lokal auf dem Gerät zu speichern. 
Dieses Dokument stellt eine Übersicht der gespeicherten Daten und der dabei benutzten Keys dar.

* boolean "istFehlermelder": speichert, ob der Benutzer als Fehlermelder oder -beheber angemeldet ist
* String "passwort": speichert das bei der Anmeldung angegebene Passwort, das für die Authentifizierung mit dem Server genutzt wird
* List<String> "eigeneFehlermeldungenIDs": speichert die IDs der eigenen Fehlermeldungen, um sicherzustellen, dass Fehlermelder nur eigene Einträge löschen können
* integer "fehlermeldungsZaehler": speichert die Anzahl an abgesendeten Fehlermeldungen des Benutzers
* integer "fehlerbehebungsZaehler": speichert die Anzhal an behobenen (gelöschten) Fehlermeldungen, wenn der Benutzer ein Fehlerbeheber ist