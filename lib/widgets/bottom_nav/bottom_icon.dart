import 'package:flutter/material.dart';
import 'package:musicly/core/enums/bottom_nav_menu.dart';

/// Bottom Icon
class BottomIcon extends StatelessWidget {
  /// Bottom Icon Constructor
  const BottomIcon({
    required this.menu,
    required this.selected,
    super.key,
    this.onTap,
  });

  /// Current Bottom Menu
  final BottomNavMenu menu;

  /// Selected
  final bool selected;

  /// On Tap
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder:
              (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
          child: selected ? menu.selectedIcon : menu.icon,
        ),
      ),
    );
  }
}
