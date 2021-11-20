// zeigeSnackBarNachricht.dart
import "package:flutter/material.dart";

/// Zeigt eine SnackBar am unteren Bildschirmrand an.
///
/// Achtung: der übergebene [context] darf muss ein Context **unter** einem Scaffold sein.
/// D.h. man muss in den meisten Fällen einen Builder verwenden, um noch einen Context zwischen Scaffold und SnackBar zu bekommen.
void zeigeSnackBarNachricht({
  required String nachricht,
  required BuildContext context,
  required bool istError,
}) {
  ThemeData thema = Theme.of(context);
  ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          backgroundColor: istError
              ? thema.colorScheme.error
              : thema.snackBarTheme.backgroundColor,
          content: Text(
            nachricht,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            style: istError
                ? TextStyle(color: thema.colorScheme.onError)
                : thema.snackBarTheme.contentTextStyle,
          ),
        ),
      )
      .closed
      .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
}
