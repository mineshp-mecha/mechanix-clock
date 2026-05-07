import 'package:equatable/equatable.dart';

class Alarm extends Equatable {
  final String id;
  final int hour;
  final int minute;
  final bool isAm;
  final List<int> repeatDays;
  final String sound;
  final bool isSnoozeEnabled;
  final bool isActive;

  const Alarm({
    required this.id,
    required this.hour,
    required this.minute,
    required this.isAm,
    required this.repeatDays,
    required this.sound,
    required this.isSnoozeEnabled,
    this.isActive = true,
  });

  Alarm copyWith({
    String? id,
    int? hour,
    int? minute,
    bool? isAm,
    List<int>? repeatDays,
    String? sound,
    bool? isSnoozeEnabled,
    bool? isActive,
  }) {
    return Alarm(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isAm: isAm ?? this.isAm,
      repeatDays: repeatDays ?? this.repeatDays,
      sound: sound ?? this.sound,
      isSnoozeEnabled: isSnoozeEnabled ?? this.isSnoozeEnabled,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
      'isAm': isAm,
      'repeatDays': repeatDays,
      'sound': sound,
      'isSnoozeEnabled': isSnoozeEnabled,
      'isActive': isActive,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      hour: json['hour'],
      minute: json['minute'],
      isAm: json['isAm'],
      repeatDays: List<int>.from(json['repeatDays']),
      sound: json['sound'],
      isSnoozeEnabled: json['isSnoozeEnabled'],
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  List<Object?> get props => [
    id,
    hour,
    minute,
    isAm,
    repeatDays,
    sound,
    isSnoozeEnabled,
    isActive,
  ];
}
