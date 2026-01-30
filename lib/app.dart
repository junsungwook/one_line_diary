import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'bootstrap.dart';
import 'services/settings_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: settingsService,
      child: Consumer<SettingsService>(
        builder: (context, settings, _) {
          return MaterialApp.router(
            title: '한 줄 기록',
            debugShowCheckedModeBanner: false,

            // Theme
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,

            // Localization
            locale: settings.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,

            // Router
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
