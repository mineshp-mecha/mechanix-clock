import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_clock/core/theme/app_theme.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_bloc.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_event.dart';
import 'package:mechanix_clock/features/alarm/data/models/alarm_model.dart';
import 'package:mechanix_clock/features/alarm/presentation/screens/sound_selection_screen.dart';
import 'package:mechanix_clock/features/alarm/presentation/widgets/am_pm_picker.dart';
import 'package:mechanix_clock/features/alarm/presentation/widgets/time_picker_column.dart';
import 'package:mechanix_clock/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final List<String> dayAbbrs = [
      l10n.monday_abbr,
      l10n.tuesday_abbr,
      l10n.wednesday_abbr,
      l10n.thursday_abbr,
      l10n.friday_abbr,
      l10n.saturday_abbr,
      l10n.sunday_abbr,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.alarm == null ? l10n.set_alarm : l10n.edit_alarm,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildTimePicker(),
          const SizedBox(height: 40),
          _buildOptionRow(
            l10n.repeat,
            _repeatDays.isEmpty
                ? 'Once'
                : _repeatDays.map((d) => dayAbbrs[d]).join(' '),
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
            l10n.sound,
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
          _SnoozeRow(
            initialValue: _isSnoozeEnabled,
            onChanged: (v) => _isSnoozeEnabled = v,
          ),
          const Spacer(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return SizedBox(
      height: 220,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PickerColumn(
            itemCount: 12,
            initialValue: _selectedHour,
            isHour: true,
            width: 150,
            onChanged: (v) => _selectedHour = v,
          ),
          const SizedBox(width: 10),
          PickerColumn(
            itemCount: 60,
            initialValue: _selectedMinute,
            isHour: false,
            width: 139,
            onChanged: (v) => _selectedMinute = v,
          ),
          const SizedBox(width: 10),
          AmPmPicker(initialIsAm: _isAm, onChanged: (v) => _isAm = v),
        ],
      ),
    );
  }

  Widget _buildOptionRow(
    String title,
    String value, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      key: Key('option_${title.toLowerCase()}'),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            Row(
              children: [
                SizedBox(
                  width: 400,
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
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
              key: const Key('delete_alarm_button'),
              icon: const Icon(Icons.delete_outline, color: AppColors.textDim),
              onPressed: () {
                context.read<AlarmBloc>().add(DeleteAlarm(widget.alarm!.id));
                Navigator.pop(context);
              },
            )
          else
            const SizedBox(width: 44),
          IconButton(
            key: const Key('save_alarm_button'),
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

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(widget.initialDays);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> days = [
      l10n.monday,
      l10n.tuesday,
      l10n.wednesday,
      l10n.thursday,
      l10n.friday,
      l10n.saturday,
      l10n.sunday,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.repeat),
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
            key: Key('day_$index'),
            title: Text(days[index]),
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
            key: const Key('repeat_done_button'),
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, _selectedDays),
          ),
        ),
      ),
    );
  }
}

class _SnoozeRow extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const _SnoozeRow({required this.initialValue, required this.onChanged});

  @override
  State<_SnoozeRow> createState() => _SnoozeRowState();
}

class _SnoozeRowState extends State<_SnoozeRow> {
  late bool _isSnoozeEnabled;

  @override
  void initState() {
    super.initState();
    _isSnoozeEnabled = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () {
        setState(() => _isSnoozeEnabled = !_isSnoozeEnabled);
        widget.onChanged(_isSnoozeEnabled);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.snooze, style: Theme.of(context).textTheme.titleLarge),
            CustomSwitch(
              value: _isSnoozeEnabled,
              onChanged: (v) {
                setState(() => _isSnoozeEnabled = v);
                widget.onChanged(v); // notify parent without rebuilding it
              },
            ),
          ],
        ),
      ),
    );
  }
}
