import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Use standard import
import '../models/alarm_model.dart';

class AlarmRepository {
  static const String _storageKey = 'alarms_list';

  Future<List<Alarm>> getAlarms() async {
    try {
      // Use getInstance() to get the managed singleton
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // reload() ensures we have the latest data from disk on eLinux
      await prefs.reload();

      final String? alarmsJson = prefs.getString(_storageKey);

      if (alarmsJson == null || alarmsJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(alarmsJson);
      return decoded.map((item) => Alarm.fromJson(item)).toList();
    } catch (e) {
      print('Failed to load alarms: $e');
      return [];
    }
  }

  Future<void> saveAlarms(List<Alarm> alarms) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(alarms.map((a) => a.toJson()).toList());

      // setString returns a bool indicating success
      bool success = await prefs.setString(_storageKey, encoded);

      if (success) {
        print('on_save: Successfully saved encoded data');
      } else {
        print('on_save: Failed to write to disk');
      }
    } catch (e) {
      print('Failed to save alarms: $e');
    }
  }
}
