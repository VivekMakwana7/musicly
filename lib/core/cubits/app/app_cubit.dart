import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

/// AppCubit
class AppCubit extends Cubit<AppState> {
  /// Constructor
  AppCubit() : super(AppState());
}
