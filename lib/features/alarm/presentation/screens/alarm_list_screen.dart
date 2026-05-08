import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_clock/core/theme/app_theme.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_bloc.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_event.dart';
import 'package:mechanix_clock/features/alarm/bloc/alarm_state.dart';
import 'package:mechanix_clock/features/alarm/data/models/alarm_model.dart';
import 'edit_alarm_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_switch.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _isEditing ? 'Edit Alarms' : 'Alarms',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            key: const Key('edit_mode_button'),
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
          IconButton(
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
            return const Center(child: Text('No Alarms'));
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0, onTap: (index) {}),
    );
  }
}

class _AlarmItem extends StatelessWidget {
  final Alarm alarm;
  final bool isEditing;

  const _AlarmItem({required this.alarm, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final Color textColor = alarm.isActive
        ? AppColors.textPrimary
        : AppColors.textGrey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          alarm.isAm ? 'AM' : 'PM',
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
                        'Once',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: textColor),
                      ),
                    )
                  else
                    Row(
                      key: const Key('alarm_repeat_days'),
                      children: List.generate(7, (index) {
                        final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
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
                              days[index],
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
    );
  }
}
