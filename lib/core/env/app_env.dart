import 'package:musicly/core/env/env.dart';
import 'package:musicly/core/env/env_fields.dart';

/// Environment class for the application
abstract class AppEnv implements EnvFields {
  /// Returns the singleton instance of the environment class
  factory AppEnv() => _instance;

  static final AppEnv _instance = envInstance;

  /// The singleton instance of the environment class
  static AppEnv envInstance = Env();
}
