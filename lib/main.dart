import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_event.dart';
import 'package:mechanix_clock/features/alarm/data/repository/alarm_repository.dart';
import 'package:mechanix_clock/core/utils/system_alarm_service.dart';
import 'core/theme/app_theme.dart';
import 'features/alarm/bloc/alarm_bloc.dart';
import 'features/alarm/presentation/screens/alarm_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final alarmRepository = AlarmRepository();
  final systemAlarmService = SystemAlarmService();
  runApp(
    MechanixClockApp(
      repository: alarmRepository,
      systemAlarmService: systemAlarmService,
    ),
  );
}

class MechanixClockApp extends StatelessWidget {
  final AlarmRepository repository;
  final SystemAlarmService systemAlarmService;

  const MechanixClockApp({
    super.key,
    required this.repository,
    required this.systemAlarmService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlarmBloc(
        repository: repository,
        systemAlarmService: systemAlarmService,
      )..add(LoadAlarms()),
      child: MaterialApp(
        title: 'Mechanix Clock',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AlarmListScreen(),
      ),
    );
  }
}
