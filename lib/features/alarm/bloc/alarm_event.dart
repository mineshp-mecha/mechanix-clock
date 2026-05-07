import 'package:equatable/equatable.dart';
import '../data/models/alarm_model.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlarms extends AlarmEvent {}

class AddAlarm extends AlarmEvent {
  final Alarm alarm;
  const AddAlarm(this.alarm);

  @override
  List<Object?> get props => [alarm];
}

class UpdateAlarm extends AlarmEvent {
  final Alarm alarm;
  const UpdateAlarm(this.alarm);

  @override
  List<Object?> get props => [alarm];
}

class DeleteAlarm extends AlarmEvent {
  final String alarmId;
  const DeleteAlarm(this.alarmId);

  @override
  List<Object?> get props => [alarmId];
}

class ToggleAlarm extends AlarmEvent {
  final String alarmId;
  const ToggleAlarm(this.alarmId);

  @override
  List<Object?> get props => [alarmId];
}
