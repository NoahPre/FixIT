// internetverbindungs_check.dart
import "dart:io";
import "package:flutter/material.dart";
import "package:fixit/widgets_und_funktionen/zeige_snackbar_nachricht.dart";

// TODO: Internetverbindungs-Check besser und einheitlicher machen
// -> nicht jedes Mal, wenn man die Internetverbindung überprüft, neue Anfrage bei einem Server machen -> zu viel Netzwerkverkehr
// -> lieber sowas hier machen (die zweite Antwort): https://stackoverflow.com/questions/49648022/check-whether-there-is-an-internet-connection-available-on-flutter-app

/// Überprüft die Internetverbindung des Gerätes
///
/// true: mit dem Internet verbunden
///
/// false: nicht mit dem Internet verbunden
Future<bool> ueberpruefeInternetVerbindung(
    {required BuildContext currentContext}) async {
  try {
    final result = await InternetAddress.lookup("duckduckgo.com"
        // "1.1.1.1",
        // type: InternetAddressType.IPv4,

        );
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      zeigeSnackBarNachricht(
        nachricht: "Nicht mit dem Internet verbunden",
        context: currentContext,
        istError: true,
      );

      return false;
    }
  } on SocketException catch (_) {
    zeigeSnackBarNachricht(
      nachricht: "Nicht mit dem Internet verbunden",
      context: currentContext,
      istError: true,
    );
    return false;
  } catch (error) {
    zeigeSnackBarNachricht(
      nachricht: error.toString(),
      context: currentContext,
      istError: true,
    );
    return false;
  }
}
