import 'package:shmr_finance_app/domain/models/category/category.dart';

abstract interface class CategoryRepository {
  Future<List<Category>> getAll();

  Future<List<Category>> getByType({required bool isIncome});
}

final class CategoryNotExistException implements Exception {
  const CategoryNotExistException(this.message);

  final String message;

  @override
  String toString() {
    return 'CategoryNotExistException: $message';
  }
}
