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

  Future<void> loadAll() async {
    emit(const BalanceLoadingState());
    try {
      final account = await _bankAccountRepository.getById(accountId);
      final now = DateTime.now();

      final startDay = DateTime(now.year, now.month - 1, now.day);
      final endDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final txDay = await _transactionRepository.getByAccountIdAndPeriod(
        accountId: accountId,
        startDate: startDay,
        endDate: endDay,
      );
      final dailyMap = _computeDailyAmounts(startDay, endDay, txDay);

      final startMonth = DateTime(now.year, now.month - 11, 1);

      final endMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      final txMonth = await _transactionRepository.getByAccountIdAndPeriod(
        accountId: accountId,
        startDate: startMonth,
        endDate: endMonth,
      );
      final monthlyMap = _computeMonthlyAmounts(startMonth, txMonth);

      emit(
        BalanceIdleState(
          name: account.name,
          balance: account.balance,
          currency: account.currency,
          dailyTransactionAmounts: dailyMap,
          monthlyTransactionAmounts: monthlyMap,
        ),
      );
    } catch (e) {
      emit(const BalanceErrorState('Failed to load data'));
      rethrow;
    }
  }

  Map<DateTime, double> _computeDailyAmounts(
    DateTime start,
    DateTime end,
    List<TransactionResponse> txs,
  ) {
    final map = <DateTime, double>{};
    for (
      var d = start;
      d.isBefore(end) || d.isAtSameMomentAs(end);
      d = d.add(const Duration(days: 1))
    ) {
      map[d] = 0.0;
    }
    for (final tx in txs) {
      final day = DateTime(
        tx.transactionDate.year,
        tx.transactionDate.month,
        tx.transactionDate.day,
      );
      final amt = double.parse(tx.amount) * (tx.category.isIncome ? 1 : -1);
      map[day] = (map[day] ?? 0) + amt;
    }
    return map;
  }

  Map<DateTime, double> _computeMonthlyAmounts(
    DateTime start,
    List<TransactionResponse> txs,
  ) {
    final end = DateTime(start.year, start.month + 12, 1);

    final map = <DateTime, double>{};
    for (
      var d = DateTime(start.year, start.month, 1);
      d.isBefore(end) || d.isAtSameMomentAs(end);
      d = DateTime(d.year, d.month + 1, d.day)
    ) {
      map[d] = 0.0;
    }

    for (final tx in txs) {
      final month = DateTime(
        tx.transactionDate.year,
        tx.transactionDate.month,
        1,
      );
      if (map.containsKey(month)) {
        final amt = double.parse(tx.amount) * (tx.category.isIncome ? 1 : -1);
        map[month] = map[month]! + amt;
      }
    }

    return map;
  }
}
