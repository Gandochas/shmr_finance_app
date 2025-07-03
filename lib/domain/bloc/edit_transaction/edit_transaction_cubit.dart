import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/models/account/account.dart';
import 'package:shmr_finance_app/domain/models/category/category.dart';
import 'package:shmr_finance_app/domain/models/transaction_request/transaction_request.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';

sealed class EditTransactionState {
  const EditTransactionState();
}

final class EditTransactionLoadingState extends EditTransactionState {
  const EditTransactionLoadingState();
}

final class EditTransactionErrorState extends EditTransactionState {
  const EditTransactionErrorState(this.errorMessage);

  final String errorMessage;
}

final class EditTransactionIdleState extends EditTransactionState {
  const EditTransactionIdleState({
    required this.accounts,
    required this.categories,
  });
  final List<Account> accounts;
  final List<Category> categories;
}

final class EditTransactionCubit extends Cubit<EditTransactionState> {
  EditTransactionCubit({
    required BankAccountRepository bankAccountRepository,
    required CategoryRepository categoryRepository,
    required TransactionRepository transactionRepository,
    required bool isIncomePage,
  }) : _bankAccountRepository = bankAccountRepository,
       _categoryRepository = categoryRepository,
       _transactionRepository = transactionRepository,
       _isIncomePage = isIncomePage,
       super(const EditTransactionLoadingState()) {
    loadData();
  }

  final BankAccountRepository _bankAccountRepository;
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;
  final bool _isIncomePage;

  Future<void> loadData() async {
    emit(const EditTransactionLoadingState());
    try {
      final accounts = await _bankAccountRepository.getAll();
      final categories = await _categoryRepository.getByType(
        isIncome: _isIncomePage,
      );
      emit(
        EditTransactionIdleState(accounts: accounts, categories: categories),
      );
    } on Object {
      emit(const EditTransactionErrorState('Не удалось загрузить репозитории'));
    }
  }

  Future<void> updateTransaction(TransactionRequest req) async {
    emit(const EditTransactionLoadingState());
    try {
      await _transactionRepository.update(
        transactionId: req.id,
        transactionRequest: req,
      );
      await loadData();
    } on Object {
      emit(const EditTransactionErrorState('Не удалось сохранить изменения'));
    }
  }

  Future<void> deleteTransaction(int id) async {
    emit(const EditTransactionLoadingState());
    try {
      await _transactionRepository.delete(id);
      await loadData();
    } on Object {
      emit(const EditTransactionErrorState('Не удалось удалить транзакцию'));
    }
  }
}
