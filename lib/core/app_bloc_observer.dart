import 'package:bloc/bloc.dart';
import 'package:musicly/core/logger.dart';

/// Bloc Observer class
class AppBlocObserver extends BlocObserver {
  /// constructor
  const AppBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    'Created (${bloc.runtimeType})'.logD;
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    'Closed (${bloc.runtimeType})'.logD;
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    'onError(${bloc.runtimeType}, $error, $stackTrace)'.logE;
    super.onError(bloc, error, stackTrace);
  }
}
