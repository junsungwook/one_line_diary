import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/theme/app_colors.dart';

class SettingsService extends ChangeNotifier {
  static const _boxName = 'settings';
  static const _localeKey = 'locale';
  static const _darkModeKey = 'darkMode';
  static const _colorThemeKey = 'colorTheme';

  late Box _box;
  Locale? _locale;
  bool _isDarkMode = false;
  ColorTheme _colorTheme = ColorTheme.milkGrayBlue;

  Locale? get locale => _locale;
  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  ColorTheme get colorTheme => _colorTheme;
  ThemeColors get currentThemeColors => AppColors.themeColors[_colorTheme]!;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    final savedLocale = _box.get(_localeKey);
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }
    _isDarkMode = _box.get(_darkModeKey, defaultValue: false);
    final savedTheme = _box.get(_colorThemeKey, defaultValue: 0);
    _colorTheme = ColorTheme.values[savedTheme];
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    if (locale != null) {
      await _box.put(_localeKey, locale.languageCode);
    } else {
      await _box.delete(_localeKey);
    }
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _box.put(_darkModeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setColorTheme(ColorTheme theme) async {
    _colorTheme = theme;
    await _box.put(_colorThemeKey, theme.index);
    notifyListeners();
  }

  bool get isKorean => _locale?.languageCode == 'ko';
  bool get isEnglish => _locale?.languageCode == 'en';
  bool get isSystemDefault => _locale == null;
}
