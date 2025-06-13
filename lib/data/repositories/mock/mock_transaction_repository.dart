import 'package:shmr_finance_app/core/extensions/core_extensions.dart';
import 'package:shmr_finance_app/domain/models/account_brief/account_brief.dart';
import 'package:shmr_finance_app/domain/models/transaction/transaction.dart';
import 'package:shmr_finance_app/domain/models/transaction_request/transaction_request.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:uuid/uuid.dart';

final class MockTransactionRepository implements TransactionRepository {
  MockTransactionRepository({required CategoryRepository categoriesRepo, required BankAccountRepository accountsRepo})
    : _categoriesRepo = categoriesRepo,
      _accountsRepo = accountsRepo;

  final CategoryRepository _categoriesRepo;
  final BankAccountRepository _accountsRepo;

  final _transactions = <Transaction>[];

  @override
  Future<Transaction> create(TransactionRequest transactionRequest) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final newTransaction = Transaction(
      id: const Uuid().v4().hashCode,
      accountId: transactionRequest.id,
      categoryId: transactionRequest.categoryId,
      amount: transactionRequest.amount,
      transactionDate: transactionRequest.transactionDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _transactions.add(newTransaction);
    return newTransaction;
  }

  @override
  Future<void> delete(int transactionId) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _transactions.removeWhere((transaction) => transaction.id == transactionId);
  }

  @override
  Future<List<TransactionResponse>> getByAccountIdAndPeriod({
    required int accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final transactionsList = <TransactionResponse>[];
    final account = await _accountsRepo.getById(accountId);
    final categories = await _categoriesRepo.getAll();
    final now = DateTime.now();
    startDate ??= DateTime.utc(now.year, now.month);
    endDate ??= DateTime.utc(now.year, now.month + 1, 0);
    final neededTransactions =
        _transactions
            .where((transaction) => transaction.accountId == accountId)
            .where((transaction) => transaction.updatedAt >= startDate!)
            .where((transaction) => transaction.updatedAt <= endDate!)
            .toList();

    for (final transaction in neededTransactions) {
      transactionsList.add(
        TransactionResponse(
          id: transaction.id,
          account: AccountBrief(
            id: account.id,
            name: account.name,
            balance: account.balance,
            currency: account.currency,
          ),
          category: categories.firstWhere(
            (category) => category.id == transaction.categoryId,
            orElse: () => throw const CategoryNotExistException('Данной категории не существует'),
          ),
          amount: transaction.amount,
          transactionDate: transaction.transactionDate,
          createdAt: transaction.createdAt,
          updatedAt: transaction.updatedAt,
        ),
      );
    }
    return transactionsList;
  }

  //* id разные или нет (TransactionResponse и transactionId)
  @override
  Future<TransactionResponse> getById(int transactionId) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final transaction = _transactions.firstWhere(
      (transaction) => transaction.id == transactionId,
      orElse: () => throw const TransactionNotExistException('Данной транзакции не существует'),
    );
    final categories = await _categoriesRepo.getAll();
    final category = categories.firstWhere(
      (category) => category.id == transaction.categoryId,
      orElse: () => throw const CategoryNotExistException('Данной категории не существует'),
    );
    final account = await _accountsRepo.getById(transaction.accountId);
    return TransactionResponse(
      id: transaction.id,
      account: AccountBrief(
        id: transaction.accountId,
        name: account.name,
        balance: account.balance,
        currency: account.currency,
      ),
      category: category,
      amount: transaction.amount,
      transactionDate: transaction.transactionDate,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      comment: transaction.comment,
    );
  }

  @override
  Future<TransactionResponse> update({
    required int transactionId,
    required TransactionRequest transactionRequest,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final transactionIndex = _transactions.lastIndexWhere((transaction) => transaction.id == transactionId);
    if (transactionIndex == -1) {
      throw const TransactionNotExistException('Данной транзакции не существует');
    }
    final transaction = _transactions[transactionIndex];
    final account = await _accountsRepo.getById(transaction.accountId);
    final categories = await _categoriesRepo.getAll();
    final category = categories.firstWhere(
      (category) => category.id == transaction.categoryId,
      orElse: () => throw const CategoryNotExistException('Данной категории не существует'),
    );
    final updatedTransaction = Transaction(
      id: transaction.id,
      accountId: transaction.accountId,
      categoryId: transaction.categoryId,
      amount: transactionRequest.amount,
      transactionDate: transactionRequest.transactionDate,
      createdAt: transaction.createdAt,
      updatedAt: DateTime.now(),
      comment: transactionRequest.comment ?? transaction.comment,
    );
    _transactions[transactionIndex] = updatedTransaction;
    return TransactionResponse(
      id: transaction.id,
      account: AccountBrief(id: account.id, name: account.name, balance: account.balance, currency: account.currency),
      category: category,
      amount: updatedTransaction.amount,
      transactionDate: updatedTransaction.transactionDate,
      createdAt: updatedTransaction.createdAt,
      updatedAt: updatedTransaction.updatedAt,
      comment: updatedTransaction.comment,
    );
  }
}
