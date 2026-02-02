import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../bootstrap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/settings_service.dart';
import '../../../../shared/widgets/dark_mode_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
            child: Padding(
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
                        l10n.localeName == 'ko' ? '설정' : 'Settings',
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
                    l10n.localeName == 'ko' ? '색상 테마' : 'Color Theme',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildThemeOptions(context, l10n, settings, isDark, themeColors),
                  const SizedBox(height: 28),

                  // Language Section
                  Text(
                    l10n.localeName == 'ko' ? '언어' : 'Language',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLanguageOptions(context, l10n, settings, isDark, themeColors),
                  const SizedBox(height: 28),

                  // Notification Section
                  Text(
                    l10n.localeName == 'ko' ? '알림' : 'Notification',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? themeColors.darkTextSecondary : themeColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationOptions(context, l10n, settings, isDark, themeColors),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOptions(
      BuildContext context, AppLocalizations l10n, SettingsService settings, bool isDark, ThemeColors themeColors) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? themeColors.darkSurface : themeColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildLanguageOption(
            context: context,
            title: l10n.localeName == 'ko' ? '시스템 설정' : 'System Default',
            isSelected: settings.isSystemDefault,
            onTap: () => settings.setLocale(null),
            isFirst: true,
            isDark: isDark,
            themeColors: themeColors,
          ),
          _buildDivider(isDark, themeColors),
          _buildLanguageOption(
            context: context,
            title: '한국어',
            isSelected: settings.isKorean,
            onTap: () => settings.setLocale(const Locale('ko')),
            isDark: isDark,
            themeColors: themeColors,
          ),
          _buildDivider(isDark, themeColors),
          _buildLanguageOption(
            context: context,
            title: 'English',
            isSelected: settings.isEnglish,
            onTap: () => settings.setLocale(const Locale('en')),
            isLast: true,
            isDark: isDark,
            themeColors: themeColors,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required ThemeColors themeColors,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: isFirst ? const Radius.circular(16) : Radius.zero,
            bottom: isLast ? const Radius.circular(16) : Radius.zero,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_rounded,
                size: 22,
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
                    l10n.localeName == 'ko' ? '일기 알림' : 'Diary Reminder',
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
                        l10n.localeName == 'ko' ? '알림 시간' : 'Notification Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(settings.notificationTime, l10n),
                      style: TextStyle(
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
      // 알림 켜기
      await notificationService.requestPermission();
      await settings.setNotificationEnabled(true);
      _scheduleNotification(settings, l10n);
    } else {
      // 알림 끄기
      await settings.setNotificationEnabled(false);
      await notificationService.cancelAllNotifications();
    }
  }

  void _scheduleNotification(SettingsService settings, AppLocalizations l10n) {
    final streak = diaryService.calculateStreak();
    final daysSinceLastEntry = diaryService.getDaysSinceLastEntry();

    notificationService.scheduleDailyNotification(
      time: settings.notificationTime,
      isKorean: l10n.localeName == 'ko',
      currentStreak: streak,
      daysSinceLastEntry: daysSinceLastEntry,
    );
  }
}
