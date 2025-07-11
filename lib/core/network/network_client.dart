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

    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: debugPrint, // For debugging
        retries: 3, // Number of retries
        retryDelays: const [
          Duration(seconds: 1), // 1s delay
          Duration(seconds: 2), // 2s delay
          Duration(seconds: 4), // 4s delay
        ],
        retryableExtraStatuses: {
          408, // Request Timeout
          429, // Too Many Requests
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (e, handler) {
          debugPrint('Error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  final Dio _dio;

  Dio get client => _dio;

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
