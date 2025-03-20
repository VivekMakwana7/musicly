part of 'bottom_nav_cubit.dart';

/// Represents the state of the [BottomNavCubit].
@immutable
final class BottomNavState {
  /// Creates a new instance of [BottomNavState].
  const BottomNavState({this.selectedMenu = BottomNavMenu.home});

  /// The currently selected menu item.
  final BottomNavMenu selectedMenu;

  /// Creates a new instance of [BottomNavState] with the same properties as the
  /// current instance, but with a different [selectedMenu].
  ///
  /// The [selectedMenu] parameter is optional and defaults to the current value
  /// of [selectedMenu].
  ///
  /// Returns a new instance of [BottomNavState] with the updated [selectedMenu].
  BottomNavState copyWith({BottomNavMenu? selectedMenu}) {
    return BottomNavState(selectedMenu: selectedMenu ?? this.selectedMenu);
  }
}
