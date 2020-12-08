// zeigeSnackBarNachricht.dart
import "package:flutter/material.dart";

void zeigeSnackBarNachricht({
  @required String nachricht,
  @required BuildContext context,
}) {
  ThemeData thema = Theme.of(context);
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(
        nachricht ?? "",
        overflow: TextOverflow.ellipsis,
        maxLines: 4,
        style: thema.snackBarTheme.contentTextStyle,
      ),
    ),
  );
}
