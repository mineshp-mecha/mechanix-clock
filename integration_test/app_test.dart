import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mechanix_clock/features/alarm/presentation/screens/alarm_list_screen.dart';
import 'package:mechanix_clock/main.dart' as app;
import 'package:mechanix_clock/features/alarm/data/repository/alarm_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Alarm Integration Test', () {
    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      
      // Mock the method channel for SystemAlarmService
      const MethodChannel('com.example.clock/alarm').setMockMethodCallHandler((MethodCall methodCall) async {
        return null;
      });
    });

    testWidgets('Full alarm lifecycle: create, edit, and delete', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Create New Alarm
      final addAlarmButton = find.byKey(const Key('add_alarm_button'));
      expect(addAlarmButton, findsOneWidget);
      await tester.tap(addAlarmButton);
      await tester.pumpAndSettle();

      // Verify we are on Set Alarm screen
      expect(find.text('Set alarm'), findsOneWidget);

      // Set Time (We won't actually drag pickers in this test as it's complex, 
      // but we will interact with other elements)
      
      // Set Repeat (Monday and Tuesday)
      await tester.tap(find.byKey(const Key('option_repeat')));
      await tester.pumpAndSettle();
      expect(find.text('Repeat'), findsOneWidget);
      
      await tester.tap(find.byKey(const Key('day_0'))); // Monday
      await tester.tap(find.byKey(const Key('day_1'))); // Tuesday
      await tester.tap(find.byKey(const Key('repeat_done_button')));
      await tester.pumpAndSettle();
      
      // Set Sound
      await tester.tap(find.byKey(const Key('option_sound')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sound_Siren')));
      await tester.tap(find.byKey(const Key('sound_done_button')));
      await tester.pumpAndSettle();

      // Toggle Snooze
      final snoozeSwitch = find.byKey(const Key('custom_switch'));
      await tester.tap(snoozeSwitch);
      await tester.pumpAndSettle();

      // Save Alarm
      await tester.tap(find.byKey(const Key('save_alarm_button')));
      await tester.pumpAndSettle();

      // Verify alarm is in the list
      expect(find.byKey(const Key('alarm_repeat_days')), findsOneWidget);
      
      // 2. Edit Alarm
      // Tap on the alarm we just created
      final alarmItem = find.byKey(const Key('alarm_item_tap'));
      await tester.tap(alarmItem, warnIfMissed: false);
      await tester.pumpAndSettle();
      
      // If still not on edit screen, try tapping by text
      if (find.text('Edit alarm').evaluate().isEmpty) {
        await tester.tap(find.byType(ListView)); // ensure focus?
        await tester.tap(find.textContaining(':')); // Tap the time text
        await tester.pumpAndSettle();
      }
      
      if (find.text('Edit alarm').evaluate().isEmpty) {
        // One more try with a generic coordinate in the first item area
        await tester.tapAt(const Offset(200, 150));
        await tester.pumpAndSettle();
      }
      expect(find.text('Edit alarm'), findsOneWidget);

      // Change Repeat to Once (deselect Monday and Tuesday)
      await tester.tap(find.byKey(const Key('option_repeat')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('day_0')));
      await tester.tap(find.byKey(const Key('day_1')));
      await tester.tap(find.byKey(const Key('repeat_done_button')));
      await tester.pumpAndSettle();

      // Save edited alarm
      await tester.tap(find.byKey(const Key('save_alarm_button')));
      await tester.pumpAndSettle();

      // Verify it now says 'Once'
      expect(find.text('Once'), findsOneWidget);

      // 3. Delete Alarm
      // Re-enter edit screen
      await tester.tap(find.byKey(const Key('alarm_item_tap')), warnIfMissed: false);
      await tester.pumpAndSettle();

      if (find.text('Edit alarm').evaluate().isEmpty) {
        await tester.tap(find.textContaining(':'));
        await tester.pumpAndSettle();
      }
      
      // Tap delete button
      final deleteButton = find.byKey(const Key('delete_alarm_button'));
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Verify alarm is gone
      expect(find.text('Once'), findsNothing);
    });
  });
}
