import 'package:flutter/material.dart';
import 'package:mechanix_clock/core/theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.alarm_outlined),
          _buildNavItem(1, Icons.timer_outlined),
          _buildNavItem(2, Icons.hourglass_empty_outlined),
          _buildNavItem(3, Icons.public_outlined),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? AppColors.textPrimary
              : AppColors.textPrimary.withOpacity(0.5),
        ),
      ),
    );
  }
}
