import 'package:drift/drift.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';

part 'account_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(super.attachedDatabase);

  Future<List<AccountEntity>> getAllAccounts() {
    return select(accounts).get();
  }

  Future<AccountEntity?> getAccountById(int id) {
    return (select(
      accounts,
    )..where((acc) => acc.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertAccount(AccountsCompanion account) {
    return into(accounts).insert(account);
  }

  Future<int> updateAccount(int id, AccountsCompanion account) {
    return (update(accounts)..where((acc) => acc.id.equals(id))).write(account);
  }

  Future<int> deleteAccount(int id) {
    return (delete(accounts)..where((acc) => acc.id.equals(id))).go();
  }

  Future<void> markAsDirty(int id) async {
    await (update(accounts)..where((acc) => acc.id.equals(id))).write(
      AccountsCompanion(
        isDirty: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<AccountEntity>> getDirtyAccounts() {
    return (select(accounts)..where((acc) => acc.isDirty.equals(true))).get();
  }

  Future<void> markAsSynced(int id) async {
    await (update(accounts)..where((acc) => acc.id.equals(id))).write(
      AccountsCompanion(
        isDirty: const Value(false),
        lastSyncDate: Value(DateTime.now()),
      ),
    );
  }
}
