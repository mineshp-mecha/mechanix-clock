import 'package:flutter/services.dart';

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
      print('SystemAlarmService: Alarm set for $time (ID: $id)');
    } on PlatformException catch (e) {
      print("Failed to set alarm: ${e.message}");
    }
  }

  Future<void> cancelAlarm(String id) async {
    try {
      await _channel.invokeMethod('cancelAlarm', {'id': id});
      print('SystemAlarmService: Alarm cancelled (ID: $id)');
    } on PlatformException catch (e) {
      print("Failed to cancel alarm: ${e.message}");
    }
  }
}
