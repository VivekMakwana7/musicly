import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/enums/bottom_nav_menu.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/widgets/bottom_nav/bottom_icon.dart';
import 'package:musicly/widgets/bottom_nav/cubit/bottom_nav_cubit.dart';

/// Bottom Icons Widget
class BottomIconsWidget extends StatelessWidget {
  /// Bottom Icons Widget Constructor
  const BottomIconsWidget({required this.child, super.key});

  /// Current navigation shell widget
  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BottomNavCubit, BottomNavState, BottomNavMenu>(
      selector: (state) => state.selectedMenu,
      builder: (context, selectedMenu) {
        return Row(
          children:
              BottomNavMenu.values
                  .map((e) => BottomIcon(menu: e, selected: e == selectedMenu, onTap: () => onMenuChanged(context, e)))
                  .toList(),
        );
      },
    );
  }

  /// Handles the change of the bottom navigation menu.
  ///
  /// Dispatches an event to the [BottomNavCubit] to update the selected menu and
  /// changes the navigation index.
  void onMenuChanged(BuildContext context, BottomNavMenu menu) {
    context.read<BottomNavCubit>().changeBottomNavMenu(menu);
    _changeNavigationIndex(BottomNavMenu.values.indexOf(menu));
  }

  void _changeNavigationIndex(int index) {
    // Avoid re-navigating to the same tab
    if (child.currentIndex == index) {
      'Already on tab $index'.logD;
      return;
    }
    child.goBranch(index);
  }
}
