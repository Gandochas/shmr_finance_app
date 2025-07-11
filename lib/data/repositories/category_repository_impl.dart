import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:shmr_finance_app/data/sources/drift/daos/category_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';
import 'package:shmr_finance_app/data/sources/drift/mappers/drift_mappers.dart';
import 'package:shmr_finance_app/domain/models/category/category.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/domain/sources/category_datasource.dart';

final class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({required this.apiSource, required this.categoryDao});

  final CategoryDatasource apiSource;
  final CategoryDao categoryDao;

  @override
  Future<List<Category>> getAll() async {
    try {
      final categories = await apiSource.getAll();
      final companions = categories.map(_categoryToCompanion).toList();
      await categoryDao.clearAndInsertAll(companions);
      return categories;
    } on Exception catch (e) {
      debugPrint('API call failed, fetching from local DB: $e');
      final entities = await categoryDao.getAllCategories();
      return entities.map(DriftMappers.categoryEntityToModel).toList();
    }
  }

  @override
  Future<List<Category>> getByType({required bool isIncome}) async {
    final allCategories = await getAll();
    return allCategories
        .where((category) => category.isIncome == isIncome)
        .toList();
  }

  CategoriesCompanion _categoryToCompanion(Category category) {
    return CategoriesCompanion(
      id: Value(category.id),
      name: Value(category.name),
      emoji: Value(category.emoji),
      isIncome: Value(category.isIncome),
      // createdAt and updatedAt are not available in Category model,
      // so we use current time.
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
  }
}
