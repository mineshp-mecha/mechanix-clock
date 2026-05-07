import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_event.dart';
import 'package:mechanix_clock/features/alarm/data/repository/alarm_repository.dart';
import 'core/theme/app_theme.dart';
import 'features/alarm/bloc/alarm_bloc.dart';
import 'features/alarm/presentation/screens/alarm_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final alarmRepository = AlarmRepository();
  runApp(MechanixClockApp(repository: alarmRepository));
}

class MechanixClockApp extends StatelessWidget {
  final AlarmRepository repository;
  const MechanixClockApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlarmBloc(repository: repository)..add(LoadAlarms()),
      child: MaterialApp(
        title: 'Mechanix Clock',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AlarmListScreen(),
      ),
    );
  }
}
