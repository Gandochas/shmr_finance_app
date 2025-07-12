import 'dart:convert';
import 'package:worker_manager/worker_manager.dart';

class IsolateDeserializer {
  /// Десериализация одного объекта через изолят
  static Future<T> deserialize<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final cancelable = workerManager.execute<T>(() async {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return fromJson(map);
    });
    return await cancelable;
  }

  /// Десериализация списка объектов через изолят
  static Future<List<T>> deserializeList<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final cancelable = workerManager.execute<List<T>>(() async {
      final list = jsonDecode(json) as List;
      return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    });
    return await cancelable;
  }
}
