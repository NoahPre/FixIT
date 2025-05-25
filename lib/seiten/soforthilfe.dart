// soforthilfe.dart
// 1
import "../imports.dart";

class Soforthilfe extends StatelessWidget {
  const Soforthilfe({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Soforthilfe",
          style: thema.textTheme.displayLarge,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: thema.colorScheme.onPrimary),
      ),
      drawer: Seitenmenue(
        aktuelleSeite: "/soforthilfe",
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              "Noch keine Soforthilfe verfügbar",
              style: thema.textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
