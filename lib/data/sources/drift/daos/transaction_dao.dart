import 'package:drift/drift.dart';
import 'package:shmr_finance_app/data/sources/drift/database/database.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions, Accounts, Categories])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.attachedDatabase);

  Future<List<TransactionEntity>> getAllTransactions() {
    return select(transactions).get();
  }

  Future<TransactionEntity?> getTransactionById(int id) {
    return (select(
      transactions,
    )..where((txn) => txn.id.equals(id))).getSingleOrNull();
  }

  Future<List<TransactionEntity>> getTransactionsByAccountId(int accountId) {
    return (select(
      transactions,
    )..where((txn) => txn.accountId.equals(accountId))).get();
  }

  Future<List<TransactionEntity>> getTransactionsByPeriod({
    required int accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final query = select(transactions)
      ..where((txn) => txn.accountId.equals(accountId));

    if (startDate != null) {
      query.where((txn) => txn.transactionDate.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query.where((txn) => txn.transactionDate.isSmallerOrEqualValue(endDate));
    }

    return query.get();
  }

  Future<int> insertTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction);
  }

  Future<int> updateTransaction(int id, TransactionsCompanion transaction) {
    return (update(
      transactions,
    )..where((txn) => txn.id.equals(id))).write(transaction);
  }

  Future<int> deleteTransaction(int id) {
    return (delete(transactions)..where((txn) => txn.id.equals(id))).go();
  }

  Future<void> markAsDirty(int id) async {
    await (update(transactions)..where((txn) => txn.id.equals(id))).write(
      TransactionsCompanion(
        isDirty: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<TransactionEntity>> getDirtyTransactions() {
    return (select(
      transactions,
    )..where((txn) => txn.isDirty.equals(true))).get();
  }

  Future<void> markAsSynced(int id) async {
    await (update(transactions)..where((txn) => txn.id.equals(id))).write(
      TransactionsCompanion(
        isDirty: const Value(false),
        lastSyncDate: Value(DateTime.now()),
      ),
    );
  }

  // Join queries for getting transactions with related data
  Future<List<TransactionWithDetails>> getTransactionsWithDetails({
    required int accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final query = select(transactions).join([
      leftOuterJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
    ])..where(transactions.accountId.equals(accountId));

    if (startDate != null) {
      query.where(transactions.transactionDate.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query.where(transactions.transactionDate.isSmallerOrEqualValue(endDate));
    }

    return query.map((row) {
      return TransactionWithDetails(
        transaction: row.readTable(transactions),
        account: row.readTableOrNull(accounts),
        category: row.readTableOrNull(categories),
      );
    }).get();
  }
}

class TransactionWithDetails {
  const TransactionWithDetails({
    required this.transaction,
    this.account,
    this.category,
  });

  final TransactionEntity transaction;
  final AccountEntity? account;
  final CategoryEntity? category;
}
