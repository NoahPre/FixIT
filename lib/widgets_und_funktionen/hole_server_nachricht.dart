// hole_server_nachricht.dart
import "dart:convert";
import "package:fixit/imports.dart";
import "package:crypto/crypto.dart";

Future<void> holeServerNachricht({
  required BuildContext context,
  required Function nachrichtVomServer,
}) async {
  ThemeData thema = Theme.of(context);
  Map<String, dynamic>? nachrichtMap = await nachrichtVomServer();
  // wenn keine Nachricht anzuzeigen ist, dann wird die Funktion hier beendet
  if (nachrichtMap == null) {
    return;
  }
  LokaleDatenbank lokaleDatenbank = LokaleDatenbank();
  Map<String, dynamic> serverNachrichten =
      await lokaleDatenbank.holeLokaleServerNachrichtenDaten();
  String aktuelleNachrichtSHA1 =
      sha1.convert(utf8.encode(nachrichtMap["text"] ?? "")).toString();
  // wenn die Nachricht schon einmal angezeigt wurde, dann
  if (aktuelleNachrichtSHA1 ==
      (serverNachrichten["letzteNachrichtSHA1"] ?? "")) {
    return;
  }
  // // wird ausgeführt, wenn die Nachricht noch nicht angezeigt wurde (der Hash der Nachricht noch nicht in der Datenbank ist)
  else {
    serverNachrichten["letzteNachrichtSHA1"] = aktuelleNachrichtSHA1;
    lokaleDatenbank.schreibeLokaleServerNachrichtenDaten(serverNachrichten);
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Center(
              child: Text(nachrichtMap["titel"] ?? ""),
            ),
            titleTextStyle: thema.textTheme.displayMedium,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        nachrichtMap["text"] ?? "",
                        style: thema.textTheme.bodyLarge,
                        maxLines: 1000,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Center(
                child: TextButton(
                  child: Text(
                    "OK",
                    style: thema.textTheme.bodyLarge,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        });
  }
}
