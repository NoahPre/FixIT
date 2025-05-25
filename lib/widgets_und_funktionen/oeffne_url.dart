// oeffne_url.dart
import "package:url_launcher/url_launcher.dart";

Future<void> oeffneURL(
    {required String adresse,
    required String pfad,
    Map<String, dynamic> parameter = const {}}) async {
  Uri url = Uri.parse("https://$adresse$pfad");
  await launchUrl(url);
}
