import 'package:flutter/foundation.dart' show immutable;

/// Common API response class for all Rest APIs
@immutable
final class ApiResponse {
  /// Constructor
  const ApiResponse({
    required this.success,
    this.data,
  });

  /// function for converting a response from json
  factory ApiResponse.fromJson(Map<String, dynamic> map) {
    return ApiResponse(
      success: map['success'] as bool,
      data: map['data'] as dynamic,
    );
  }

  /// data from server
  final dynamic data;

  /// success
  final bool success;

  /// function for converting data to json
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
    };
  }
}
