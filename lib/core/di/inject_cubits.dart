import 'package:flutter/foundation.dart' show immutable;
import 'package:get_it/get_it.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';

/// Cubit injector
@immutable
class CubitInjector {
  /// Constructor
  CubitInjector(this.instance) {
    _init();
  }

  /// GetIt instance
  final GetIt instance;

  void _init() {
    instance
      ..registerSingleton(AudioCubit())
      ..registerSingleton(AppCubit());
  }
}
