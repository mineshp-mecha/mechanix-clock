import 'package:flutter/material.dart';
import 'package:mechanix_clock/core/theme/app_theme.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('custom_switch'),
      onTap: () => onChanged(!value),
      child: Container(
        width: 78,
        height: 38,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? AppColors.cardBackground : AppColors.surface,
          borderRadius: BorderRadius.circular(25.71),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: value ? AppColors.textPrimary : AppColors.textGrey,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
