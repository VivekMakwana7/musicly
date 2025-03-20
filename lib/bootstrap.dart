import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:musicly/core/app_bloc_observer.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/hive/hive_registrar.g.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/logger.dart';
import 'package:path_provider/path_provider.dart';

/// Bootstrap function that initializes and runs the Flutter application
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  Bloc.observer = const AppBlocObserver();
  unawaited(
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        await _initialization();
        runApp(await builder());
      },
      (error, stack) {
        'Error: $error | Stack: $stack'.logE;
      },
    ),
  );
}

/// Initializes the application by registering services and setting up Hive.
Future<void> _initialization() async {
  await _initHive();
  Injector.initModules();
  await Injector.instance.isReady<AppDB>();
  await Injector.instance.allReady();
}

@pragma('vm:entry-point')
Future<void> _initHive() async {
  Injector.instance.registerSingletonAsync(
    _setupAppDirectories,
    instanceName: appDocDirInstanceName,
  );
  await Injector.instance.isReady<Directory>(
    instanceName: appDocDirInstanceName,
  );

  Hive
    ..init(
      Injector.instance<Directory>(instanceName: appDocDirInstanceName).path,
    )
    ..registerAdapters();
}

/// Setup directories for the app
Future<Directory> _setupAppDirectories() async {
  final appDocDir =
      await (Platform.isAndroid
          ? getApplicationDocumentsDirectory()
          : getLibraryDirectory());

  return appDocDir;
}
