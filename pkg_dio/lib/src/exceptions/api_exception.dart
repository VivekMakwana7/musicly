import 'package:flutter/foundation.dart' show immutable;

/// ApiException class for all exceptions
@immutable
class ApiException {
  /// Constructor
  const ApiException({required this.code, required this.message, this.data, this.lisData});

  /// Status code
  final int code;

  /// Status message
  final String message;

  /// data in error response
  final Map<String, dynamic>? data;

  /// data in error response
  final List<dynamic>? lisData;

  @override
  String toString() {
    return 'ApiException(code: $code, message: $message , data:$data, lisData:$lisData)';
  }
}
