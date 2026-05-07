import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_clock/core/theme/app_theme.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_bloc.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_event.dart';
import 'package:mechanix_clock/features/alarm/data/models/alarm_model.dart';
import '../widgets/custom_switch.dart';

class EditAlarmScreen extends StatefulWidget {
  final Alarm? alarm;

  const EditAlarmScreen({super.key, this.alarm});

  @override
  State<EditAlarmScreen> createState() => _EditAlarmScreenState();
}

class _EditAlarmScreenState extends State<EditAlarmScreen> {
  late int _selectedHour;
  late int _selectedMinute;
  late bool _isAm;
  late List<int> _repeatDays;
  late String _sound;
  late bool _isSnoozeEnabled;

  @override
  void initState() {
    super.initState();
    final alarm = widget.alarm;

    // default to current time + 1 minute
    final defaultTime = DateTime.now().add(const Duration(minutes: 1));

    _selectedHour =
        alarm?.hour ??
        (defaultTime.hour % 12 == 0 ? 12 : defaultTime.hour % 12);
    _selectedMinute = alarm?.minute ?? defaultTime.minute;
    _isAm = alarm?.isAm ?? (defaultTime.hour < 12);
    _repeatDays = alarm?.repeatDays ?? [];
    _sound = alarm?.sound ?? 'Dancing Flames (Urban Pulse)';
    _isSnoozeEnabled = alarm?.isSnoozeEnabled ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.alarm == null ? 'Set alarm' : 'Edit alarm',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildTimePicker(),
          const SizedBox(height: 40),
          _buildOptionRow(
            'Repeat',
            _repeatDays.isEmpty
                ? 'Once'
                : _repeatDays
                      .map((d) => ['M', 'T', 'W', 'T', 'F', 'S', 'S'][d])
                      .join(' '),
            onTap: () async {
              final result = await Navigator.push<List<int>>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RepeatSelectionScreen(initialDays: _repeatDays),
                ),
              );
              if (result != null) {
                setState(() => _repeatDays = result);
              }
            },
          ),
          _buildOptionRow(
            'Sound',
            _sound,
            onTap: () async {
              final result = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SoundSelectionScreen(initialSound: _sound),
                ),
              );
              if (result != null) {
                setState(() => _sound = result);
              }
            },
          ),
          _buildSnoozeRow(),
          const Spacer(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return SizedBox(
      height: 220, // 87 selected + 2*(35px approx per dim item row)
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPickerColumn(
            itemCount: 12,
            selectedValue: _selectedHour,
            onSelectedItemChanged: (v) => setState(() => _selectedHour = v + 1),
            isHour: true,
            width: 150,
          ),
          const SizedBox(width: 10),
          _buildPickerColumn(
            itemCount: 60,
            selectedValue: _selectedMinute,
            onSelectedItemChanged: (v) => setState(() => _selectedMinute = v),
            isHour: false,
            width: 139,
          ),
          const SizedBox(width: 10),
          _buildAmPmPicker(),
        ],
      ),
    );
  }

  Widget _buildPickerColumn({
    required int itemCount,
    required int selectedValue,
    required ValueChanged<int> onSelectedItemChanged,
    required bool isHour,
    required double width,
  }) {
    // itemExtent for selected = 87, but we need smaller extents for dim items.
    // CupertinoPicker uses uniform itemExtent, so we set it to accommodate
    // the large selected text. Items above/below naturally overflow the Stack.
    const double itemExtent = 87.0;

    return SizedBox(
      width: width,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Full-height picker — overflows above and below the border box
          CupertinoPicker(
            itemExtent: itemExtent,
            scrollController: FixedExtentScrollController(
              initialItem: isHour ? selectedValue - 1 : selectedValue,
            ),
            onSelectedItemChanged: onSelectedItemChanged,
            selectionOverlay: const SizedBox.shrink(), // hide default overlay
            squeeze: 1.0,
            looping: true,
            children: List.generate(itemCount, (index) {
              final value = isHour ? index + 1 : index;
              final isSelected = isHour
                  ? value == selectedValue
                  : value == selectedValue;

              return _buildPickerItem(
                label: value.toString().padLeft(2, '0'),
                isSelected: isSelected,
              );
            }),
          ),

          // Border box overlay — sits centered, 87px tall, full width
          Positioned(
            top: (220 - 87) / 2, // center vertically = 66.5
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 87,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2D2D2D), width: 1),
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerItem({required String label, required bool isSelected}) {
    return Center(
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Sora',
          fontSize: isSelected ? 60.0 : 20.0,
          fontWeight: isSelected ? FontWeight.w400 : FontWeight.w300,
          color: isSelected ? const Color(0xFFDDDDDD) : const Color(0xFF717171),
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildAmPmPicker() {
    return SizedBox(
      width: 116,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CupertinoPicker(
            itemExtent: 87,
            scrollController: FixedExtentScrollController(
              initialItem: _isAm ? 0 : 1,
            ),
            onSelectedItemChanged: (v) => setState(() => _isAm = v == 0),
            selectionOverlay: const SizedBox.shrink(),
            looping: false,
            children: [
              _buildAmPmItem(label: 'AM', isSelected: _isAm),
              _buildAmPmItem(label: 'PM', isSelected: !_isAm),
            ],
          ),

          // Border overlay centered on selected item
          Positioned(
            top: (220 - 87) / 2,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 87,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2D2D2D), width: 1),
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmPmItem({required String label, required bool isSelected}) {
    return Center(
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Sora',
          fontSize: isSelected ? 40.0 : 20.0,
          fontWeight: isSelected ? FontWeight.w400 : FontWeight.w300,
          color: isSelected ? const Color(0xFFDDDDDD) : const Color(0xFF717171),
          height: 1.2,
        ),
      ),
    );
  }
  // Widget _buildTimePicker() {
  //   return SizedBox(
  //     height: 220,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         _buildPickerColumn(
  //           itemCount: 12,
  //           selectedValue: _selectedHour,
  //           onSelectedItemChanged: (v) => setState(() => _selectedHour = v + 1),
  //           isHour: true,
  //           width: 150,
  //         ),
  //         const SizedBox(width: 10),
  //         _buildPickerColumn(
  //           itemCount: 60,
  //           selectedValue: _selectedMinute,
  //           onSelectedItemChanged: (v) => setState(() => _selectedMinute = v),
  //           isHour: false,
  //           width: 139,
  //         ),
  //         const SizedBox(width: 10),
  //         _buildAmPmPicker(),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildPickerColumn({
  //   required int itemCount,
  //   required int selectedValue,
  //   required ValueChanged<int> onSelectedItemChanged,
  //   required bool isHour,
  //   required double width,
  // }) {
  //   return Container(
  //     width: width,
  //     height: 87,
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF000000),
  //       border: Border.all(color: const Color(0xFF2D2D2D)),
  //     ),
  //     child: CupertinoPicker(
  //       itemExtent: 87,
  //       scrollController: FixedExtentScrollController(
  //         initialItem: isHour ? selectedValue - 1 : selectedValue,
  //       ),
  //       onSelectedItemChanged: onSelectedItemChanged,
  //       selectionOverlay: const SizedBox.shrink(), // Remove default overlay
  //       children: List.generate(itemCount, (index) {
  //         final value = isHour ? index + 1 : index;
  //         final isSelected = isHour
  //             ? value == selectedHourAdjusted(selectedValue)
  //             : value == selectedValue;

  //         // Distance-based styling matching Figma
  //         final int distance =
  //             (value - (isHour ? selectedValue : selectedValue)).abs();

  //         final Color textColor;
  //         final double fontSize;

  //         if (isSelected) {
  //           textColor = const Color(0xFFDDDDDD); // Selected
  //           fontSize = 60;
  //         } else if (distance == 1) {
  //           textColor = const Color(0xFF717171); // Adjacent
  //           fontSize = 20;
  //         } else {
  //           textColor = const Color(0xFF212121); // Far away
  //           fontSize = 20;
  //         }

  //         return Center(
  //           child: Text(
  //             value.toString().padLeft(2, '0'),
  //             style: TextStyle(
  //               fontFamily: 'Sora',
  //               fontSize: fontSize,
  //               fontWeight: isSelected ? FontWeight.w400 : FontWeight.w300,
  //               color: textColor,
  //             ),
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }

  // int selectedHourAdjusted(int hour) => hour;

  // Widget _buildAmPmPicker() {
  //   return Container(
  //     width: 116,
  //     height: 87,
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF000000),
  //       border: Border.all(color: const Color(0xFF2D2D2D)),
  //     ),
  //     child: CupertinoPicker(
  //       itemExtent: 87,
  //       scrollController: FixedExtentScrollController(
  //         initialItem: _isAm ? 0 : 1,
  //       ),
  //       selectionOverlay: const SizedBox.shrink(),
  //       onSelectedItemChanged: (v) => setState(() => _isAm = v == 0),
  //       children: [
  //         Center(
  //           child: Text(
  //             'AM',
  //             style: TextStyle(
  //               fontFamily: 'Sora',
  //               fontSize: _isAm ? 40 : 20,
  //               fontWeight: _isAm ? FontWeight.w400 : FontWeight.w300,
  //               color: _isAm
  //                   ? const Color(0xFFDDDDDD)
  //                   : const Color(0xFF717171),
  //             ),
  //           ),
  //         ),
  //         Center(
  //           child: Text(
  //             'PM',
  //             style: TextStyle(
  //               fontFamily: 'Sora',
  //               fontSize: !_isAm ? 40 : 20,
  //               fontWeight: !_isAm ? FontWeight.w400 : FontWeight.w300,
  //               color: !_isAm
  //                   ? const Color(0xFFDDDDDD)
  //                   : const Color(0xFF717171),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildOptionRow(
    String title,
    String value, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            Row(
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textLightGrey,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSnoozeRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Snooze', style: Theme.of(context).textTheme.titleLarge),
          CustomSwitch(
            value: _isSnoozeEnabled,
            onChanged: (v) => setState(() => _isSnoozeEnabled = v),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
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
          if (widget.alarm != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.textDim),
              onPressed: () {
                context.read<AlarmBloc>().add(DeleteAlarm(widget.alarm!.id));
                Navigator.pop(context);
              },
            )
          else
            const SizedBox(width: 44),
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.textPrimary),
            onPressed: () {
              final alarm = Alarm(
                id:
                    widget.alarm?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                hour: _selectedHour,
                minute: _selectedMinute,
                isAm: _isAm,
                repeatDays: _repeatDays,
                sound: _sound,
                isSnoozeEnabled: _isSnoozeEnabled,
              );
              if (widget.alarm == null) {
                context.read<AlarmBloc>().add(AddAlarm(alarm));
              } else {
                context.read<AlarmBloc>().add(UpdateAlarm(alarm));
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class RepeatSelectionScreen extends StatefulWidget {
  final List<int> initialDays;
  const RepeatSelectionScreen({super.key, required this.initialDays});

  @override
  State<RepeatSelectionScreen> createState() => _RepeatSelectionScreenState();
}

class _RepeatSelectionScreenState extends State<RepeatSelectionScreen> {
  late List<int> _selectedDays;
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(widget.initialDays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repeat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          final isSelected = _selectedDays.contains(index);
          return ListTile(
            title: Text(_days[index]),
            leading: Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: AppColors.textPrimary,
            ),
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedDays.remove(index);
                } else {
                  _selectedDays.add(index);
                  _selectedDays.sort();
                }
              });
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: AppColors.surface,
        child: Center(
          child: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, _selectedDays),
          ),
        ),
      ),
    );
  }
}

class SoundSelectionScreen extends StatefulWidget {
  final String initialSound;
  const SoundSelectionScreen({super.key, required this.initialSound});

  @override
  State<SoundSelectionScreen> createState() => _SoundSelectionScreenState();
}

class _SoundSelectionScreenState extends State<SoundSelectionScreen> {
  late String _selectedSound;
  final List<String> _sounds = [
    'Wakeup',
    'Siren',
    'Chasing Stars - Beyond the Horizon',
    'Dancing Flames (Urban Pulse)',
    'Silent Echo - Reflections of Time (Time mus...)',
    'Lost in Dreams - The Sound of Silence',
  ];

  @override
  void initState() {
    super.initState();
    _selectedSound = widget.initialSound;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sound'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: _sounds.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedSound == _sounds[index];
          return ListTile(
            title: Text(_sounds[index]),
            leading: Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: AppColors.textPrimary,
            ),
            onTap: () {
              setState(() => _selectedSound = _sounds[index]);
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: AppColors.surface,
        child: Center(
          child: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, _selectedSound),
          ),
        ),
      ),
    );
  }
}
