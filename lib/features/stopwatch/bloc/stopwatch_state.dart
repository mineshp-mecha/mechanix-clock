import 'package:equatable/equatable.dart';
import '../data/models/lap_time_model.dart';

enum StopwatchStatus { initial, running, stopped }

class StopwatchState extends Equatable {
  final StopwatchStatus status;
  final Duration elapsed;
  final List<LapTime> laps;

  const StopwatchState({
    this.status = StopwatchStatus.initial,
    this.elapsed = Duration.zero,
    this.laps = const [],
  });

  StopwatchState copyWith({
    StopwatchStatus? status,
    Duration? elapsed,
    List<LapTime>? laps,
  }) {
    return StopwatchState(
      status: status ?? this.status,
      elapsed: elapsed ?? this.elapsed,
      laps: laps ?? this.laps,
    );
  }

  @override
  List<Object?> get props => [status, elapsed, laps];
}
