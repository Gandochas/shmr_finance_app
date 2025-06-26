import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/models/account_update_request/account_update_request.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';

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
  BalanceIdleState({required this.balance, required this.currency});

  final String balance;
  final String currency;
}

final class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit({
    required BankAccountRepository bankAccountRepository,

    this.accountId = 1,
  }) : _bankAccountRepository = bankAccountRepository,
       super(const BalanceLoadingState());

  final BankAccountRepository _bankAccountRepository;
  final int accountId;

  Future<void> loadBalance() async {
    emit(const BalanceLoadingState());

    try {
      final account = await _bankAccountRepository.getById(accountId);

      emit(
        BalanceIdleState(balance: account.balance, currency: account.currency),
      );
    } on Object {
      emit(const BalanceErrorState('Failed to load the balance'));
      rethrow;
    }
  }

  Future<void> updateCurrency(String newCurrency) async {
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
        ),
      );
    } on Object {
      emit(const BalanceErrorState('Failed to change currency!'));
      rethrow;
    }
  }
}
