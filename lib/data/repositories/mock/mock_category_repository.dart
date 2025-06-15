import 'package:shmr_finance_app/domain/models/category/category.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';

final class MockCategoryRepository implements CategoryRepository {
  final _categories = <Category>[];

  @override
  Future<List<Category>> getAll() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return [..._categories];
  }

  @override
  Future<List<Category>> getByType({required bool isIncome}) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return _categories
        .where((category) => category.isIncome == isIncome)
        .toList();
  }
}
