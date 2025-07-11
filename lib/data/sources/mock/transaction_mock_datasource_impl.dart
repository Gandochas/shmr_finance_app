import 'package:shmr_finance_app/core/extensions/core_extensions.dart';
import 'package:shmr_finance_app/domain/models/account_brief/account_brief.dart';
import 'package:shmr_finance_app/domain/models/transaction/transaction.dart';
import 'package:shmr_finance_app/domain/models/transaction_request/transaction_request.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/domain/sources/bank_account_datasource.dart';
import 'package:shmr_finance_app/domain/sources/category_datasource.dart';
import 'package:shmr_finance_app/domain/sources/transaction_datasource.dart';
import 'package:uuid/uuid.dart';

final class TransactionMockDatasourceImpl implements TransactionDatasource {
  TransactionMockDatasourceImpl({
    required CategoryDatasource categoriesSource,
    required BankAccountDatasource accountsSource,
  }) : _categoriesSource = categoriesSource,
       _accountsSource = accountsSource;

  final CategoryDatasource _categoriesSource;
  final BankAccountDatasource _accountsSource;

  final _transactions = <Transaction>[
    Transaction(
      id: 1,
      accountId: 1,
      categoryId: 1,
      amount: '100000',
      comment: 'тест',
      transactionDate: DateTime(2025, 6, 15),
      createdAt: DateTime(2025, 6, 15),
      updatedAt: DateTime(2025, 6, 15),
    ),
    Transaction(
      id: 2,
      accountId: 1,
      categoryId: 2,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 15),
      createdAt: DateTime(2025, 6, 15),
      updatedAt: DateTime(2025, 6, 15),
    ),
    Transaction(
      id: 3,
      accountId: 1,
      categoryId: 2,
      amount: '100000',
      comment: 'Платье',
      transactionDate: DateTime(2025, 6, 15),
      createdAt: DateTime(2025, 6, 15),
      updatedAt: DateTime(2025, 6, 15),
    ),
    Transaction(
      id: 4,
      accountId: 1,
      categoryId: 2,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 15),
      createdAt: DateTime(2025, 6, 15),
      updatedAt: DateTime(2025, 6, 15),
    ),
    Transaction(
      id: 5,
      accountId: 1,
      categoryId: 3,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 15),
      createdAt: DateTime(2025, 6, 15),
      updatedAt: DateTime(2025, 6, 15),
    ),
    Transaction(
      id: 6,
      accountId: 1,
      categoryId: 3,
      amount: '500000',
      transactionDate: DateTime(2025, 6, 19),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 7,
      accountId: 1,
      categoryId: 1,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 20),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 8,
      accountId: 1,
      categoryId: 1,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 21),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 9,
      accountId: 1,
      categoryId: 1,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 22),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 10,
      accountId: 1,
      categoryId: 1,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 23),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 11,
      accountId: 1,
      categoryId: 1,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 24),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 12,
      accountId: 1,
      categoryId: 3,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 25),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 13,
      accountId: 1,
      categoryId: 1,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 25),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 14,
      accountId: 1,
      categoryId: 1,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 26),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 15,
      accountId: 1,
      categoryId: 1,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 26),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 16,
      accountId: 1,
      categoryId: 1,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 26),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 17,
      accountId: 1,
      categoryId: 1,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 27),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 18,
      accountId: 1,
      categoryId: 3,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 28),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 19,
      accountId: 1,
      categoryId: 3,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 28),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 20,
      accountId: 1,
      categoryId: 1,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 28),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 21,
      accountId: 1,
      categoryId: 3,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 28),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 22,
      accountId: 1,
      categoryId: 3,
      amount: '100000',
      transactionDate: DateTime(2025, 6, 4),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
    Transaction(
      id: 23,
      accountId: 1,
      categoryId: 3,
      amount: '5000000',
      transactionDate: DateTime(2025, 6, 7),
      createdAt: DateTime(2025, 6, 19),
      updatedAt: DateTime(2025, 6, 19),
    ),
  ];

  @override
  Future<Transaction> create(TransactionRequest transactionRequest) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final newTransaction = Transaction(
      id: const Uuid().v4().hashCode,
      accountId: transactionRequest.accountId,
      categoryId: transactionRequest.categoryId,
      amount: transactionRequest.amount,
      transactionDate: transactionRequest.transactionDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      comment: transactionRequest.comment,
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
    final account = await _accountsSource.getById(accountId);
    final categories = await _categoriesSource.getAll();
    final now = DateTime.now();
    startDate ??= DateTime(now.year, now.month);
    endDate ??= DateTime(now.year, now.month + 1, 0);
    final neededTransactions = _transactions
        .where((transaction) => transaction.accountId == accountId)
        .where((transaction) => transaction.transactionDate >= startDate!)
        .where((transaction) => transaction.transactionDate <= endDate!);

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
            orElse: () => throw const CategoryNotExistException(
              'Данной категории не существует',
            ),
          ),
          comment: transaction.comment,
          amount: transaction.amount,
          transactionDate: transaction.transactionDate,
          createdAt: transaction.createdAt,
          updatedAt: transaction.updatedAt,
        ),
      );
    }
    return transactionsList;
  }

  @override
  Future<TransactionResponse> getById(int transactionId) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final transaction = _transactions.firstWhere(
      (transaction) => transaction.id == transactionId,
      orElse: () => throw const TransactionNotExistException(
        'Данной транзакции не существует',
      ),
    );
    final categories = await _categoriesSource.getAll();
    final category = categories.firstWhere(
      (category) => category.id == transaction.categoryId,
      orElse: () => throw const CategoryNotExistException(
        'Данной категории не существует',
      ),
    );
    final account = await _accountsSource.getById(transaction.accountId);
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
    final transactionIndex = _transactions.lastIndexWhere(
      (transaction) => transaction.id == transactionId,
    );
    if (transactionIndex == -1) {
      throw const TransactionNotExistException(
        'Данной транзакции не существует',
      );
    }
    final transaction = _transactions[transactionIndex];
    final account = await _accountsSource.getById(transaction.accountId);
    final categories = await _categoriesSource.getAll();
    final category = categories.firstWhere(
      (category) => category.id == transaction.categoryId,
      orElse: () => throw const CategoryNotExistException(
        'Данной категории не существует',
      ),
    );
    final updatedTransaction = Transaction(
      id: transaction.id,
      accountId: transaction.accountId,
      categoryId: transactionRequest.categoryId,
      amount: transactionRequest.amount,
      transactionDate: transactionRequest.transactionDate,
      createdAt: transaction.createdAt,
      updatedAt: DateTime.now(),
      comment: transactionRequest.comment,
    );
    _transactions[transactionIndex] = updatedTransaction;
    return TransactionResponse(
      id: transaction.id,
      account: AccountBrief(
        id: account.id,
        name: account.name,
        balance: account.balance,
        currency: account.currency,
      ),
      category: category,
      amount: updatedTransaction.amount,
      transactionDate: updatedTransaction.transactionDate,
      createdAt: updatedTransaction.createdAt,
      updatedAt: updatedTransaction.updatedAt,
      comment: updatedTransaction.comment,
    );
  }
}
