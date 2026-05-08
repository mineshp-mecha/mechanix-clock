import 'package:flutter_test/flutter_test.dart';
import 'package:mechanix_clock/features/alarm/data/models/alarm_model.dart';

void main() {
  group('AlarmModel', () {
    const testAlarm = Alarm(
      id: '1',
      hour: 7,
      minute: 15,
      isAm: true,
      repeatDays: [0, 1],
      sound: 'Default',
      isSnoozeEnabled: true,
      isActive: true,
    );

    test('should support value equality', () {
      expect(
        testAlarm,
        const Alarm(
          id: '1',
          hour: 7,
          minute: 15,
          isAm: true,
          repeatDays: [0, 1],
          sound: 'Default',
          isSnoozeEnabled: true,
          isActive: true,
        ),
      );
    });

    test('copyWith works correctly', () {
      final updatedAlarm = testAlarm.copyWith(hour: 8, isActive: false);
      expect(updatedAlarm.hour, 8);
      expect(updatedAlarm.isActive, false);
      expect(updatedAlarm.id, testAlarm.id);
      expect(updatedAlarm.minute, testAlarm.minute);
    });

    test('toJson and fromJson work correctly', () {
      final json = testAlarm.toJson();
      final fromJson = Alarm.fromJson(json);
      expect(fromJson, testAlarm);
    });
  });
}
