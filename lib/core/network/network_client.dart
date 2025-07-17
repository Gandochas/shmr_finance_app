import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final class NetworkClient {
  NetworkClient() : _dio = Dio() {
    _dio.options.baseUrl =
        dotenv.env['BASE_URL'] ?? 'https://shmr-finance.ru/api/v1';
    _dio.options.headers = {
      'Authorization': 'Bearer ${dotenv.env['TOKEN']}',
      'Content-Type': 'application/json',
    };

    _dio.options.receiveTimeout = const Duration(seconds: 10);

    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: debugPrint,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ],
        retryableExtraStatuses: {500, 502, 503, 504, 408, 429},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final log = StringBuffer();
          log.writeln('*** Request ***');
          log.writeln('method: ${options.method}');
          log.writeln('uri: ${options.uri}');
          if (options.queryParameters.isNotEmpty) {
            log.writeln('queryParameters:');
            options.queryParameters.forEach((k, v) => log.writeln('  $k: $v'));
          }
          if (options.data != null) {
            log.writeln('body: ${options.data}');
          }
          debugPrint(log.toString());
          return handler.next(options);
        },
        onResponse: (response, handler) {
          final log = StringBuffer();
          log.writeln('*** Response ***');
          log.writeln('uri: ${response.requestOptions.uri}');
          log.writeln('statusCode: ${response.statusCode}');
          log.writeln('headers:');
          response.headers.forEach(
            (k, v) => log.writeln('  $k: ${v.join(', ')}'),
          );
          log.writeln('data: ${response.data}');
          debugPrint(log.toString());
          return handler.next(response);
        },
        onError: (e, handler) {
          final log = StringBuffer();
          log.writeln('*** Error ***');
          log.writeln('uri: ${e.requestOptions.uri}');
          log.writeln('message: ${e.message}');
          if (e.response != null) {
            log.writeln('statusCode: ${e.response?.statusCode}');
            log.writeln('data: ${e.response?.data}');
          }
          debugPrint(log.toString());
          return handler.next(e);
        },
      ),
    );
  }

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, Object?>? params,
  }) async {
    return _dio.get<T>(path, queryParameters: params);
  }

  Future<Response<T>> post<T>(String path, {Map<String, Object?>? data}) async {
    return _dio.post<T>(path, data: data);
  }

  Future<Response<T>> put<T>(String path, {Map<String, Object?>? data}) async {
    return _dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, Object?>? data,
  }) async {
    return _dio.delete<T>(path, data: data);
  }
}
