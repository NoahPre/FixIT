// zeigeSnackBarNachricht.dart
import "package:flutter/material.dart";

void zeigeSnackBarNachricht({
  required String nachricht,
  required BuildContext context,
  required bool istError,
}) {
  ThemeData thema = Theme.of(context);
  ScaffoldMessenger(
    child: SnackBar(
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
  );
}
