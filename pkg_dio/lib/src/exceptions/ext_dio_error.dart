import 'dart:convert';

import 'package:pkg_dio/pkg_dio.dart';
import 'package:pkg_dio/src/dio_manager/logger.dart';

/// Extension for Dio Error
extension DioErrorX on DioException {
  /// Dio Error to ApiException
  ApiException get toApiException {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          code: response?.statusCode ?? -1,
          message: 'Network connection is slow to connection at the moment, please try again.',
          // message: 'Network connection is slow to connection at the moment, please try again.[${requestOptions.path}]',
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          code: response?.statusCode ?? -1,
          message: 'Network connection is slow to send request at the moment, please try again.',
          // message: 'Network connection is slow to send request at the moment, please try again.[${requestOptions.path}]',
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          code: response?.statusCode ?? -1,
          message: 'Network connection is slow to receive data at the moment, please try again.',
          // message: 'Network connection is slow to receive data at the moment, please try again.[${requestOptions.path}]',
        );
      case DioExceptionType.badCertificate:
        return ApiException(code: response?.statusCode ?? -1, message: message ?? 'BadCertificate!');

      case DioExceptionType.badResponse:
        String? errorMsg;
        int? code;
        final errorData = response?.data;
        // Logger().e(errorData);
        // Logger().i(errorData is String);
        // Logger().i(errorData is List<dynamic>);
        // Logger().i(errorData is Map<String, dynamic>);

        if (errorData is List<dynamic>) {
          errorMsg = errorData.cast<Map<String, dynamic>>().map((e) => e.values.join(' ')).join(', ');
        }
        Map<String, dynamic>? data;
        List<dynamic>? listData;
        // decode error response data
        if (errorData != null) {
          try {
            final jsonData =
                errorData is String ? jsonDecode(errorData) as Map<String, dynamic> : errorData as Map<String, dynamic>;
            code = jsonData['code'] as int?;
            errorMsg = jsonData['message'] as String?;
            if (jsonData['data'] is Map<String, dynamic>?) {
              data = jsonData['data'] as Map<String, dynamic>?;
            }
            if (jsonData['data'] is List<dynamic>?) {
              listData = jsonData['data'] as List<dynamic>?;
            }
          } on Object catch (ex) {
            'Exception : $ex'.logE;
            errorMsg = 'Oops, something went wrong';
            return ApiException(
              code: code ?? response?.statusCode ?? -1,
              message: errorMsg,
              data: data,
              lisData: listData,
            );
          }
        }
        if (response?.statusCode?.clamp(500, 599) == response?.statusCode) {
          errorMsg = 'Oops, something went wrong. Please try again';
          // errorMsg = 'Oops, something went wrong. Please try again (${requestOptions.path})';
        }
        // Logger().d('bad response : $data');
        return ApiException(
          code: code ?? response?.statusCode ?? -1,
          message: errorMsg ?? message ?? 'BadResponse!',
          data: data,
          lisData: listData,
        );

      case DioExceptionType.cancel:
        return ApiException(code: response?.statusCode ?? -2, message: message ?? 'Cancelled!');

      case DioExceptionType.connectionError:
        return const ApiException(code: 412, message: 'No internet connection!');
      // return ApiException(code: 412, message: 'No internet connection![${requestOptions.path}]');
      case DioExceptionType.unknown:
        return ApiException(
          code: response?.statusCode ?? -1,
          message: message ?? 'Something went wrong!',
          // message: message ?? 'Something went wrong! [${requestOptions.path}]',
        );
    }
  }
}
