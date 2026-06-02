import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_clock/core/theme/app_theme.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_bloc.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_event.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_state.dart';
import 'package:mechanix_clock/features/alarm/data/models/alarm_model.dart';
import 'package:mechanix_clock/l10n/app_localizations.dart';

import '../widgets/custom_switch.dart';
import 'edit_alarm_screen.dart';

class AlarmListScreen extends StatefulWidget {
  const AlarmListScreen({super.key});

  @override
  State<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends State<AlarmListScreen> {
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    context.read<AlarmBloc>().add(LoadAlarms());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _isEditing ? l10n.edit_alarms : l10n.alarms,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            key: const Key('edit_mode_button'),
            padding: const EdgeInsets.all(10),
            icon: Icon(
              _isEditing ? Icons.check : Icons.edit_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              padding: const EdgeInsets.all(10),
              key: const Key('add_alarm_button'),
              icon: const Icon(
                Icons.add_box_outlined,
                color: AppColors.textPrimary,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditAlarmScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<AlarmBloc, AlarmState>(
        builder: (context, state) {
          if (state is AlarmLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlarmLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: state.alarms.length,
              separatorBuilder: (context, index) => const SizedBox(height: 40),
              itemBuilder: (context, index) {
                return _AlarmItem(
                  alarm: state.alarms[index],
                  isEditing: _isEditing,
                );
              },
            );
          } else {
            return Center(child: Text(l10n.no_alarms));
          }
        },
      ),
    );
  }
}

class _AlarmItem extends StatelessWidget {
  final Alarm alarm;
  final bool isEditing;

  const _AlarmItem({required this.alarm, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Color textColor = alarm.isActive
        ? AppColors.textPrimary
        : AppColors.textGrey;

    final List<String> dayAbbrs = [
      l10n.monday_abbr,
      l10n.tuesday_abbr,
      l10n.wednesday_abbr,
      l10n.thursday_abbr,
      l10n.friday_abbr,
      l10n.saturday_abbr,
      l10n.sunday_abbr,
    ];

    return InkWell(
      onTap: () {
        context.read<AlarmBloc>().add(DeleteAlarm(alarm.id));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            if (isEditing) ...[
              GestureDetector(
                onTap: () {
                  context.read<AlarmBloc>().add(DeleteAlarm(alarm.id));
                },
                child: const Icon(
                  Icons.remove_circle_outline,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                key: const Key('alarm_item_tap'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAlarmScreen(alarm: alarm),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${alarm.hour}:${alarm.minute.toString().padLeft(2, '0')}',
                          style: Theme.of(
                            context,
                          ).textTheme.displayMedium?.copyWith(color: textColor),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            alarm.isAm ? l10n.am : l10n.pm,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(color: textColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (alarm.repeatDays.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        color: AppColors.cardBackground,
                        child: Text(
                          l10n.once,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: textColor),
                        ),
                      )
                    else
                      Row(
                        key: const Key('alarm_repeat_days'),
                        children: List.generate(7, (index) {
                          final bool isSelected = alarm.repeatDays.contains(
                            index,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.cardBackground
                                    : Colors.transparent,
                              ),
                              child: Text(
                                dayAbbrs[index],
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: isSelected
                                          ? AppColors.textOffWhite
                                          : AppColors.textDim,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                          );
                        }),
                      ),
                  ],
                ),
              ),
            ),
            if (!isEditing)
              CustomSwitch(
                value: alarm.isActive,
                onChanged: (value) {
                  context.read<AlarmBloc>().add(ToggleAlarm(alarm.id));
                },
              ),
          ],
        ),
      ),
    );
  }
}
