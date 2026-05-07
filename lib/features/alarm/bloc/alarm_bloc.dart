import 'package:flutter_bloc/flutter_bloc.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';
import '../data/models/alarm_model.dart';
import '../data/repository/alarm_repository.dart';
import '../../../core/utils/system_alarm_service.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final AlarmRepository repository;
  final SystemAlarmService _systemAlarmService = SystemAlarmService();

  AlarmBloc({required this.repository}) : super(AlarmInitial()) {
    on<LoadAlarms>(_onLoadAlarms);
    on<AddAlarm>(_onAddAlarm);
    on<UpdateAlarm>(_onUpdateAlarm);
    on<DeleteAlarm>(_onDeleteAlarm);
    on<ToggleAlarm>(_onToggleAlarm);
  }

  Future<void> _onLoadAlarms(LoadAlarms event, Emitter<AlarmState> emit) async {
    emit(AlarmLoading());
    try {
      final alarms = await repository.getAlarms();
      print("alarms: $alarms");
      emit(AlarmLoaded(alarms));
    } catch (e) {
      emit(const AlarmError('Failed to load alarms'));
    }
  }

  Future<void> _onAddAlarm(AddAlarm event, Emitter<AlarmState> emit) async {
    if (state is AlarmLoaded) {
      final currentAlarms = (state as AlarmLoaded).alarms;
      final updatedAlarms = List<Alarm>.from(currentAlarms)..add(event.alarm);
      try {
        await repository.saveAlarms(updatedAlarms);
        if (event.alarm.isActive) {
          await _scheduleSystemAlarm(event.alarm);
        }
        emit(AlarmLoaded(updatedAlarms));
      } catch (e) {
        print('Failed to save alarms: $e');
      }
    }
  }

  Future<void> _onUpdateAlarm(
    UpdateAlarm event,
    Emitter<AlarmState> emit,
  ) async {
    if (state is AlarmLoaded) {
      final currentAlarms = (state as AlarmLoaded).alarms;
      final updatedAlarms = currentAlarms.map((a) {
        return a.id == event.alarm.id ? event.alarm : a;
      }).toList();
      await repository.saveAlarms(updatedAlarms);
      
      if (event.alarm.isActive) {
        await _scheduleSystemAlarm(event.alarm);
      } else {
        await _systemAlarmService.cancelAlarm(event.alarm.id);
      }
      
      emit(AlarmLoaded(updatedAlarms));
    }
  }

  Future<void> _onDeleteAlarm(
    DeleteAlarm event,
    Emitter<AlarmState> emit,
  ) async {
    if (state is AlarmLoaded) {
      final currentAlarms = (state as AlarmLoaded).alarms;
      final updatedAlarms = currentAlarms
          .where((a) => a.id != event.alarmId)
          .toList();
      await repository.saveAlarms(updatedAlarms);
      await _systemAlarmService.cancelAlarm(event.alarmId);
      emit(AlarmLoaded(updatedAlarms));
    }
  }

  Future<void> _onToggleAlarm(
    ToggleAlarm event,
    Emitter<AlarmState> emit,
  ) async {
    if (state is AlarmLoaded) {
      final currentAlarms = (state as AlarmLoaded).alarms;
      Alarm? toggledAlarm;
      final updatedAlarms = currentAlarms.map((a) {
        if (a.id == event.alarmId) {
          toggledAlarm = a.copyWith(isActive: !a.isActive);
          return toggledAlarm!;
        }
        return a;
      }).toList();
      
      await repository.saveAlarms(updatedAlarms);
      
      if (toggledAlarm != null) {
        if (toggledAlarm!.isActive) {
          await _scheduleSystemAlarm(toggledAlarm!);
        } else {
          await _systemAlarmService.cancelAlarm(toggledAlarm!.id);
        }
      }
      
      emit(AlarmLoaded(updatedAlarms));
    }
  }

  Future<void> _scheduleSystemAlarm(Alarm alarm) async {
    final now = DateTime.now();
    int hour = alarm.hour;
    if (!alarm.isAm && hour < 12) hour += 12;
    if (alarm.isAm && hour == 12) hour = 0;

    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      alarm.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _systemAlarmService.setAlarm(alarm.id, scheduledTime);
  }
}
