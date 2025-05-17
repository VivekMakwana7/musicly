// import 'dart:isolate';

import 'package:flutter/material.dart' show FocusManager, immutable;
import 'package:pkg_dio/pkg_dio.dart';
import 'package:pkg_dio/src/dio_manager/logger.dart';

/// Generic JSON mapper for a single object.
typedef JsonMapper<T> = T Function(Map<String, dynamic>);

/// Generic JSON mapper for a list of objects.
typedef ListJsonMapper<T> = T Function(List<dynamic>);

/// Represents a request to be made using the Dio HTTP client.
@immutable
class DioRequest<T> {
  /// Creates a [DioRequest].
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
    this.pathParameter,
  })  : assert(jsonMapper != null || listJsonMapper != null, 'Provide at least one json mapper!'),
        assert(jsonMapper == null || listJsonMapper == null, 'Cannot provide both jsonMapper and listJsonMapper!');

  /// The [Dio] instance used to make the request.
  final Dio dio;

  /// The endpoint path for the request.
  final String path;

  /// The request body data.
  final Object? data;

  /// The query parameters for the request.
  final Map<String, dynamic>? params;

  /// Additional [Options] for the request.
  final Options? options;

  /// The [CancelToken] to cancel the request.
  final CancelToken? cancelToken;

  /// Callback for receiving progress updates.
  final ProgressCallback? receiveProgress;

  /// Callback for sending progress updates.
  final ProgressCallback? sendProgress;

  /// Mapper function to parse a JSON object.
  final JsonMapper<T>? jsonMapper;

  /// Mapper function to parse a JSON array.
  final ListJsonMapper<T>? listJsonMapper;

  /// Whether to hide the keyboard before making the request.
  final bool hideKeyboard;

  /// An optional parameter to append to the URL path.
  final String? pathParameter;

  /// Makes a GET request.
  Future<ApiResult<T>> get() => _requestCall('GET');

  /// Makes a POST request.
  Future<ApiResult<T>> post() => _requestCall('POST');

  /// Makes a PUT request.
  Future<ApiResult<T>> put() => _requestCall('PUT');

  /// Makes a PATCH request.
  Future<ApiResult<T>> patch() => _requestCall('PATCH');

  /// Makes a DELETE request.
  Future<ApiResult<T>> delete() => _requestCall('DELETE');

  /// Core method to make the network request.
  Future<ApiResult<T>> _requestCall(String method) async {
    if (hideKeyboard) FocusManager.instance.primaryFocus?.unfocus();
    try {
      if (cancelToken?.isCancelled ?? false) {
        return const ApiResult.error(exception: ApiException(code: -1, message: 'Request Cancelled'));
      }
      var urlPath = path;
      if (pathParameter != null) {
        urlPath = '$path/${pathParameter!}';
      }
      final response = await dio.request<dynamic>(
        urlPath,
        options: (options ?? Options())..method = method,
        queryParameters: params,
        data: data,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );

      'response : ${response.data}'.logD;
      return _responseHandler(response);
    } on DioException catch (ex) {
      'ex : $ex'.logE;
      return ApiResult.error(exception: ex.toApiException);
    } on Object catch (ex) {
      'ex : $ex'.logE;
      return ApiResult.error(exception: ApiException(code: -1, message: ex.toString()));
    }
  }

  /// Handles the API response, mapping it to a result.
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
