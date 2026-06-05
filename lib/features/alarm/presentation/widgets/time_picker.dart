import 'package:flutter/material.dart';
import 'package:mechanix_clock/features/alarm/presentation/widgets/am_pm_picker.dart';
import 'package:mechanix_clock/features/alarm/presentation/widgets/time_picker_column.dart';

class CustomTimePicker extends StatelessWidget {
  final int selectedHour;
  final int selectedMinute;
  final bool isAm;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;
  final ValueChanged<bool> onAmPmChanged;

  const CustomTimePicker({
    super.key,
    required this.selectedHour,
    required this.selectedMinute,
    required this.isAm,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onAmPmChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PickerColumn(
            itemCount: 12,
            initialValue: selectedHour,
            isHour: true,
            width: 150,
            onChanged: onHourChanged,
          ),
          const SizedBox(width: 10),
          PickerColumn(
            itemCount: 60,
            initialValue: selectedMinute,
            isHour: false,
            width: 139,
            onChanged: onMinuteChanged,
          ),
          const SizedBox(width: 10),
          AmPmPicker(initialIsAm: isAm, onChanged: onAmPmChanged),
        ],
      ),
    );
  }
}
