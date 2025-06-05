import 'package:flutter/foundation.dart' show immutable;
import 'package:get_it/get_it.dart';
import 'package:musicly/core/di/inject_cubits.dart';
import 'package:musicly/core/di/inject_services.dart';
import 'package:musicly/core/di/injector_repositories.dart';
import 'package:musicly/core/env/app_env.dart';
import 'package:pkg_dio/pkg_dio.dart';

/// App Dependencies Injection using GetIt
@immutable
class Injector {
  const Injector._();

  static final GetIt _injector = GetIt.instance;

  /// GetIt Instance
  static GetIt get instance => _injector;

  /// init all dependencies module wise
  static void initModules() {
    ServicesInjector(instance);
    ApiClientsInjector(instance: instance, baseUrl: AppEnv().baseUrl);
    RepositoryInjector(instance);
    CubitInjector(instance);
  }
}

/// Instance name for app document directory used in injector
const appDocDirInstanceName = 'appDocDir';
