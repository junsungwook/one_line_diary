import 'package:flutter/foundation.dart';

class Log {
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[INFO] $message');
      if (error != null) print('[INFO] Error: $error');
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
