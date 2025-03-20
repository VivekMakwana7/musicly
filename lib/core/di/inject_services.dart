import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:musicly/core/db/app_db.dart';

/// Services injector
@immutable
class ServicesInjector {
  /// Constructor
  ServicesInjector(this.instance) {
    _init();
  }

  /// GetIt instance
  final GetIt instance;

  void _init() {
    instance.registerSingletonAsync(AppDB.getInstance);
    //   ..registerSingleton(DeviceLocalUtils());
  }
}
