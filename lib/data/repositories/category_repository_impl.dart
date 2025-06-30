import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:shmr_finance_app/core/connection_checker.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/category_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';
import 'package:shmr_finance_app/data/sources/drift/mappers/drift_mappers.dart';
import 'package:shmr_finance_app/data/sources/mock/category_mock_datasource_impl.dart';
import 'package:shmr_finance_app/domain/models/category/category.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';

final class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({
    required CategoryMockDatasourceImpl apiSource,
    required CategoryDao categoryDao,
  }) : _apiSource = apiSource,
       _categoryDao = categoryDao;

  final CategoryMockDatasourceImpl _apiSource;
  final CategoryDao _categoryDao;
  final ConnectionChecker _connectionChecker = ConnectionChecker();

  @override
  Future<List<Category>> getAll() async {
    try {
      if (await _connectionChecker.isConnected()) {
        final categories = await _apiSource.getAll();
        await _syncCategoriesToLocal(categories);
        return categories;
      }
    } on Exception catch (e) {
      debugPrint('API call failed: $e');
    }

    final entities = await _categoryDao.getAllCategories();
    return entities.map(DriftMappers.categoryEntityToModel).toList();
  }

  @override
  Future<List<Category>> getByType({required bool isIncome}) async {
    try {
      if (await _connectionChecker.isConnected()) {
        final categories = await _apiSource.getAll();
        await _syncCategoriesToLocal(categories);
        return categories
            .where((category) => category.isIncome == isIncome)
            .toList();
      }
    } on Exception catch (e) {
      debugPrint('API call failed: $e');
    }

    final entities = await _categoryDao.getAllCategories();
    final categories = entities
        .map(DriftMappers.categoryEntityToModel)
        .toList();
    return categories
        .where((category) => category.isIncome == isIncome)
        .toList();
  }

  Future<void> _syncCategoriesToLocal(List<Category> categories) async {
    for (final category in categories) {
      await _syncCategoryToLocal(category);
    }
  }

  Future<void> _syncCategoryToLocal(Category category) async {
    final existing = await _categoryDao.getCategoryById(category.id);

    if (existing == null) {
      // Insert new category
      final companion = CategoriesCompanion.insert(
        id: Value(category.id),
        name: category.name,
        emoji: category.emoji,
        isIncome: category.isIncome,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastSyncDate: Value(DateTime.now()),
        isDirty: const Value(false),
      );
      await _categoryDao.insertCategory(companion);
    } else {
      // Update existing category
      final companion = CategoriesCompanion(
        name: Value(category.name),
        emoji: Value(category.emoji),
        isIncome: Value(category.isIncome),
        updatedAt: Value(DateTime.now()),
        lastSyncDate: Value(DateTime.now()),
        isDirty: const Value(false),
      );
      await _categoryDao.updateCategory(category.id, companion);
    }
  }
}
