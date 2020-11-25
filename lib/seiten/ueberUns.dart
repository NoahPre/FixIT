// ueberUns.dart
import "../imports.dart";
import "package:url_launcher/url_launcher.dart";

class UeberUns extends StatelessWidget {
  static const String danksagungText =
      "Wir danken unserem Direktorat, Frau Birgit Reiter und Frau Silvia Duschka, sowie den PlusKurs-Koordinatorinnen, Frau Stefanie Lenner und Frau Heike Dabbert, für die Genehmigung und Förderung dieses Projekts. Unser AG- und PlusKurs-Leiter Herr Andreas Waschbüsch brachte uns überhaupt auf die Idee für dieses Projekt, half bei der Projektplanung und gab uns auch immer wieder Ratschläge bei der Entwicklung und Implementierung. Zuletzt danken wir Herrn Martin Waschbüsch, der die Serverkapazitäten bereitstellte, uns die Domain für unseren Server beschaffte und deren Einrichtung unterstützte.";

  /// erstellt eine Feedback E-Mail an info@icanfixit.eu
  Future<void> _erstelleMail() async {
    const url = "mailto:info@icanfixit.eu?subject=Feedback%20FixIT&body=";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch: $url";
    }
  }

  /// öffnet die Datenschutz Erklärung von FixIT im Standardbrowser des Benutzers
  Future<void> _oeffneDatenschutzErklaerung() async {
    const url = "https://www.icanfixit.eu/datenschutz.html";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch: $url";
    }
  }

  /// öffnet die GitHub Seite von FixIT im Standardbrowser des Benutzers
  Future<void> _oeffneGitHubSeite() async {
    const url = "https://github.com/NoahPre/FixIT";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch: $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Über uns",
          style: thema.textTheme.headline1,
        ),
      ),
      drawer: Seitenmenue(
        aktuelleSeite: "/ueberUns",
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            8.0,
            0.0,
            8.0,
            0.0,
          ),
          children: <Widget>[
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  "ALLGEMEIN",
                  style: thema.textTheme.subtitle1,
                ),
              ],
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Feedback und Verbesserungsvorschläge",
                      style: thema.textTheme.bodyText1,
                    ),
                    subtitle: Text(
                      "via E-Mail",
                      style: thema.textTheme.subtitle2,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: () => _erstelleMail(),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      "Datenschutzerklärung",
                      style: thema.textTheme.bodyText1,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: () => _oeffneDatenschutzErklaerung(),
                  ),
                  // ListTile(
                  //   title: Text(
                  //     "Im Store bewerten",
                  //     style: thema.textTheme.bodyText1,
                  //   ),
                  // ),
                  // Divider(),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  "DANKSAGUNG",
                  style: thema.textTheme.subtitle1,
                ),
              ],
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(
                      4.0,
                      4.0,
                      4.0,
                      4.0,
                    ),
                    title: Text(
                      danksagungText,
                      style: thema.textTheme.bodyText1,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  "ÜBER UNS",
                  style: thema.textTheme.subtitle1,
                ),
              ],
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Projekt auf GitHub",
                      style: thema.textTheme.bodyText1,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: () => _oeffneGitHubSeite(),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      "entwickelt von Noah und Martin",
                      style: thema.textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
