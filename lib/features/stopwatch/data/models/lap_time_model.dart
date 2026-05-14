import 'package:equatable/equatable.dart';

class LapTime extends Equatable {
  final int lapNumber;
  final Duration duration;
  final Duration totalTime;

  const LapTime({
    required this.lapNumber,
    required this.duration,
    required this.totalTime,
  });

  @override
  List<Object?> get props => [lapNumber, duration, totalTime];
}
