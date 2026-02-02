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
    '오늘의 한 줄을 남겨보세요',
    '하루 끝, 한 줄로 정리해볼까요?',
    '오늘 가장 기억에 남는 순간은?',
    '30초면 충분해요, 오늘을 기록하세요',
    '내일의 나에게 오늘을 전해주세요',
    '작은 기록이 큰 추억이 됩니다',
    '오늘을 한 문장으로 표현한다면?',
    '잠들기 전, 오늘을 돌아보세요',
    '하루를 마무리하는 가장 좋은 방법',
  ];

  // 영어 멘트
  static const List<String> _messagesEnDaily = [
    'How was your day?',
    'Leave a line about today',
    'End of day, sum it up in one line?',
    'Most memorable moment today?',
    '30 seconds is all you need',
    'Tell tomorrow\'s you about today',
    'Small records become big memories',
    'Describe today in one sentence?',
    'Before you sleep, look back on today',
    'The best way to end your day',
  ];

  // 일본어 멘트
  static const List<String> _messagesJaDaily = [
    '今日はどんな一日でしたか？',
    '今日の一行を残しましょう',
    '一日の終わり、一行でまとめてみませんか？',
    '今日一番印象に残った瞬間は？',
    '30秒で十分、今日を記録しましょう',
    '明日の自分に今日を伝えましょう',
    '小さな記録が大きな思い出になります',
    '今日を一文で表すなら？',
    '眠る前に今日を振り返りましょう',
    '一日を締めくくる最良の方法',
  ];

  // 중국어(번체) 멘트
  static const List<String> _messagesZhDaily = [
    '今天過得怎麼樣？',
    '留下今天的一行字吧',
    '一天結束，用一行字總結吧？',
    '今天最難忘的時刻是？',
    '30秒就夠了，記錄今天吧',
    '告訴明天的自己今天發生了什麼',
    '小小的記錄會成為珍貴的回憶',
    '用一句話描述今天？',
    '睡前回顧一下今天吧',
    '結束一天的最好方式',
  ];

  // 스페인어 멘트
  static const List<String> _messagesEsDaily = [
    '¿Cómo fue tu día?',
    'Deja una línea sobre hoy',
    'Fin del día, ¿lo resumes en una línea?',
    '¿El momento más memorable de hoy?',
    '30 segundos es todo lo que necesitas',
    'Cuéntale a tu yo de mañana sobre hoy',
    'Pequeños registros se convierten en grandes recuerdos',
    '¿Describe hoy en una frase?',
    'Antes de dormir, reflexiona sobre hoy',
    'La mejor manera de terminar tu día',
  ];

  // 독일어 멘트
  static const List<String> _messagesDeDaily = [
    'Wie war dein Tag?',
    'Hinterlasse eine Zeile über heute',
    'Tagesende, fass es in einer Zeile zusammen?',
    'Der unvergesslichste Moment heute?',
    '30 Sekunden reichen aus',
    'Erzähl deinem morgigen Ich von heute',
    'Kleine Aufzeichnungen werden große Erinnerungen',
    'Beschreibe heute in einem Satz?',
    'Vor dem Schlafen, denk an heute zurück',
    'Der beste Weg, deinen Tag zu beenden',
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
    try {
      final status = await Permission.notification.request();
      return status.isGranted || status.isLimited;
    } catch (e) {
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

  String getRandomMessage({required String languageCode}) {
    List<String> messages;

    switch (languageCode) {
      case 'ko':
        messages = _messagesKoDaily;
        break;
      case 'ja':
        messages = _messagesJaDaily;
        break;
      case 'zh':
        messages = _messagesZhDaily;
        break;
      case 'es':
        messages = _messagesEsDaily;
        break;
      case 'de':
        messages = _messagesDeDaily;
        break;
      default:
        messages = _messagesEnDaily;
    }

    return messages[_random.nextInt(messages.length)];
  }

  Future<void> scheduleDailyNotification({
    required TimeOfDay time,
    required String languageCode,
  }) async {
    await cancelAllNotifications();

    final message = getRandomMessage(languageCode: languageCode);

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

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
