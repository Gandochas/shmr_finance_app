import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shmr_finance_app/core/network/isolate_deserializer.dart';
import 'package:shmr_finance_app/core/network/network_client.dart';
import 'package:shmr_finance_app/domain/models/category/category.dart';
import 'package:shmr_finance_app/domain/sources/category_datasource.dart';

final class CategoryNetworkDatasourceImpl implements CategoryDatasource {
  CategoryNetworkDatasourceImpl();

  final NetworkClient _networkClient = NetworkClient();

  @override
  Future<List<Category>> getAll() async {
    try {
      final response = await _networkClient.get<List<dynamic>>('/categories');

      return IsolateDeserializer.deserializeList<Category>(
        jsonEncode(response.data), // Десериализация с использованием Isolate
        (json) => Category.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${e.response?.data}');
      } else {
        throw Exception('Failed to fetch categories: $e');
      }
    }
  }

  @override
  Future<List<Category>> getByType({required bool isIncome}) async {
    try {
      final response = await _networkClient.get<List<dynamic>>(
        '/categories/type/$isIncome',
      );

      return IsolateDeserializer.deserializeList<Category>(
        jsonEncode(response.data),
        (json) => Category.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Bad request, invalid data: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${e.response?.data}');
      } else {
        throw Exception('Failed to fetch categories by type: $e');
      }
    }
  }
}
