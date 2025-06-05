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
import 'package:musicly/core/service/audio_handler.dart';
import 'package:path_provider/path_provider.dart';

/// Bootstrap function that initializes and runs the Flutter application
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Configure Bloc observer for cubit creation and dispose changes.
  Bloc.observer = const AppBlocObserver();
  unawaited(
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        await _initialization();
        audioPlayer = await initAudioService();
        runApp(await builder());
      },
      (error, stack) {
        // Log any unhandled errors that occur during initialization or app execution.
        'Unhandled Error: $error | Stack Trace: $stack'.logE;
      },
    ),
  );
}

/// Initializes essential application dependencies, including Hive and the dependency injector.
Future<void> _initialization() async {
  await _initHive();
  Injector.initModules();
  await Injector.instance.isReady<AppDB>();
  await Injector.instance.allReady();
}

/// Initializes Hive for data storage.
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

/// Retrieves the application's document or library directory based on the platform.
Future<Directory> _setupAppDirectories() async {
  final appDocDir =
      await (Platform.isAndroid
          ? getApplicationDocumentsDirectory()
          : getLibraryDirectory());

  return appDocDir;
}

/// Audio Player Handler for Handle Media Notifications
MyAudioHandler? audioPlayer;
