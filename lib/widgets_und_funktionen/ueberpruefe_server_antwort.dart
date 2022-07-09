// server_antwort_check.dart
import "package:fixit/imports.dart";

void ueberpruefeServerAntwort({
  required String antwort,
  required BuildContext currentContext,
  required String schule,
}) {
  ThemeData thema = Theme.of(currentContext);
  if (schule == "demo") {
    showSimpleNotification(
      Text(
        "Im Demo Modus werden die Eingaben nicht gespeichert",
        style: thema.snackBarTheme.contentTextStyle,
      ),
      background: thema.snackBarTheme.backgroundColor,
      duration: Duration(seconds: 4),
      slideDismissDirection: DismissDirection.down,
      position: NotificationPosition.bottom,
    );
  }
  if (antwort != "1") {
    if (antwort == "0") {
      showSimpleNotification(
        Text(
          "Etwas ist schief gelaufen",
          style: TextStyle(
            color: thema.colorScheme.onError,
          ),
        ),
        background: thema.colorScheme.error,
        duration: Duration(seconds: 4),
        slideDismissDirection: DismissDirection.down,
        position: NotificationPosition.bottom,
      );
    } else {
      showSimpleNotification(
        Text(
          antwort,
          style: thema.snackBarTheme.contentTextStyle,
        ),
        background: thema.snackBarTheme.backgroundColor,
        duration: Duration(seconds: 4),
        slideDismissDirection: DismissDirection.down,
        position: NotificationPosition.bottom,
      );
    }
  }
}
