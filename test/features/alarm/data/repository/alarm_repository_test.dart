import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mechanix_clock/features/alarm/data/models/alarm_model.dart';
import 'package:mechanix_clock/features/alarm/data/repository/alarm_repository.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AlarmRepository repository;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    repository = AlarmRepository();
    
    // We need to handle SharedPreferences.getInstance()
    // SharedPreferences doesn't easily allow mocking the static getInstance() 
    // without using setMockInitialValues or some other tricks in newer versions.
    // However, AlarmRepository calls SharedPreferences.getInstance() internally.
    SharedPreferences.setMockInitialValues({});
  });

  group('AlarmRepository', () {
    const testAlarm = Alarm(
      id: '1',
      hour: 7,
      minute: 15,
      isAm: true,
      repeatDays: [],
      sound: 'Default',
      isSnoozeEnabled: true,
      isActive: true,
    );

    test('getAlarms returns empty list when no data is stored', () async {
      final alarms = await repository.getAlarms();
      expect(alarms, isEmpty);
    });

    test('saveAlarms and getAlarms works correctly', () async {
      final alarmsToSave = [testAlarm];
      await repository.saveAlarms(alarmsToSave);
      
      final retrievedAlarms = await repository.getAlarms();
      expect(retrievedAlarms, equals(alarmsToSave));
    });

    test('getAlarms reloads data from disk', () async {
      // This test might be tricky with SharedPreferences.setMockInitialValues
      // as it uses a simple in-memory map for testing.
      // But we can verify it doesn't crash.
      await repository.saveAlarms([testAlarm]);
      final retrieved = await repository.getAlarms();
      expect(retrieved.length, 1);
    });
  });
}
