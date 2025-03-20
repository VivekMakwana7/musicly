import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final _logger = Logger(filter: _LogFilter());

/// logger extension
extension LoggerEx on Object? {
  /// to print message with debug level
  void get logD => _logger.d(this);

  /// to print message with info level
  void get logI => _logger.i(this);

  /// to print message with verbose level
  void get logV => _logger.t(this);

  /// to print message with error level
  void get logE => _logger.e(this);

  /// to print message with warning level
  void get logW => _logger.w(this);

  /// to print message with timestamp
  void get logTime => _logger.d('${DateTime.now().toIso8601String()} $this');

  /// to print message with wtf level
  void get logFatal => _logger.f(this);
}

class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return switch (event.level) {
      Level.debug || Level.info || Level.trace || Level.warning || Level.error => kDebugMode,
      Level.fatal => true,
      _ => false,
    };
  }
}
