import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:musicly/core/enums/bottom_nav_menu.dart';

part 'bottom_nav_state.dart';

/// For handle bottom navigation
class BottomNavCubit extends Cubit<BottomNavState> {
  /// BottomNavCubit Constructor
  BottomNavCubit() : super(const BottomNavState());

  /// Change Bottom Navigation Menu
  void changeBottomNavMenu(BottomNavMenu menu) {
    if (state.selectedMenu != menu) {
      emit(state.copyWith(selectedMenu: menu));
    }
  }
}
