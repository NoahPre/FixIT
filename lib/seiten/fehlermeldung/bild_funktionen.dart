// bildFunktionen.dart
import "dart:convert";
import "dart:io";
import 'package:fixit/imports.dart';
// für den Typ PickedFile

/// In diesem Dokument sind viele Funktionen zum Auswählen, Aufnehmen und Anzeigen von einem Bild
///
/// alle diese Funktionen werden im Widget Fehlermeldung in fehlermeldung.dart gebraucht

/// zeigt je nach Betriebssystem einen Bilderauswahldialog
Future<void> zeigeBilderAuswahl({
  required BuildContext currentContext,
  required Function pfadZumBild,
  required CameraController? controller,
  required Function bildAusGallerieAuswaehlen,
}) async {
  ThemeData thema = Theme.of(currentContext);
  showModalBottomSheet(
    isDismissible: true,
    context: currentContext,
    builder: (BuildContext context) => BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 100.0,
                  child: Tooltip(
                    message: "Kamera",
                    child: InkWell(
                      child: Icon(
                        Icons.photo_camera,
                        color: thema.colorScheme.onBackground,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        bildAufnehmen(
                          context: currentContext,
                          pfadZumBild: pfadZumBild,
                          controller: controller,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 100.0,
                width: 2.0,
                color: Colors.black,
              ),
              Expanded(
                child: SizedBox(
                  height: 100.0,
                  child: Tooltip(
                    message: "Bildergalerie",
                    child: InkWell(
                      child: Icon(
                        Icons.collections,
                        color: Colors.black,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        bildAusGallerieAuswaehlen();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

/// lässt den Benutzer ein Bild aufnehmen
void bildAufnehmen({
  required BuildContext context,
  required Function pfadZumBild,
  required CameraController? controller,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return BildAufnahme(
          pfadZumBild: pfadZumBild,
          controller: controller,
        );
      },
    ),
  );
}

/// zeigt das ausgewählte Bild
Widget zeigeAusgewaehltesBild(
    {required Future<XFile?>? ausgewaehltesBild,
    required Function setzeBildWerte}) {
  return FutureBuilder<XFile?>(
    future: ausgewaehltesBild,
    builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
      if (snapshot.connectionState == ConnectionState.done &&
          null != snapshot.data) {
        File bild = File(snapshot.data!.path);
        // TODO: das hier besser lösen, das nicht hier machen sondern in irgendeiner anderen Funktion
        setzeBildWerte(
          temporaeresBild: snapshot.data,
          base64Bild: base64Encode(
            bild.readAsBytesSync(),
          ),
        );

        return Image.file(
          bild,
          fit: BoxFit.fill,
        );
      } else if (null != snapshot.error) {
        return const Text(
          'Error Picking Image',
          textAlign: TextAlign.center,
        );
      } else {
        return const Text(
          'Kein Bild ausgewählt',
          textAlign: TextAlign.center,
        );
      }
    },
  );
}
