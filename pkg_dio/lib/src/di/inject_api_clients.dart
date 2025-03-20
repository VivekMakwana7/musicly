import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show immutable, kDebugMode;
import 'package:get_it/get_it.dart';

/// Api client injector
@immutable
class ApiClientsInjector {
  /// Constructor
  ApiClientsInjector({
    required this.instance,
    required this.baseUrl,
    this.interceptors,
  }) {
    _init();
  }

  /// instance of injector
  final GetIt instance;

  /// Base Url
  final String baseUrl;

  /// Custom network interceptor
  final List<Interceptor>? interceptors;

  late final _baseOptions = BaseOptions(
    baseUrl: baseUrl,
    contentType: Headers.jsonContentType,
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );

  final _logger = LogInterceptor(requestBody: true, responseBody: true);

  late final _dioClient = Dio(_baseOptions);

  void _init() {
    if (kDebugMode) interceptors?.add(_logger);
    if (interceptors != null) _dioClient.interceptors.addAll(interceptors!);

    instance.registerSingleton<Dio>(_dioClient);
  }
}
