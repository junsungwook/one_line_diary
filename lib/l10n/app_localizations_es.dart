import 'app_localizations.dart';

// ignore_for_file: type=lint

class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Una Línea';

  @override
  String get tagline => 'Termina tu día con una línea';

  @override
  String get today => 'Hoy';

  @override
  String get write => 'Escribir';

  @override
  String get hint => '¿Cómo fue tu día?';

  @override
  String get placeholder => 'Escribe tu día en una línea...';

  @override
  String get streak => 'Racha';

  @override
  String streakDays(int days) {
    return '$days días';
  }

  @override
  String get calendar => 'Calendario';

  @override
  String get entries => 'Entradas';

  @override
  String get noEntryYet => 'Aún no hay entrada';

  @override
  String get writeFirstLine => '¡Escribe tu primera línea!';

  @override
  String get saved => '¡Guardado!';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';
}
