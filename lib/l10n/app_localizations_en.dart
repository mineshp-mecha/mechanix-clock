// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get alarms => 'Alarms';

  @override
  String get stopwatch => 'Stopwatch';

  @override
  String get lap => 'Lap';

  @override
  String get reset => 'Reset';

  @override
  String get mechanix_clock => 'Mechanix Clock';

  @override
  String get edit_alarms => 'Edit Alarms';

  @override
  String get no_alarms => 'No Alarms';

  @override
  String get once => 'Once';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get set_alarm => 'Set alarm';

  @override
  String get edit_alarm => 'Edit alarm';

  @override
  String get repeat => 'Repeat';

  @override
  String get sound => 'Sound';

  @override
  String get snooze => 'Snooze';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get monday_abbr => 'M';

  @override
  String get tuesday_abbr => 'T';

  @override
  String get wednesday_abbr => 'W';

  @override
  String get thursday_abbr => 'T';

  @override
  String get friday_abbr => 'F';

  @override
  String get saturday_abbr => 'S';

  @override
  String get sunday_abbr => 'S';

  @override
  String lap_number(int number) {
    return 'Lap $number';
  }

  @override
  String get stop => 'Stop';

  @override
  String get start => 'Start';

  @override
  String get timer_coming_soon => 'Timer - Coming Soon';

  @override
  String get world_clock_coming_soon => 'World Clock - Coming Soon';
}
