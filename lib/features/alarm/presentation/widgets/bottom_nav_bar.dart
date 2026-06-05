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
          NavItem(
            icon: Icons.alarm_outlined,
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          NavItem(
            icon: Icons.timer_outlined,
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          NavItem(
            icon: Icons.hourglass_empty_outlined,
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          NavItem(
            icon: Icons.public_outlined,
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              : AppColors.textPrimary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
