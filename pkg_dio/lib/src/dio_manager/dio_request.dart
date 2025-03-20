// import 'dart:isolate';

import 'package:flutter/material.dart' show FocusManager, immutable;
import 'package:pkg_dio/pkg_dio.dart';

/// generic json mapper
typedef JsonMapper<T> = T Function(Map<String, dynamic>);

/// generic list json mapper
typedef ListJsonMapper<T> = T Function(List<dynamic>);

/// Request model for APIs
@immutable
class DioRequest<T> {
  /// DIO Request
  const DioRequest({
    required this.dio,
    required this.path,
    this.jsonMapper,
    this.listJsonMapper,
    this.data,
    this.params,
    this.options,
    this.cancelToken,
    this.receiveProgress,
    this.sendProgress,
    this.hideKeyboard = true,
  })  : assert(jsonMapper != null || listJsonMapper != null, 'Provide at least one json mapper!'),
        assert(jsonMapper == null || listJsonMapper == null, 'Can not provide both json mapper!');

  /// Dio instance
  final Dio dio;

  /// endpoint
  final String path;

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

  /// Send progress callback
  final ProgressCallback? sendProgress;

  /// Use this for if response is JsonObject
  final JsonMapper<T>? jsonMapper;

  /// Use this for if response is JsonArray
  final ListJsonMapper<T>? listJsonMapper;

  /// close keyboard
  final bool hideKeyboard;

  /// GET method
  Future<ApiResult<T>> get() => _requestCall('GET');

  /// POST method
  Future<ApiResult<T>> post() => _requestCall('POST');

  /// PUT method
  Future<ApiResult<T>> put() => _requestCall('PUT');

  /// PATCH method
  Future<ApiResult<T>> patch() => _requestCall('PATCH');

  /// DELETE method
  Future<ApiResult<T>> delete() => _requestCall('DELETE');

  Future<ApiResult<T>> _requestCall(String method) async {
    if (hideKeyboard) FocusManager.instance.primaryFocus?.unfocus();
    try {
      if (cancelToken?.isCancelled ?? false) {
        return const ApiResult.error(exception: ApiException(code: -1, message: 'Request Cancelled'));
      }
      final response = await dio.request<dynamic>(
        path,
        options: (options ?? Options())..method = method,
        queryParameters: params,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      /*final response = await Isolate.run(
        () {
          return dio.request<dynamic>(
            path,
            options: (options ?? Options())..method = method,
            queryParameters: params,
            data: data,
            cancelToken: cancelToken,
            onReceiveProgress: receiveProgress,
          );
        },
      );*/
      return _responseHandler(response);
    } on DioException catch (ex) {
      // Logger().e(ex.type);
      // Logger().e(ex.message);
      // Logger().e(ex.response?.statusCode);
      // 'path $path'.logFatal;
      // 'data $data'.logFatal;
      // '${ex.response?.statusCode}'.logFatal;
      // '${ex.response?.data}'.logFatal;
      // '${ex.error}'.logFatal;
      return ApiResult.error(exception: ex.toApiException);
    } on Object catch (ex) {
      return ApiResult.error(exception: ApiException(code: -1, message: ex.toString()));
    }
  }

  Future<ApiResult<T>> _responseHandler(Response<dynamic> response) async {
    if (response.data != null) {
      final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>);

      if (response.statusCode != 200) {
        return ApiResult.error(
          exception: ApiException(code: response.statusCode ?? 0, message: 'Something went wrong!'),
        );
      }
      if (T == ApiResponse && ((response.data as Map<String, dynamic>?)?.isNotEmpty ?? false)) {
        final data = jsonMapper!.call(response.data as Map<String, dynamic>);
        return ApiResult.success(data: data);
      } else if (apiResponse.data is Map<String, dynamic> && jsonMapper != null) {
        final data = jsonMapper!.call(apiResponse.data as Map<String, dynamic>);
        return ApiResult.success(data: data);
      } else if (apiResponse.data is List<dynamic> && listJsonMapper != null) {
        final data = listJsonMapper!.call(apiResponse.data as List<dynamic>);
        return ApiResult.success(data: data);
      } else {
        return ApiResult.error(
          exception: ApiException(code: response.statusCode ?? -1, message: 'No jsonMapper provided'),
        );
      }
    } else {
      return ApiResult.error(
        exception: ApiException(code: response.statusCode ?? -1, message: 'Response not found!'),
      );
    }
  }
}
