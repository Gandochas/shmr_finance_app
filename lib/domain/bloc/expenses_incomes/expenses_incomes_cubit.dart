import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';

part 'expenses_incomes_cubit.freezed.dart';

sealed class ExpensesIncomesState {
  const ExpensesIncomesState();
}

final class ExpensesIncomesLoadingState extends ExpensesIncomesState {
  const ExpensesIncomesLoadingState();
}

final class ExpensesIncomesErrorState extends ExpensesIncomesState {
  const ExpensesIncomesErrorState(this.errorMessage);

  final String errorMessage;
}

final class ExpensesIncomesIdleState extends ExpensesIncomesState {
  const ExpensesIncomesIdleState(this.transactions);

  final List<TransactionsOnScreen> transactions;
}

@freezed
abstract class TransactionsOnScreen with _$TransactionsOnScreen {
  const factory TransactionsOnScreen({
    required String emoji,
    required String categoryName,
    required String amount,
    required String currency,
    required bool isIncome,
    required String comment,
  }) = _TransactionsOnScreen;
}

extension TransactionsOnScreenX on TransactionResponse {
  TransactionsOnScreen toTransactionsOnScreen() => TransactionsOnScreen(
    emoji: category.emoji,
    categoryName: category.name,
    amount: amount,
    currency: account.currency,
    isIncome: category.isIncome,
    comment: comment ?? '',
  );
}

final class ExpensesIncomesCubit extends Cubit<ExpensesIncomesState> {
  ExpensesIncomesCubit({
    required TransactionRepository transactionRepository,
    required this.isIncomePage,
    this.accountId = 1,
  }) : _transactionRepository = transactionRepository,
       super(const ExpensesIncomesLoadingState());

  final TransactionRepository _transactionRepository;
  final bool isIncomePage;
  final int accountId;

  Future<void> loadTodayTransactions() async {
    emit(const ExpensesIncomesLoadingState());
    try {
      final now = DateTime.now();
      final transactions = await _transactionRepository.getByAccountIdAndPeriod(
        accountId: 1,
        startDate: DateTime(now.year, now.month, now.day),
        endDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
      );

      final newState = transactions
          .map((transaction) => transaction.toTransactionsOnScreen())
          .where((element) => element.isIncome == isIncomePage)
          .toList();

      emit(ExpensesIncomesIdleState(newState));
    } on Object {
      emit(const ExpensesIncomesErrorState('Something went wrong!'));
      rethrow;
    }
  }
}
