import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/settings_service.dart';

class DarkModeButton extends StatelessWidget {
  const DarkModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = context.watch<SettingsService>().currentThemeColors;

    return GestureDetector(
      onTap: () => context.read<SettingsService>().toggleDarkMode(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? themeColors.darkSurface : themeColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          size: 20,
          color: isDark ? themeColors.darkTextPrimary : themeColors.lightTextSecondary,
        ),
      ),
    );
  }
}
