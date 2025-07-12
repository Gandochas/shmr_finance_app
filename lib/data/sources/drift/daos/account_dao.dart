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

  Future<void> insertOrUpdate(AccountsCompanion account) {
    return into(accounts).insertOnConflictUpdate(account);
  }

  Future<int> updateAccount(int id, AccountsCompanion account) {
    return (update(accounts)..where((acc) => acc.id.equals(id))).write(account);
  }

  Future<int> deleteAccount(int id) {
    return (delete(accounts)..where((acc) => acc.id.equals(id))).go();
  }
}
