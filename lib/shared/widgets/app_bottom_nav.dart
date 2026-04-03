import 'package:flutter/material.dart';
import 'package:pitx_mobapp2/core/theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: SizedBox(
        height: 78,
        child: Row(
          children: [
            Expanded(
              child: _NavItem(
                icon: Icons.home_rounded,
                // label: 'Home',
                isSelected: currentIndex == 0,
                // showLeftDivider: false,
                onTap: () => onTap(0),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.route_rounded,
                // label: 'Routes',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.menu_rounded,
                // label: 'More',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  // final String label;
  final bool isSelected;
  // final bool showLeftDivider;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    // required this.label,
    required this.isSelected,
    required this.onTap,
    // this.showLeftDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = AppColors.primary;
    final Color inactiveColor = AppColors.pitx_blue.withOpacity(0.50);
    // final Color dividerColor = AppColors.textSecondary.withOpacity(0.18);

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: isSelected
                  ? AppColors.pitx_red.withOpacity(0.80)
                  : Colors.transparent,
              width: 3,
            ),
            // left: showLeftDivider
            //     ? BorderSide(
            //         color: dividerColor,
            //         width: 1,
            //       )
            //     : BorderSide.none,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? activeColor : inactiveColor,
            ),
            // const SizedBox(height: 4),
            // Text(
            //   label,
            //   style: TextStyle(
            //     fontSize: 10,
            //     fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            //     color: isSelected ? activeColor : inactiveColor,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
