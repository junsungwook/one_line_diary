import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../bootstrap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/settings_service.dart';
import '../../../../shared/widgets/dark_mode_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _languageExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, settings, _) {
        final l10n = AppLocalizations.of(context);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final themeColors = settings.currentThemeColors;

        return Scaffold(
          backgroundColor: isDark ? themeColors.darkBackground : themeColors.lightBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 22,
                          color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _getSettingsText(l10n.localeName),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                        ),
                      ),
                      const Spacer(),
                      const DarkModeButton(),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Color Theme Section
                  Text(
                    _getColorThemeText(l10n.localeName),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildThemeOptions(context, l10n, settings, isDark, themeColors),
                  const SizedBox(height: 28),

                  // Notification Section (moved up)
                  Text(
                    _getNotificationText(l10n.localeName),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationOptions(context, l10n, settings, isDark, themeColors),
                  const SizedBox(height: 28),

                  // Language Section (collapsible)
                  Text(
                    _getLanguageText(l10n.localeName),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLanguageSelector(context, l10n, settings, isDark, themeColors),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getSettingsText(String localeName) {
    switch (localeName) {
      case 'ko': return '설정';
      case 'ja': return '設定';
      case 'zh': return '設定';
      case 'es': return 'Ajustes';
      case 'de': return 'Einstellungen';
      default: return 'Settings';
    }
  }

  String _getColorThemeText(String localeName) {
    switch (localeName) {
      case 'ko': return '색상 테마';
      case 'ja': return 'カラーテーマ';
      case 'zh': return '顏色主題';
      case 'es': return 'Tema de color';
      case 'de': return 'Farbthema';
      default: return 'Color Theme';
    }
  }

  String _getNotificationText(String localeName) {
    switch (localeName) {
      case 'ko': return '알림';
      case 'ja': return '通知';
      case 'zh': return '通知';
      case 'es': return 'Notificación';
      case 'de': return 'Benachrichtigung';
      default: return 'Notification';
    }
  }

  String _getLanguageText(String localeName) {
    switch (localeName) {
      case 'ko': return '언어';
      case 'ja': return '言語';
      case 'zh': return '語言';
      case 'es': return 'Idioma';
      case 'de': return 'Sprache';
      default: return 'Language';
    }
  }

  String _getCurrentLanguageName(SettingsService settings) {
    if (settings.isSystemDefault) return _getSystemDefaultText(AppLocalizations.of(context).localeName);
    if (settings.isKorean) return '한국어';
    if (settings.isEnglish) return 'English';
    if (settings.isJapanese) return '日本語';
    if (settings.isChinese) return '繁體中文';
    if (settings.isSpanish) return 'Español';
    if (settings.isGerman) return 'Deutsch';
    return 'System Default';
  }

  Widget _buildLanguageSelector(
      BuildContext context, AppLocalizations l10n, SettingsService settings, bool isDark, ThemeColors themeColors) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? themeColors.darkSurface : themeColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 현재 선택된 언어 표시 (탭하면 펼침)
          GestureDetector(
            onTap: () => setState(() => _languageExpanded = !_languageExpanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _getCurrentLanguageName(settings),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    _languageExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 24,
                    color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                  ),
                ],
              ),
            ),
          ),
          // 펼쳐진 언어 목록
          if (_languageExpanded) ...[
            _buildDivider(isDark, themeColors),
            _buildLanguageOption(
              title: _getSystemDefaultText(l10n.localeName),
              isSelected: settings.isSystemDefault,
              onTap: () {
                settings.setLocale(null);
                setState(() => _languageExpanded = false);
              },
              isDark: isDark,
              themeColors: themeColors,
            ),
            _buildDivider(isDark, themeColors),
            _buildLanguageOption(
              title: '한국어',
              isSelected: settings.isKorean,
              onTap: () {
                settings.setLocale(const Locale('ko'));
                setState(() => _languageExpanded = false);
              },
              isDark: isDark,
              themeColors: themeColors,
            ),
            _buildDivider(isDark, themeColors),
            _buildLanguageOption(
              title: 'English',
              isSelected: settings.isEnglish,
              onTap: () {
                settings.setLocale(const Locale('en'));
                setState(() => _languageExpanded = false);
              },
              isDark: isDark,
              themeColors: themeColors,
            ),
            _buildDivider(isDark, themeColors),
            _buildLanguageOption(
              title: '日本語',
              isSelected: settings.isJapanese,
              onTap: () {
                settings.setLocale(const Locale('ja'));
                setState(() => _languageExpanded = false);
              },
              isDark: isDark,
              themeColors: themeColors,
            ),
            _buildDivider(isDark, themeColors),
            _buildLanguageOption(
              title: '繁體中文',
              isSelected: settings.isChinese,
              onTap: () {
                settings.setLocale(const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'));
                setState(() => _languageExpanded = false);
              },
              isDark: isDark,
              themeColors: themeColors,
            ),
            _buildDivider(isDark, themeColors),
            _buildLanguageOption(
              title: 'Español',
              isSelected: settings.isSpanish,
              onTap: () {
                settings.setLocale(const Locale('es'));
                setState(() => _languageExpanded = false);
              },
              isDark: isDark,
              themeColors: themeColors,
            ),
            _buildDivider(isDark, themeColors),
            _buildLanguageOption(
              title: 'Deutsch',
              isSelected: settings.isGerman,
              onTap: () {
                settings.setLocale(const Locale('de'));
                setState(() => _languageExpanded = false);
              },
              isDark: isDark,
              themeColors: themeColors,
              isLast: true,
            ),
          ],
        ],
      ),
    );
  }

  String _getSystemDefaultText(String localeName) {
    switch (localeName) {
      case 'ko': return '시스템 설정';
      case 'ja': return 'システム設定';
      case 'zh': return '系統設定';
      case 'es': return 'Predeterminado';
      case 'de': return 'Systemstandard';
      default: return 'System Default';
    }
  }

  Widget _buildLanguageOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required ThemeColors themeColors,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: isLast ? const Radius.circular(16) : Radius.zero,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_rounded,
                size: 20,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark, ThemeColors themeColors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        color: isDark ? themeColors.darkBackground : themeColors.lightBackground,
      ),
    );
  }

  Widget _buildThemeOptions(
      BuildContext context, AppLocalizations l10n, SettingsService settings, bool isDark, ThemeColors currentThemeColors) {
    return Row(
      children: ColorTheme.values.map((theme) {
        final previewColors = AppColors.themeColors[theme]!;
        final isSelected = settings.colorTheme == theme;
        return Expanded(
          child: GestureDetector(
            onTap: () => settings.setColorTheme(theme),
            child: Container(
              margin: EdgeInsets.only(
                right: theme != ColorTheme.cloudSmog ? 8 : 0,
              ),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                        color: isDark ? currentThemeColors.darkTextPrimary : currentThemeColors.lightTextPrimary,
                        width: 2,
                      )
                    : Border.all(
                        color: isDark ? currentThemeColors.darkSurface : currentThemeColors.lightSurface,
                        width: 2,
                      ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: previewColors.lightBackground,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: previewColors.darkBackground,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getThemeName(theme, l10n),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? currentThemeColors.darkTextPrimary : currentThemeColors.lightTextPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getThemeName(ColorTheme theme, AppLocalizations l10n) {
    switch (theme) {
      case ColorTheme.milkGrayBlue:
        return l10n.localeName == 'ko' ? '밀크 & 그레이블루' : 'Milk & Blue';
      case ColorTheme.plumMilk:
        return l10n.localeName == 'ko' ? '플럼 & 밀크' : 'Plum & Milk';
      case ColorTheme.cloudSmog:
        return l10n.localeName == 'ko' ? '클라우드 & 스모그' : 'Cloud & Smog';
    }
  }

  Widget _buildNotificationOptions(
      BuildContext context, AppLocalizations l10n, SettingsService settings, bool isDark, ThemeColors themeColors) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? themeColors.darkSurface : themeColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 알림 토글
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _getDiaryReminderText(l10n.localeName),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: settings.notificationEnabled,
                  onChanged: (value) {
                    _handleNotificationToggle(value, settings, l10n);
                  },
                  activeTrackColor: AppColors.primary,
                ),
              ],
            ),
          ),
          if (settings.notificationEnabled) ...[
            _buildDivider(isDark, themeColors),
            // 알림 시간 설정
            GestureDetector(
              onTap: () => _showTimePicker(context, settings, l10n),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _getNotificationTimeText(l10n.localeName),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(settings.notificationTime, l10n),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getDiaryReminderText(String localeName) {
    switch (localeName) {
      case 'ko': return '일기 알림';
      case 'ja': return '日記リマインダー';
      case 'zh': return '日記提醒';
      case 'es': return 'Recordatorio';
      case 'de': return 'Tagebuch-Erinnerung';
      default: return 'Diary Reminder';
    }
  }

  String _getNotificationTimeText(String localeName) {
    switch (localeName) {
      case 'ko': return '알림 시간';
      case 'ja': return '通知時間';
      case 'zh': return '通知時間';
      case 'es': return 'Hora';
      case 'de': return 'Uhrzeit';
      default: return 'Time';
    }
  }

  String _formatTime(TimeOfDay time, AppLocalizations l10n) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');

    if (l10n.localeName == 'ko') {
      if (hour < 12) {
        return '오전 ${hour == 0 ? 12 : hour}:$minute';
      } else {
        return '오후 ${hour == 12 ? 12 : hour - 12}:$minute';
      }
    }

    final amPm = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:$minute $amPm';
  }

  Future<void> _showTimePicker(BuildContext context, SettingsService settings, AppLocalizations l10n) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: settings.notificationTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      await settings.setNotificationTime(picked);
      _scheduleNotification(settings, l10n);
    }
  }

  Future<void> _handleNotificationToggle(bool value, SettingsService settings, AppLocalizations l10n) async {
    if (value) {
      await notificationService.requestPermission();
      await settings.setNotificationEnabled(true);
      _scheduleNotification(settings, l10n);
    } else {
      await settings.setNotificationEnabled(false);
      await notificationService.cancelAllNotifications();
    }
  }

  void _scheduleNotification(SettingsService settings, AppLocalizations l10n) {
    notificationService.scheduleDailyNotification(
      time: settings.notificationTime,
      languageCode: l10n.localeName,
    );
  }
}
