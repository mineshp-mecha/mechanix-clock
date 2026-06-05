import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_clock/core/theme/app_theme.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_bloc.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_event.dart';
import 'package:mechanix_clock/features/alarm/data/models/alarm_model.dart';

class AlarmBottomBar extends StatelessWidget {
  final Alarm? alarm;
  final int selectedHour;
  final int selectedMinute;
  final bool isAm;
  final dynamic
  repeatDays; // Adjust the type (e.g., List<int>, Set<int>) to match your Alarm model
  final dynamic
  sound; // Adjust the type (e.g., String, AudioFile) to match your Alarm model
  final bool isSnoozeEnabled;

  const AlarmBottomBar({
    super.key,
    this.alarm,
    required this.selectedHour,
    required this.selectedMinute,
    required this.isAm,
    required this.repeatDays,
    required this.sound,
    required this.isSnoozeEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (alarm != null)
            IconButton(
              key: const Key('delete_alarm_button'),
              icon: const Icon(Icons.delete_outline, color: AppColors.textDim),
              onPressed: () {
                context.read<AlarmBloc>().add(DeleteAlarm(alarm!.id));
                Navigator.pop(context);
              },
            )
          else
            const SizedBox(width: 44),
          IconButton(
            key: const Key('save_alarm_button'),
            icon: const Icon(Icons.check, color: AppColors.textPrimary),
            onPressed: () {
              final newAlarm = Alarm(
                id:
                    alarm?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                hour: selectedHour,
                minute: selectedMinute,
                isAm: isAm,
                repeatDays: repeatDays,
                sound: sound,
                isSnoozeEnabled: isSnoozeEnabled,
              );

              if (alarm == null) {
                context.read<AlarmBloc>().add(AddAlarm(newAlarm));
              } else {
                context.read<AlarmBloc>().add(UpdateAlarm(newAlarm));
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
