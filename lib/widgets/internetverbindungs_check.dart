// internetverbindungs_check.dart
import "package:flutter/material.dart";
import "dart:io";
import "package:fixit/widgets/zeige_snackbar_nachricht.dart";

Future<bool> ueberpruefeInternetVerbindung(
    {required BuildContext currentContext}) async {
  try {
    final result = await InternetAddress.lookup(
      "1.1.1.1",
      type: InternetAddressType.IPv4,
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
  } on SocketException catch (error) {
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
