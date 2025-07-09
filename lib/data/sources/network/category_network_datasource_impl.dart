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

      final data = response.data ?? [];

      return data
          .map(
            (categoryData) =>
                Category.fromJson(categoryData as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override
  Future<List<Category>> getByType({required bool isIncome}) async {
    try {
      final response = await _networkClient.get<List<dynamic>>(
        '/categories',
        params: {'isIncome': isIncome},
      );

      final data = response.data ?? [];

      return data
          .map(
            (categoryData) =>
                Category.fromJson(categoryData as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories by type: $e');
    }
  }
}
