import 'package:shmr_finance_app/domain/models/category/category.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';

final class MockCategoryRepository implements CategoryRepository {
  final _categories = <Category>[
    const Category(id: 1, name: 'Недвижимость', emoji: '🏠', isIncome: false),
    const Category(id: 2, name: 'Одежда', emoji: '👗', isIncome: false),
    const Category(id: 3, name: 'Зарплата', emoji: '👗', isIncome: true),
  ];

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
