import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/enums/bottom_nav_menu.dart';
import 'package:musicly/widgets/bottom_nav/bottom_icon.dart';
import 'package:musicly/widgets/bottom_nav/cubit/bottom_nav_cubit.dart';

/// Bottom Icons Widget
class BottomIconsWidget extends StatelessWidget {
  /// Bottom Icons Widget Constructor
  const BottomIconsWidget({required this.child, super.key});

  /// Current navigation sheel widget
  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BottomNavCubit, BottomNavState, BottomNavMenu>(
      selector: (state) => state.selectedMenu,
      builder: (context, selectedMenu) {
        final cubit = context.read<BottomNavCubit>();
        return Row(
          children: [
            BottomIcon(
              menu: BottomNavMenu.home,
              selected: selectedMenu.isHome,
              onTap: () {
                child.goBranch(0);
                cubit.changeBottomNavMenu(BottomNavMenu.home);
              },
            ),
            BottomIcon(
              menu: BottomNavMenu.search,
              selected: selectedMenu.isSearch,
              onTap: () {
                child.goBranch(1);
                cubit.changeBottomNavMenu(BottomNavMenu.search);
              },
            ),
            BottomIcon(
              menu: BottomNavMenu.library,
              selected: selectedMenu.isLibrary,
              onTap: () {
                child.goBranch(2);
                cubit.changeBottomNavMenu(BottomNavMenu.library);
              },
            ),
            BottomIcon(
              menu: BottomNavMenu.liked,
              selected: selectedMenu.isLiked,
              onTap: () {
                child.goBranch(3);
                cubit.changeBottomNavMenu(BottomNavMenu.liked);
              },
            ),
          ],
        );
      },
    );
  }
}
