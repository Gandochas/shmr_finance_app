import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';

sealed class HistoryState {
  const HistoryState();
}

final class HistoryLoadingState extends HistoryState {
  const HistoryLoadingState();
}

final class HistoryErrorState extends HistoryState {
  const HistoryErrorState(this.errorMessage);

  final String errorMessage;
}

final class HistoryIdleState extends HistoryState {
  HistoryIdleState({
    required this.transactions,
    required this.startDate,
    required this.endDate,
  });

  final List<TransactionResponse> transactions;
  final DateTime startDate;
  final DateTime endDate;
}

final class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({
    required TransactionRepository transactionRepository,
    required this.isIncomePage,
    this.accountId = 1,
  }) : _transactionRepository = transactionRepository,
       super(const HistoryLoadingState()) {
    final now = DateTime.now();
    _start = DateTime(now.year, now.month - 1, now.day);
    _end = DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  final TransactionRepository _transactionRepository;
  final bool isIncomePage;
  final int accountId;

  late DateTime _start;
  late DateTime _end;

  Future<void> loadHistory() async {
    emit(const HistoryLoadingState());
    try {
      final transactions = await _transactionRepository.getByAccountIdAndPeriod(
        accountId: accountId,
        startDate: _start,
        endDate: _end,
      );

      final newState = transactions
          .where((transaction) => transaction.category.isIncome == isIncomePage)
          .toList();

      emit(
        HistoryIdleState(
          transactions: newState,
          startDate: _start,
          endDate: _end,
        ),
      );
    } on Object catch (e, s) {
      emit(HistoryErrorState('Failed to load transactions history! \n$e: $s'));
      rethrow;
    }
  }

  void updateStart(DateTime date) {
    _start = DateTime(date.year, date.month, date.day);
    loadHistory();
  }

  void updateEnd(DateTime date) {
    _end = DateTime(date.year, date.month, date.day, 23, 59, 59);
    loadHistory();
  }
}
