import 'package:equatable/equatable.dart';

abstract class StopwatchEvent extends Equatable {
  const StopwatchEvent();

  @override
  List<Object?> get props => [];
}

class StartStopwatch extends StopwatchEvent {}

class StopStopwatch extends StopwatchEvent {}

class ResetStopwatch extends StopwatchEvent {}

class LapStopwatch extends StopwatchEvent {}

class StopwatchTick extends StopwatchEvent {
  final Duration elapsed;
  const StopwatchTick(this.elapsed);

  @override
  List<Object?> get props => [elapsed];
}
