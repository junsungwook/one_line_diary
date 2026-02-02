import 'app_localizations.dart';

// ignore_for_file: type=lint

class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Eine Zeile';

  @override
  String get tagline => 'Beende deinen Tag mit einer Zeile';

  @override
  String get today => 'Heute';

  @override
  String get write => 'Schreiben';

  @override
  String get hint => 'Wie war dein Tag?';

  @override
  String get placeholder => 'Schreibe deinen Tag in einer Zeile...';

  @override
  String get streak => 'Serie';

  @override
  String streakDays(int days) {
    return '$days Tage';
  }

  @override
  String get calendar => 'Kalender';

  @override
  String get entries => 'Einträge';

  @override
  String get noEntryYet => 'Noch kein Eintrag';

  @override
  String get writeFirstLine => 'Schreibe deine erste Zeile!';

  @override
  String get saved => 'Gespeichert!';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';
}
