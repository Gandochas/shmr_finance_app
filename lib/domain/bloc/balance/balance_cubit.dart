import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/models/account_update_request/account_update_request.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';

sealed class BalanceState {
  const BalanceState();
}

final class BalanceLoadingState extends BalanceState {
  const BalanceLoadingState();
}

final class BalanceErrorState extends BalanceState {
  const BalanceErrorState(this.errorMessage);

  final String errorMessage;
}

final class BalanceIdleState extends BalanceState {
  BalanceIdleState({
    required this.name,
    required this.balance,
    required this.currency,
    this.dailyTransactionAmounts = const {},
  });

  final String name;
  final String balance;
  final String currency;
  final Map<DateTime, double> dailyTransactionAmounts;
}

final class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit({
    required BankAccountRepository bankAccountRepository,
    required TransactionRepository transactionRepository,

    this.accountId = 1,
  }) : _bankAccountRepository = bankAccountRepository,
       _transactionRepository = transactionRepository,
       super(const BalanceLoadingState());

  final BankAccountRepository _bankAccountRepository;
  final TransactionRepository _transactionRepository;
  final int accountId;

  Future<void> loadBalance() async {
    emit(const BalanceLoadingState());

    try {
      final account = await _bankAccountRepository.getById(accountId);

      emit(
        BalanceIdleState(
          balance: account.balance,
          currency: account.currency,
          name: account.name,
        ),
      );
    } on Object {
      emit(const BalanceErrorState('Failed to load the balance'));
      rethrow;
    }
  }

  Future<void> updateAccountCurrency(String newCurrency) async {
    emit(const BalanceLoadingState());
    try {
      final account = await _bankAccountRepository.getById(accountId);

      final updatedAccount = await _bankAccountRepository.update(
        accountId: accountId,
        updateRequest: AccountUpdateRequest(
          name: account.name,
          balance: account.balance,
          currency: newCurrency,
        ),
      );

      emit(
        BalanceIdleState(
          balance: updatedAccount.balance,
          currency: updatedAccount.currency,
          name: updatedAccount.name,
        ),
      );
    } on Object {
      emit(const BalanceErrorState('Failed to change currency!'));
      rethrow;
    }
  }

  Future<void> updateAccountName(String newAccountName) async {
    emit(const BalanceLoadingState());
    try {
      final account = await _bankAccountRepository.getById(accountId);

      final updatedAccount = await _bankAccountRepository.update(
        accountId: accountId,
        updateRequest: AccountUpdateRequest(
          name: newAccountName,
          balance: account.balance,
          currency: account.currency,
        ),
      );

      emit(
        BalanceIdleState(
          balance: updatedAccount.balance,
          currency: updatedAccount.currency,
          name: updatedAccount.name,
        ),
      );
    } on Object {
      emit(const BalanceErrorState('Failed to change account name!'));
      rethrow;
    }
  }

  Future<List<TransactionResponse>> getTransactionsForLastMonth() async {
    emit(const BalanceLoadingState());
    try {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month - 1, now.day);
      final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final transactions = await _transactionRepository.getByAccountIdAndPeriod(
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
      );

      final account = await _bankAccountRepository.getById(accountId);
      final dailyAmounts = _getDailyTransactionAmounts(transactions);

      emit(
        BalanceIdleState(
          name: account.name,
          balance: account.balance,
          currency: account.currency,
          dailyTransactionAmounts: dailyAmounts,
        ),
      );

      return transactions;
    } on Object {
      emit(const BalanceErrorState('Failed to load transactions.'));
      rethrow;
    }
  }

  // Map<DateTime, double> _getDailyTransactionAmounts(
  //   List<TransactionResponse> transactions,
  // ) {
  //   final dailyAmounts = <DateTime, double>{};

  //   for (final transaction in transactions) {
  //     final transactionDate = transaction.transactionDate;
  //     final amount = double.parse(transaction.amount);

  //     final adjustedAmount = transaction.category.isIncome ? amount : -amount;

  //     if (dailyAmounts.containsKey(transactionDate)) {
  //       dailyAmounts[transactionDate] =
  //           dailyAmounts[transactionDate]! + adjustedAmount;
  //     } else {
  //       dailyAmounts[transactionDate] = adjustedAmount;
  //     }
  //   }

  //   return dailyAmounts;
  // }

  Map<DateTime, double> _getDailyTransactionAmounts(
    List<TransactionResponse> transactions,
  ) {
    final dailyAmounts = <DateTime, double>{};

    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - 1, now.day);
    final endDate = DateTime(now.year, now.month, now.day);

    // Проходим по всем дням в месяце
    for (
      var date = startDate;
      date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
      date = date.add(const Duration(days: 1))
    ) {
      dailyAmounts[date] = 0.0;
    }

    for (final transaction in transactions) {
      final transactionDate = transaction.transactionDate;
      final amount = double.parse(transaction.amount);

      final adjustedAmount = transaction.category.isIncome ? amount : -amount;

      if (dailyAmounts.containsKey(transactionDate)) {
        dailyAmounts[transactionDate] =
            dailyAmounts[transactionDate]! + adjustedAmount;
      } else {
        dailyAmounts[transactionDate] = adjustedAmount;
      }
    }

    return dailyAmounts;
  }
}
