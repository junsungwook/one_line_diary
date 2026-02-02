import 'dart:io';
import 'package:flutter/services.dart';

class WidgetService {
  static const _channel = MethodChannel('com.jundev.oneline/widget');

  /// 위젯 데이터 업데이트
  Future<void> updateWidgetData({
    required bool hasWrittenToday,
    required int currentStreak,
    String? lastEntryContent,
  }) async {
    if (!Platform.isIOS && !Platform.isAndroid) return;

    try {
      await _channel.invokeMethod('updateWidgetData', {
        'hasWrittenToday': hasWrittenToday,
        'currentStreak': currentStreak,
        'lastEntryContent': lastEntryContent,
      });
    } catch (e) {
      // 위젯 업데이트 실패해도 앱은 정상 동작
      print('Widget update failed: $e');
    }
  }

  /// 위젯 새로고침 요청
  Future<void> reloadWidget() async {
    if (!Platform.isIOS && !Platform.isAndroid) return;

    try {
      await _channel.invokeMethod('reloadWidget');
    } catch (e) {
      print('Widget reload failed: $e');
    }
  }
}

final widgetService = WidgetService();
