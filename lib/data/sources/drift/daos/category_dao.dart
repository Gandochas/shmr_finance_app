import 'package:drift/drift.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.attachedDatabase);

  Future<List<CategoryEntity>> getAllCategories() {
    return select(categories).get();
  }

  Future<CategoryEntity?> getCategoryById(int id) {
    return (select(
      categories,
    )..where((cat) => cat.id.equals(id))).getSingleOrNull();
  }

  Future<void> clearAndInsertAll(List<CategoriesCompanion> companions) async {
    await batch((batch) {
      batch.deleteAll(categories);
      batch.insertAll(categories, companions);
    });
  }

  Future<int> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  Future<int> updateCategory(int id, CategoriesCompanion category) {
    return (update(
      categories,
    )..where((cat) => cat.id.equals(id))).write(category);
  }

  Future<int> deleteCategory(int id) {
    return (delete(categories)..where((cat) => cat.id.equals(id))).go();
  }
}
