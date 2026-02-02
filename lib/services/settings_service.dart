import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/theme/app_colors.dart';

class SettingsService extends ChangeNotifier {
  static const _boxName = 'settings';
  static const _localeKey = 'locale';
  static const _darkModeKey = 'darkMode';
  static const _colorThemeKey = 'colorTheme';
  static const _notificationEnabledKey = 'notificationEnabled';
  static const _notificationHourKey = 'notificationHour';
  static const _notificationMinuteKey = 'notificationMinute';

  late Box _box;
  Locale? _locale;
  bool _isDarkMode = false;
  ColorTheme _colorTheme = ColorTheme.milkGrayBlue;
  bool _notificationEnabled = false;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 21, minute: 0); // 기본 오후 9시

  Locale? get locale => _locale;
  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  ColorTheme get colorTheme => _colorTheme;
  ThemeColors get currentThemeColors => AppColors.themeColors[_colorTheme]!;
  bool get notificationEnabled => _notificationEnabled;
  TimeOfDay get notificationTime => _notificationTime;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    final savedLocale = _box.get(_localeKey);
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }
    _isDarkMode = _box.get(_darkModeKey, defaultValue: false);
    final savedTheme = _box.get(_colorThemeKey, defaultValue: 0);
    _colorTheme = ColorTheme.values[savedTheme];
    _notificationEnabled = _box.get(_notificationEnabledKey, defaultValue: false);
    final hour = _box.get(_notificationHourKey, defaultValue: 21);
    final minute = _box.get(_notificationMinuteKey, defaultValue: 0);
    _notificationTime = TimeOfDay(hour: hour, minute: minute);
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
  bool get isJapanese => _locale?.languageCode == 'ja';
  bool get isChinese => _locale?.languageCode == 'zh';
  bool get isSpanish => _locale?.languageCode == 'es';
  bool get isGerman => _locale?.languageCode == 'de';
  bool get isSystemDefault => _locale == null;

  Future<void> setNotificationEnabled(bool enabled) async {
    _notificationEnabled = enabled;
    await _box.put(_notificationEnabledKey, enabled);
    notifyListeners();
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    _notificationTime = time;
    await _box.put(_notificationHourKey, time.hour);
    await _box.put(_notificationMinuteKey, time.minute);
    notifyListeners();
  }
}
