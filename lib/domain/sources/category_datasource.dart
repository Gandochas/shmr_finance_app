import 'package:shmr_finance_app/domain/models/category/category.dart';

abstract class CategoryDatasource {
  Future<List<Category>> getAll();

  Future<List<Category>> getByType({required bool isIncome});
}
