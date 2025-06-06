// ueberUns.dart
import '../imports.dart';
import "package:url_launcher/url_launcher.dart";
import "package:package_info_plus/package_info_plus.dart";

class UeberUns extends StatelessWidget {
  static const String danksagungText =
      "Wir danken unserem Direktorat, Frau Birgit Reiter und Frau Silvia Duschka, sowie den PlusKurs-Koordinatorinnen, Frau Stefanie Lenner und Frau Heike Dabbert, für die Genehmigung und Förderung dieses Projekts. Unser AG- und PlusKurs-Leiter Herr Andreas Waschbüsch brachte uns überhaupt auf die Idee für dieses Projekt, half bei der Projektplanung und gab uns auch immer wieder Ratschläge bei der Entwicklung und Implementierung. Zuletzt danken wir Herrn Martin Waschbüsch, der die Serverkapazitäten bereitstellte, uns die Domain für unseren Server beschaffte und deren Einrichtung unterstützte.";

  const UeberUns({super.key});

  /// erstellt eine Feedback E-Mail an info@icanfixit.eu
  Future<void> _erstelleMail() async {
    Uri url = Uri.dataFromString(
        "mailto:info@icanfixit.eu?subject=Feedback%20FixIT&body=");
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Über uns",
          style: thema.textTheme.displayLarge,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: thema.colorScheme.onPrimary),
        backgroundColor: thema.colorScheme.primary,
      ),
      drawer: Seitenmenue(
        aktuelleSeite: "/ueberUns",
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
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
                  style: thema.textTheme.titleMedium,
                ),
              ],
            ),
            Card(
              child: Column(
                children: [
                  Builder(builder: (currentContext) {
                    return ListTile(
                      title: Text(
                        "Feedback und Verbesserungsvorschläge",
                        style: thema.textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        "via E-Mail oder GitHub",
                        style: thema.textTheme.titleSmall,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                      ),
                      onTap: () async {
                        await showDialog(
                          context: currentContext,
                          builder: (context) => AlertDialog(
                            title: Text("Feedback und Verbesserungsvorschläge"),
                            content: Text("Vielen Dank für Ihre Mithilfe"),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  TextButton(
                                    child: Text("E-Mail"),
                                    onPressed: () => _erstelleMail(),
                                  ),
                                  TextButton(
                                    child: Text("GitHub"),
                                    onPressed: () => oeffneURL(
                                      adresse: "github.com",
                                      pfad: "/NoahPre/FixIT/issues",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                  Divider(),
                  ListTile(
                    title: Text(
                      "Datenschutzerklärung",
                      style: thema.textTheme.bodyLarge,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: () => oeffneURL(
                      adresse: adresse,
                      pfad: serverScripts.datenschutz,
                    ),
                  ),
                  // ListTile(
                  //   title: Text(
                  //     "Im Store bewerten",
                  //     style: thema.textTheme.bodyLarge,
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
                  style: thema.textTheme.titleMedium,
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
                      style: thema.textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      "Teile des App Icons sind von Freepik / Flaticon",
                      style: thema.textTheme.bodyLarge,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                    // URL: "https://flaticon.com/premium-icon/hammer_2817081?term=hammer%20wrench&page=1&position=23&&related_id=2817081&origin=tag"
                    onTap: () => oeffneURL(
                        adresse: "flaticon.com",
                        pfad: "/premium-icon/hammer_2817081",
                        parameter: {
                          "term": "hammer%20wrench",
                          "page": "1",
                          "position": "23",
                          "related_id": "2817081",
                          "origin": "tag"
                        }),
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
                  style: thema.textTheme.titleMedium,
                ),
              ],
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Projekt auf GitHub",
                      style: thema.textTheme.bodyLarge,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: () => oeffneURL(
                      adresse: "github.com",
                      pfad: "/NoahPre/FixIT",
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      "Lizenzen",
                      style: thema.textTheme.bodyLarge,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      var packageInfo = await PackageInfo.fromPlatform();
                      showLicensePage(
                        context: context,
                        applicationName: "FixIT",
                        applicationIcon: Image.asset(
                          "assets/fixit_logo.png",
                          height: 50.0,
                          width: 50.0,
                        ),
                        applicationVersion: packageInfo.version,
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      "entwickelt von Noah und Martin",
                      style: thema.textTheme.bodyLarge,
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
