import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Cubit for monitoring internet connection status.
class ConnectionCheckerCubit extends Cubit<bool> {
  /// Creates a [ConnectionCheckerCubit] and starts listening to connectivity changes.
  ConnectionCheckerCubit({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity(),
      super(true) {
    _init();
  }
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> _init() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    emit(_isConnected(result));
    // Listen for connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      emit(_isConnected(result));
    });
  }

  bool _isConnected(List<ConnectivityResult> result) {
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
