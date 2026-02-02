import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/utils/logger.dart';
import 'services/diary_service.dart';
import 'services/settings_service.dart';
import 'services/notification_service.dart';

final diaryService = DiaryService();
final settingsService = SettingsService();
final notificationService = NotificationService();

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flutter 에러 핸들링
  FlutterError.onError = (details) {
    Log.e('Flutter Error', details.exception, details.stack);
  };

  // 비동기 에러 핸들링
  PlatformDispatcher.instance.onError = (error, stack) {
    Log.e('Platform Error', error, stack);
    return true;
  };

  // Hive 초기화
  await Hive.initFlutter();
  await diaryService.init();
  await settingsService.init();

  // 알림 서비스 초기화
  await notificationService.initialize();

  Log.i('Hive & Services initialized');

  runApp(await builder());
}
