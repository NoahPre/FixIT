// bildDetailansicht.dart
import '../../imports.dart';

class BildDetailansicht extends StatefulWidget {
  BildDetailansicht({required this.urlZumBild});

  final String urlZumBild;

  @override
  _BildDetailansichtState createState() => _BildDetailansichtState();
}

class _BildDetailansichtState extends State<BildDetailansicht> {
  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    //TODO: hier das Bild nicht extra nochmal runterladen
    // evtl ist das mit dem erneut das Bild runterladen gar nicht so schlimm, Flutter is irgendwie schlau genug, das einfach nochmal zu benutzen
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            widget.urlZumBild,
            fit: BoxFit.contain,
            loadingBuilder: (
              BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    thema.primaryColor,
                  ),
                ),
              );
            },
            errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) =>
                Column(
              children: [
                Text("Bild konnte nicht geladen werden"),
                Text(exception.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
