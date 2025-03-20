import 'package:flutter/foundation.dart' show immutable;

/// Endpoints for the API
@immutable
final class EndPoints {
  const EndPoints._();

  /// Endpoints for Search Songs/Albums/Artists
  static const String search = '/search';
}
