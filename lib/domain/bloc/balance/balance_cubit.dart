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
    this.monthlyTransactionAmounts = const {},
  });

  final String name;
  final String balance;
  final String currency;
  final Map<DateTime, double> dailyTransactionAmounts;
  final Map<DateTime, double> monthlyTransactionAmounts;
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

  Future<void> updateAccountCurrency(String newCurrency) async {
    emit(const BalanceLoadingState());
    try {
      final bankAccount = await _bankAccountRepository.getById(accountId);

      final updatedAccount = await _bankAccountRepository.update(
        accountId: accountId,
        updateRequest: AccountUpdateRequest(
          name: bankAccount.name,
          balance: bankAccount.balance,
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
    } on Object catch (e, s) {
      emit(BalanceErrorState('Failed to change currency! \n$e: $s'));
      rethrow;
    }
  }

  Future<void> updateAccountName(String newAccountName) async {
    emit(const BalanceLoadingState());
    try {
      final bankAccount = await _bankAccountRepository.getById(accountId);

      final updatedAccount = await _bankAccountRepository.update(
        accountId: accountId,
        updateRequest: AccountUpdateRequest(
          name: newAccountName,
          balance: bankAccount.balance,
          currency: bankAccount.currency,
        ),
      );

      emit(
        BalanceIdleState(
          balance: updatedAccount.balance,
          currency: updatedAccount.currency,
          name: updatedAccount.name,
        ),
      );
    } on Object catch (e, s) {
      emit(BalanceErrorState('Failed to change account name! \n$e: $s'));
      rethrow;
    }
  }

  Future<void> loadAll() async {
    emit(const BalanceLoadingState());
    try {
      final bankAccount = await _bankAccountRepository.getById(accountId);
      final now = DateTime.now();

      final startDay = DateTime(now.year, now.month - 1, now.day);
      final endDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final lastMonthTransactions = await _transactionRepository
          .getByAccountIdAndPeriod(
            accountId: accountId,
            startDate: startDay,
            endDate: endDay,
          );
      final transactionsAmountsByDayMap = _computeDailyAmounts(
        startDay,
        endDay,
        lastMonthTransactions,
      );

      final startMonth = DateTime(now.year, now.month - 11, 1);

      final endMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      final lastYearTransactions = await _transactionRepository
          .getByAccountIdAndPeriod(
            accountId: accountId,
            startDate: startMonth,
            endDate: endMonth,
          );
      final transactionsAmountsByMonthMap = _computeMonthlyAmounts(
        startMonth,
        lastYearTransactions,
      );

      emit(
        BalanceIdleState(
          name: bankAccount.name,
          balance: bankAccount.balance,
          currency: bankAccount.currency,
          dailyTransactionAmounts: transactionsAmountsByDayMap,
          monthlyTransactionAmounts: transactionsAmountsByMonthMap,
        ),
      );
    } on Object catch (e, s) {
      emit(BalanceErrorState('Failed to load data! \n$e: $s'));
      rethrow;
    }
  }

  Map<DateTime, double> _computeDailyAmounts(
    DateTime startDate,
    DateTime endDate,
    List<TransactionResponse> transactions,
  ) {
    final transactionsAmountsByDayMap = <DateTime, double>{};
    for (
      var currentDate = startDate;
      currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate);
      currentDate = currentDate.add(const Duration(days: 1))
    ) {
      transactionsAmountsByDayMap[currentDate] = 0.0;
    }
    for (final transaction in transactions) {
      final currentDay = DateTime(
        transaction.transactionDate.year,
        transaction.transactionDate.month,
        transaction.transactionDate.day,
      );
      final amount =
          double.parse(transaction.amount) *
          (transaction.category.isIncome ? 1 : -1);
      transactionsAmountsByDayMap[currentDay] =
          (transactionsAmountsByDayMap[currentDay] ?? 0) + amount;
    }
    return transactionsAmountsByDayMap;
  }

  Map<DateTime, double> _computeMonthlyAmounts(
    DateTime startDate,
    List<TransactionResponse> transactions,
  ) {
    final endDate = DateTime(startDate.year, startDate.month + 12, 1);

    final transactionsAmountsByMonthMap = <DateTime, double>{};
    for (
      var currentDate = DateTime(startDate.year, startDate.month, 1);
      currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate);
      currentDate = DateTime(
        currentDate.year,
        currentDate.month + 1,
        currentDate.day,
      )
    ) {
      transactionsAmountsByMonthMap[currentDate] = 0.0;
    }

    for (final transaction in transactions) {
      final currentMonth = DateTime(
        transaction.transactionDate.year,
        transaction.transactionDate.month,
        1,
      );
      if (transactionsAmountsByMonthMap.containsKey(currentMonth)) {
        final amount =
            double.parse(transaction.amount) *
            (transaction.category.isIncome ? 1 : -1);
        transactionsAmountsByMonthMap[currentMonth] =
            transactionsAmountsByMonthMap[currentMonth]! + amount;
      }
    }

    return transactionsAmountsByMonthMap;
  }
}
