import 'package:envied/envied.dart';
import 'package:musicly/core/env/app_env.dart';
import 'package:musicly/core/env/env_keys.dart';

part 'env.g.dart';

/// Dev Env
@Envied(name: 'Env', path: '.env', obfuscate: false)
class Env implements AppEnv {
  /// Constructor
  Env();

  @EnviedField(varName: EnvKeys.baseUrl)
  @override
  final String baseUrl = _Env.baseUrl;
}
