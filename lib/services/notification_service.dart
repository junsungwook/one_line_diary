import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final Random _random = Random();

  // 한국어 멘트
  static const List<String> _messagesKoDaily = [
    '오늘 하루는 어땠나요?',
    '오늘의 한 줄을 남겨보세요 ✍️',
    '하루 끝, 한 줄로 정리해볼까요?',
    '오늘 가장 기억에 남는 순간은?',
    '30초면 충분해요, 오늘을 기록하세요',
    '내일의 나에게 오늘을 전해주세요',
    '작은 기록이 큰 추억이 됩니다',
    '오늘을 한 문장으로 표현한다면?',
    '잠들기 전, 오늘을 돌아보세요',
    '오늘의 마지막 할 일: 한 줄 기록',
    '하루를 마무리하는 가장 좋은 방법 ✨',
    '오늘 하루도 수고했어요, 기록해볼까요?',
    '당신의 오늘이 궁금해요',
    '한 줄이면 충분해요',
    '오늘을 기억하고 싶다면, 지금 기록하세요',
  ];

  static const List<String> _messagesKoStreakActive = [
    '🔥 연속 기록 중! 오늘도 이어가세요',
    '대단해요! 연속 기록을 이어가볼까요?',
    '꾸준함이 만드는 기적, 오늘도 한 줄 ✨',
    '연속 기록이 쌓이고 있어요!',
    '오늘도 한 줄, 습관이 되어가고 있어요',
  ];

  static const List<String> _messagesKoStreakWarning = [
    '⚠️ 연속 기록이 끊기기 전에! 오늘 기록하세요',
    '아직 늦지 않았어요, 지금 기록하세요',
    '연속 기록을 지켜주세요!',
    '오늘 기록해야 연속 기록이 유지돼요!',
    '몇 초면 연속 기록을 지킬 수 있어요 🔥',
  ];

  static const List<String> _messagesKoReturning = [
    '오랜만이에요! 다시 시작해볼까요?',
    '다시 돌아오셨군요 👋 오늘부터 새롭게!',
    '새로운 시작, 한 줄부터',
    '반가워요, 오늘 하루를 기록해보세요',
    '언제든 다시 시작할 수 있어요 ✨',
  ];

  // 영어 멘트
  static const List<String> _messagesEnDaily = [
    'How was your day?',
    'Leave a line about today ✍️',
    'End of day, sum it up in one line?',
    'Most memorable moment today?',
    '30 seconds is all you need, record today',
    'Tell tomorrow\'s you about today',
    'Small records become big memories',
    'If you could describe today in one sentence?',
    'Before you sleep, look back on today',
    'Last thing to do today: one line',
    'The best way to end your day ✨',
    'You did great today, want to write about it?',
    'Tell me about your day',
    'One line is enough',
    'If you want to remember today, write it now',
  ];

  static const List<String> _messagesEnStreakActive = [
    '🔥 Streak going! Keep it up today',
    'Amazing! Want to continue your streak?',
    'Consistency creates magic, one line today ✨',
    'Your streak is growing!',
    'Another day, another line, building habits',
  ];

  static const List<String> _messagesEnStreakWarning = [
    '⚠️ Don\'t break your streak! Write today',
    'It\'s not too late, record now',
    'Protect your streak!',
    'Write today to keep your streak alive!',
    'Just a few seconds to save your streak 🔥',
  ];

  static const List<String> _messagesEnReturning = [
    'Long time no see! Ready to start again?',
    'Welcome back 👋 Start fresh today!',
    'New beginning, starting with one line',
    'Good to see you again, record your day',
    'You can always start again ✨',
  ];

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // 알림 탭 시 앱 열기
      },
    );
  }

  Future<bool> requestPermission() async {
    // iOS에서는 flutter_local_notifications 초기화 시 권한 요청됨
    // Android 13+에서는 별도 권한 요청 필요
    try {
      final status = await Permission.notification.request();
      return status.isGranted || status.isLimited;
    } catch (e) {
      // 시뮬레이터 등에서 에러 발생 시 true 반환
      return true;
    }
  }

  Future<bool> hasPermission() async {
    try {
      final status = await Permission.notification.status;
      return status.isGranted || status.isLimited;
    } catch (e) {
      return true;
    }
  }

  String getRandomMessage({
    required bool isKorean,
    required int currentStreak,
    required int daysSinceLastEntry,
  }) {
    List<String> messages;

    if (daysSinceLastEntry > 7) {
      // 7일 이상 미기록 - 복귀 유저
      messages = isKorean ? _messagesKoReturning : _messagesEnReturning;
    } else if (currentStreak > 0 && daysSinceLastEntry == 0) {
      // 연속 기록 중이고 오늘 기록함
      messages = isKorean ? _messagesKoStreakActive : _messagesEnStreakActive;
    } else if (currentStreak > 0 && daysSinceLastEntry == 1) {
      // 연속 기록 중인데 오늘 아직 미기록
      messages = isKorean ? _messagesKoStreakWarning : _messagesEnStreakWarning;
    } else {
      // 일반
      messages = isKorean ? _messagesKoDaily : _messagesEnDaily;
    }

    return messages[_random.nextInt(messages.length)];
  }

  Future<void> scheduleDailyNotification({
    required TimeOfDay time,
    required bool isKorean,
    required int currentStreak,
    required int daysSinceLastEntry,
  }) async {
    await cancelAllNotifications();

    final message = getRandomMessage(
      isKorean: isKorean,
      currentStreak: currentStreak,
      daysSinceLastEntry: daysSinceLastEntry,
    );

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // 이미 지난 시간이면 내일로 설정
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder',
      'Daily Reminder',
      channelDescription: 'Daily diary reminder notification',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      0,
      'one line',
      message,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
