import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shmr_finance_app/data/repositories/category_repository_impl.dart';
import 'package:shmr_finance_app/data/sources/drift/daos/category_dao.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';
import 'package:shmr_finance_app/domain/models/category/category.dart';
import 'package:shmr_finance_app/domain/sources/category_datasource.dart';

class _MockDatasource extends Mock implements CategoryDatasource {}

class _MockDao extends Mock implements CategoryDao {}

void main() {
  late _MockDatasource api;
  late _MockDao dao;
  late CategoryRepositoryImpl repository;

  const incomeCat = Category(
    id: 1,
    name: 'Salary',
    emoji: '💰',
    isIncome: true,
  );

  const outcomeCat = Category(
    id: 2,
    name: 'Groceries',
    emoji: '🛒',
    isIncome: false,
  );

  setUpAll(() {
    registerFallbackValue(<CategoriesCompanion>[]);
  });

  setUp(() {
    api = _MockDatasource();
    dao = _MockDao();
    repository = CategoryRepositoryImpl(apiSource: api, categoryDao: dao);
  });

  group('CategoryRepositoryImpl.getAll', () {
    test('когда API успешно отдаёт данные, репозиторий возвращает их '
        'и сохраняет в локальную базу', () async {
      when(() => api.getAll()).thenAnswer((_) async => [incomeCat, outcomeCat]);
      when(() => dao.clearAndInsertAll(any())).thenAnswer((_) async {});

      final result = await repository.getAll();

      expect(result, equals([incomeCat, outcomeCat]));
      verify(() => api.getAll()).called(1);
      verify(() => dao.clearAndInsertAll(any())).called(1);
      verifyNever(() => dao.getAllCategories());
    });

    test('когда API выбрасывает исключение, репозиторий берёт данные из '
        'локальной базы', () async {
      when(() => api.getAll()).thenThrow(Exception('network down'));

      final entity = CategoryEntity(
        id: 3,
        name: 'Car',
        emoji: '🚗',
        isIncome: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(() => dao.getAllCategories()).thenAnswer((_) async => [entity]);

      final result = await repository.getAll();

      expect(result.map((c) => c.id), containsAll([entity.id]));
      verify(() => api.getAll()).called(1);
      verify(() => dao.getAllCategories()).called(1);
      verifyNever(() => dao.clearAndInsertAll(any()));
    });
  });

  group('CategoryRepositoryImpl.getByType', () {
    test('возвращает только доходные категории', () async {
      when(() => api.getAll()).thenAnswer((_) async => [incomeCat, outcomeCat]);
      when(() => dao.clearAndInsertAll(any())).thenAnswer((_) async {});

      final result = await repository.getByType(isIncome: true);

      expect(result, equals([incomeCat]));
    });

    test('возвращает только расходные категории', () async {
      when(() => api.getAll()).thenAnswer((_) async => [incomeCat, outcomeCat]);
      when(() => dao.clearAndInsertAll(any())).thenAnswer((_) async {});

      final result = await repository.getByType(isIncome: false);

      expect(result, equals([outcomeCat]));
    });
  });
}
