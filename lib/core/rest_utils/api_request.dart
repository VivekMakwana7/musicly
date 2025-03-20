import 'package:flutter/foundation.dart' show immutable;
import 'package:pkg_dio/pkg_dio.dart';

/// Common Api request data holder
@immutable
class ApiRequest {
  /// Constructor
  const ApiRequest({
    this.path,
    this.pathParameter,
    this.data,
    this.params,
    this.options,
    this.cancelToken,
    this.receiveProgress,
    this.hideKeyboard = true,
    this.sendProgress,
  });

  /// path parameter
  final String? path;

  /// path parameter used to append the value to the path
  final String? pathParameter;

  /// body data
  final Object? data;

  /// parameters
  final Map<String, dynamic>? params;

  /// Dio options
  final Options? options;

  /// cancel token
  final CancelToken? cancelToken;

  /// receive progress callback
  final ProgressCallback? receiveProgress;

  /// hide keyboard
  final bool hideKeyboard;

  /// Send progress callback
  final ProgressCallback? sendProgress;
}
