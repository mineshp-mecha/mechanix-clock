import 'package:flutter/services.dart';
import 'package:mechanix_clock/core/utils/app_logger.dart';

class SystemAlarmService {
  static const _channel = MethodChannel('com.example.clock/alarm');

  Future<void> setAlarm(
    String id,
    DateTime time,
    List<int> repeatDays,
    bool isSnoozeEnabled,
  ) async {
    try {
      final int timestamp = time.millisecondsSinceEpoch;
      await _channel.invokeMethod('setAlarm', {
        'id': id,
        'timestamp': timestamp,
        'repeatDays': repeatDays,
        'isSnoozeEnabled': isSnoozeEnabled,
      });
      AppLogger.i('SystemAlarmService: Alarm set for $time (ID: $id)');
    } on PlatformException catch (e) {
      AppLogger.e('Failed to set alarm: $e');
    }
  }

  Future<void> cancelAlarm(String id) async {
    try {
      await _channel.invokeMethod('cancelAlarm', {'id': id});
      AppLogger.i('SystemAlarmService: Alarm cancelled (ID: $id)');
    } on PlatformException catch (e) {
      AppLogger.e('Failed to cancel alarm: $e');
    }
  }
}
