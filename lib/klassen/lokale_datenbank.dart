// lokale_datenbank.dart
import 'dart:convert';
import "dart:io";
import "package:path_provider/path_provider.dart";

/// Klasse, die das Speichern von Daten lokal auf dem Gerät in Form von Json String koordiniert
class LokaleDatenbank {
  String fehlerdatenFileName = "fehlerdaten.json";
  String schuldatenFileName = "schuldaten.json";
  String serverNachrichtenFileName = "server_nachrichten.json";

  /// holt den lokalen Pfad
  Future<String> get _lokalerPfad async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// gibt das Json File mit den lokal gespeicherten Daten zurück
  Future<File> _lokalesFile(String fileName) async {
    final String path = await _lokalerPfad;
    return File("$path/$fileName");
  }

  /// gibt den Inhalt des Files als String aus
  Future<String> leseFileAlsString(
      {required String fileName, required String defaultJsonString}) async {
    try {
      final File file = await _lokalesFile(fileName);
      if (file.existsSync() == false) {
        print("$fileName existiert nicht");
        await schreibeFile(fileName: fileName, jsonString: defaultJsonString);
      }
      String inhalt = await file.readAsString();
      print("inhalt: " + inhalt);
      return inhalt;
    } catch (error) {
      print("Error beim Lesen des Files $fileName: ${error.toString()}");
      throw error;
    }
  }

  /// schreibt die übergebenen Daten in das File
  Future<File> schreibeFile(
      {required String fileName, required String jsonString}) async {
    final File file = await _lokalesFile(fileName);
    return file.writeAsString('$jsonString');
  }

  Future<Map<String, dynamic>> holeLokaleFehlerdaten() async {
    String jsonString = await leseFileAlsString(
      fileName: fehlerdatenFileName,
      defaultJsonString:
          "{'eigene_fehlermeldungen_ids': [], 'eigene_gefixte_fehlermeldungen': [],}",
    );
    return jsonDecode(jsonString);
  }

  Future<void> schreibeLokaleFehlerdaten(Map<String, dynamic> daten) async {
    String jsonString = jsonEncode(daten);
    await schreibeFile(
      fileName: fehlerdatenFileName,
      jsonString: jsonString,
    );
  }

  Future<Map<String, dynamic>> holeLokaleServerNachrichtenDaten() async {
    String jsonString = await leseFileAlsString(
        fileName: serverNachrichtenFileName,
        defaultJsonString: '{"letzteNachrichtSHA1": ""}');
    return jsonDecode(jsonString);
  }

  Future<void> schreibeLokaleServerNachrichtenDaten(
      Map<String, dynamic> daten) async {
    String jsonString = jsonEncode(daten);
    await schreibeFile(
      fileName: serverNachrichtenFileName,
      jsonString: jsonString,
    );
  }

  Future<Map<String, dynamic>> holeLokaleSchuldaten() async {
    String jsonString = await leseFileAlsString(
      fileName: schuldatenFileName,
      defaultJsonString: "{}",
    );
    return jsonDecode(jsonString);
  }

  Future<void> schreibeLokaleSchuldaten(Map<String, dynamic> daten) async {
    String jsonString = jsonEncode(daten);
    await schreibeFile(
      fileName: schuldatenFileName,
      jsonString: jsonString,
    );
  }
}
