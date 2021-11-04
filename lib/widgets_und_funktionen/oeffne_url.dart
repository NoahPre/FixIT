// oeffne_url.dart
import "package:url_launcher/url_launcher.dart";

Future<void> oeffneURL({required String url}) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Could not launch: $url";
  }
}
