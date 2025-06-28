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

  Future<void> markAsDirty(int id) async {
    await (update(categories)..where((cat) => cat.id.equals(id))).write(
      CategoriesCompanion(
        isDirty: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<CategoryEntity>> getDirtyCategories() {
    return (select(categories)..where((cat) => cat.isDirty.equals(true))).get();
  }

  Future<void> markAsSynced(int id) async {
    await (update(categories)..where((cat) => cat.id.equals(id))).write(
      CategoriesCompanion(
        isDirty: const Value(false),
        lastSyncDate: Value(DateTime.now()),
      ),
    );
  }
}
