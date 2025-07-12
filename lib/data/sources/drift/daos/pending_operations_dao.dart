import 'package:drift/drift.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';

part 'pending_operations_dao.g.dart';

@DriftAccessor(tables: [PendingOperations])
class PendingOperationsDao extends DatabaseAccessor<AppDatabase>
    with _$PendingOperationsDaoMixin {
  PendingOperationsDao(AppDatabase db) : super(db);

  Future<List<PendingOperationEntity>> getAll() =>
      select(pendingOperations).get();

  Future<void> insert(PendingOperationsCompanion companion) =>
      into(pendingOperations).insert(companion);

  Future<void> deleteOperation(int id) =>
      (delete(pendingOperations)..where((tbl) => tbl.id.equals(id))).go();
}
