// server_antwort_check.dart
import "package:flutter/material.dart";
import "package:fixit/widgets_und_funktionen/zeige_snackbar_nachricht.dart";

void ueberpruefeServerAntwort(
    {required String antwort, required BuildContext currentContext}) {
  if (antwort != "1") {
    if (antwort == "0") {
      zeigeSnackBarNachricht(
        nachricht: "Etwas ist schief gelaufen",
        context: currentContext,
        istError: true,
      );
    } else {
      zeigeSnackBarNachricht(
        nachricht: antwort,
        context: currentContext,
        istError: true,
      );
    }
  }
}
