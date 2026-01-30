// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'One Line Diary';

  @override
  String get tagline => 'End your day with one line';

  @override
  String get today => 'Today';

  @override
  String get write => 'Write';

  @override
  String get hint => 'How was your day?';

  @override
  String get placeholder => 'Write your day in one line...';

  @override
  String get streak => 'Streak';

  @override
  String streakDays(int days) {
    return '$days days';
  }

  @override
  String get calendar => 'Calendar';

  @override
  String get entries => 'Entries';

  @override
  String get noEntryYet => 'No entry yet';

  @override
  String get writeFirstLine => 'Write your first line!';

  @override
  String get saved => 'Saved!';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';
}
