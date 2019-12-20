import "package:flutter/material.dart";
//Tutorial: https://medium.com/flutterdevs/using-sharedpreferences-in-flutter-251755f07127
//shared_preferences ist das Äquivalent zu NSUserDefaults in iOS/xcode
//es speichert kleine Variablen (insgesamt Speicher nicht größer als 1 MB) über den Lebenszyklus der App hinaus
//wir benutzen es, um
//-herauszufinden, ob der User registriert/angemeldet ist
//-herauszufinden, ob der User Fehlermelder oder -beheber ist
//-die Daten des Users zu speichern (Username, Passwort)
import "package:shared_preferences/shared_preferences.dart";

//unsere Files
//für die Fehlermeldung
import "./Widgets/Fehlermeldungsvorlage/FABforFehlermeldungsvorlage.dart";
//für die Registrierung
import "./Widgets/RegistrierungUndAnmeldung/RegistrierungsButton.dart";

void main() => runApp(FixIt());

//das hier ist ein StatelessWidget, da dies nie neu gerendert werden muss
class FixIt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.blue;
    Color accentColor = Colors.black;

    print("built");
    return MaterialApp(
      home: FixItHomePage(),
      // das Theme ist eine Klasse, auf die man im ganzen Projekt zugreifen kann
      // hier kann man z.B. einen Standard für alle Titel oder Buttons festlegen
      // man erreicht den hier vorgegebenen Stil mit Theme.of(context).?
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        textTheme: TextTheme(
          title: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: accentColor,
          textTheme: ButtonTextTheme.normal,
        ),
        appBarTheme: AppBarTheme(
          color: primaryColor,
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

//muss stateful sein, da wir Content updaten (da wir ein BottomSheet benutzen)
class FixItHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FixItHomePageState();
  }
}

class _FixItHomePageState extends State<FixItHomePage> {
  //hier kommen Funktionen wie initState(), didUpdateWidget() und dispose() hin

  //shared_preferences:
  //wird am Anfang von istBenutzerRegistriert() überschrieben
  bool istRegistriert;
  //wird am Anfang von istBenutzerRegistriert() überschrieben
  String benutzername = "";

  //checkt, ob der User registriert ist, setzt istRegistriert auf true bzw. false
  //und speichert den Benutzernamen in benutzername ab
  istBenutzerRegistriert() async {
    SharedPreferences sharedPreferencesInstance =
        await SharedPreferences.getInstance();
    setState(() {
      this.istRegistriert =
          sharedPreferencesInstance.getBool('istRegistriert') ?? false;
      this.benutzername = sharedPreferencesInstance.getString("benutzername");
    });
  }

  //setzt die Registrierung zurück
  registrierungZuruecksetzen() async {
    SharedPreferences sharedPreferencesInstance =
        await SharedPreferences.getInstance();
    sharedPreferencesInstance.setBool('istRegistriert', false);
  }

  //build() mit Widget Tree
  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    //updated istRegistriert und benutzername
    istBenutzerRegistriert();

    //checkt, ob der Benutzer registriert ist (ist Registriert entweder true oder false)
    return istRegistriert
        //wird ausgeführt, wenn istRegistriert true ist
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "FixIt",
                style: theme.appBarTheme.textTheme.title,
              ),
            ),
            //der FloatingActionButton (kurz: FAB) wird in einem anderen File definiert
            floatingActionButton: FABforFehlermeldungsvorlage(),
            //hier soll später eine Liste mit den Meldungen des Users hin
            body: Column(
              children: <Widget>[
                Center(
                  child: Text("Fix It"),
                ),
                Center(
                  child: Text(benutzername),
                ),
                RaisedButton(
                  child: Text("Registrierung zurücksetzen"),
                  color: Colors.red,
                  onPressed: () {
                    registrierungZuruecksetzen();
                  },
                )
              ],
            ),
          )
        //wird ausgeführt, wenn istRegistriert false ist
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "FixIt",
                style: Theme.of(context).textTheme.title,
              ),
            ),
            body: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    "Sie sind nicht registriert",
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.title.fontSize),
                  ),
                ),
                RegistrierungsButton(),
              ],
            ),
          );
  }
}
