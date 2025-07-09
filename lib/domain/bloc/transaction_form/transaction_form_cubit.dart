import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/models/account/account.dart';
import 'package:shmr_finance_app/domain/models/category/category.dart';
import 'package:shmr_finance_app/domain/models/transaction_request/transaction_request.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';

sealed class TransactionFormState {
  const TransactionFormState();
}

final class TransactionFormLoadingState extends TransactionFormState {
  const TransactionFormLoadingState();
}

final class TransactionFormErrorState extends TransactionFormState {
  const TransactionFormErrorState(this.errorMessage);

  final String errorMessage;
}

final class TransactionFormIdleState extends TransactionFormState {
  const TransactionFormIdleState({
    required this.accounts,
    required this.categories,
  });
  final List<Account> accounts;
  final List<Category> categories;
}

final class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit({
    required BankAccountRepository bankAccountRepository,
    required CategoryRepository categoryRepository,
    required TransactionRepository transactionRepository,
    required bool isIncomePage,
  }) : _bankAccountRepository = bankAccountRepository,
       _categoryRepository = categoryRepository,
       _transactionRepository = transactionRepository,
       _isIncomePage = isIncomePage,
       super(const TransactionFormLoadingState()) {
    loadData();
  }

  final BankAccountRepository _bankAccountRepository;
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;
  final bool _isIncomePage;

  Future<void> loadData() async {
    emit(const TransactionFormLoadingState());
    try {
      final accounts = await _bankAccountRepository.getAll();
      final categories = await _categoryRepository.getByType(
        isIncome: _isIncomePage,
      );
      emit(
        TransactionFormIdleState(accounts: accounts, categories: categories),
      );
    } on Object catch (e, s) {
      emit(
        TransactionFormErrorState('Failed to load data repositories! \n$e: $s'),
      );
    }
  }

  Future<void> updateTransaction({
    required int transactionId,
    required TransactionRequest updateRequest,
  }) async {
    emit(const TransactionFormLoadingState());
    try {
      await _transactionRepository.update(
        transactionId: transactionId,
        transactionRequest: updateRequest,
      );
      await loadData();
    } on Object catch (e, s) {
      emit(TransactionFormErrorState('Failed to update transaction! \n$e: $s'));
    }
  }

  Future<void> deleteTransaction(int transactionId) async {
    emit(const TransactionFormLoadingState());
    try {
      await _transactionRepository.delete(transactionId);
      await loadData();
    } on Object catch (e, s) {
      emit(TransactionFormErrorState('Failed to delete transaction! \n$e: $s'));
    }
  }

  Future<void> createTransaction(TransactionRequest createRequest) async {
    emit(const TransactionFormLoadingState());
    try {
      await _transactionRepository.create(createRequest);
      await loadData();
    } on Object catch (e, s) {
      emit(TransactionFormErrorState('Failed to create transaction! \n$e: $s'));
    }
  }
}
