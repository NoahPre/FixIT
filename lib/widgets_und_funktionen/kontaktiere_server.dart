// kontaktiere_server.dart
import "package:http/http.dart" as http;

final String url = "https://www.icanfixit.eu";
final String adresse = "www.icanfixit.eu";

/// Klasse, in der die Pfade zu den einzelnen Scripts des Backends gespeichert werden
class ServerScripts {
  String authentifizierung = "/v1/authentifizierung.php";
  String behebeFehler = "/v1/behebeFehler.php";
  String entferneFehler = "/v1/entferneFehler.php";
  String gibAlleFehler = "/v1/gibAlleFehler.php";
  String gibBild = "/v1/gibBild.php";
  String gibInstitutionen = "/v1/gibInstitutionen.php";
  String gibNachrichtVomServer = "/v1/gibNachrichtVomServer.php";
  String gibSchuldaten = "/v1/gibSchuldaten.php";
  String gibUnterstuetzteVersion = "/v1/gibUnterstuetzteVersion.php";
  String schreibeBild = "/v1/schreibeBild.php";
  String schreibeFehler = "/v1/schreibeFehler.php";
  String datenschutz = url + "/datenschutz.html";
}

/// Instanz der ServerScripts Klasse. Wird genutzt, um die ServerScripts aufzurufen
final ServerScripts serverScripts = ServerScripts();

/// Kontaktiert das spezifizierte Script auf dem FixIT Server mit den übergebenen Parametern
Future kontaktiereServer(
    {required String pfad,
    required Map<String, String> parameter,
    bool trotzdemErlauben = false}) async {
  // wenn die Demo genutzt wird, sollen keine Fehler in die Datenbank geschrieben werden
  //TODO: sehr unprofessionell das ganze hier, am besten irgendwann besser machen
  // if (parameter["schule"] == "demo" &&
  //     pfad.contains("gibAlleFehler.php") == false) {
  //   return "1";
  // }
  // wenn der Benutzer die Demo Version nutzt (schule = "demo"), dann wird die Kommunikation zum Server unterbunden
  // nur wenn trotzdemErlauben == true gilt, dann wird die Kommunikation erlaubt (so etwa bei holeFehler() und holeSchuldaten())
  if (parameter["schule"] == "demo" && trotzdemErlauben == false) {
    return "1";
  }
  final Uri uri = Uri.https(adresse, pfad, parameter);
  try {
    http.Response response = await http.get(uri);
    return response.body;
  } catch (error) {
    print(error);
    return "";
  }
}

/// Lädt das übergeben Bild auf den FixIT Server hoch
String bildHochladen(
    {required String pfad,
    required String schule,
    required String token,
    String? dateiname,
    String? base64Image}) {
  final Uri uri = Uri.https(adresse, pfad, {"schule": schule, "token": token});
  http.post(uri, body: {
    "image": base64Image,
    "name": dateiname,
  }).then((result) {
    return result.statusCode == 200 ? result.body : "";
  }).catchError((error) {
    print(error.toString());
    return error.toString();
  });
  return "";
}
