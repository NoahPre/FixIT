# Provider Erklärung
Wir benutzen Provider für unser State Management. Da jeder **ChangeNotifier** nur für ein oder zwei **Listeners** ausgelegt ist, haben wir uns auf die folgenden Provider geeinigt.

Folgende Provider:
- anmeldungProvider: wird von den Widgets Registrierung und Seitenmenue verwendet
- fehlerlisteProvider: wird von den Widgets Fehlerliste und FehlermeldungVorlage verwendet