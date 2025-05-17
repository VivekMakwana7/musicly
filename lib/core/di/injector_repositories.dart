import 'package:flutter/foundation.dart' show immutable;
import 'package:get_it/get_it.dart';
import 'package:musicly/repos/music_repo.dart';

/// Repository Injector
@immutable
class RepositoryInjector {
  /// Constructor
  RepositoryInjector(this.instance) {
    _init();
  }

  /// GetIt instance
  final GetIt instance;

  void _init() {
    instance.registerFactory(() => MusicRepo(dio: instance()));
  }
}
