import 'package:flutter/foundation.dart';

class Log {
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[DEBUG] $message');
      if (error != null) print('[DEBUG] Error: $error');
    }
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[INFO] $message');
      if (error != null) print('[INFO] Error: $error');
    }
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[WARN] $message');
      if (error != null) print('[WARN] Error: $error');
    }
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[ERROR] $message');
      if (error != null) print('[ERROR] Error: $error');
      if (stackTrace != null) print(stackTrace);
    }
  }
}
