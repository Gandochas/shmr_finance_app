import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/bloc/transaction_form/transaction_form_cubit.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/presentation/pages/transaction_form_page.dart';

void showTransactionForm({
  required BuildContext context,
  required bool isIncomePage,
  required VoidCallback onReload,
  TransactionResponse? transaction,
}) {
  final bankAccountRepository = context.read<BankAccountRepository>();
  final categoryRepository = context.read<CategoryRepository>();
  final transactionRepository = context.read<TransactionRepository>();

  showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: transaction == null
        ? 'Добавить транзакцию'
        : 'Редактировать транзакцию',
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: BlocProvider<TransactionFormCubit>(
          create: (context) => TransactionFormCubit(
            bankAccountRepository: bankAccountRepository,
            categoryRepository: categoryRepository,
            transactionRepository: transactionRepository,
            isIncomePage: isIncomePage,
          )..loadData(),
          child: Builder(
            builder: (context) {
              return TransactionFormPage(
                transaction: transaction,
                isIncomePage: isIncomePage,
                onSave: (request) async {
                  if (transaction == null) {
                    await context
                        .read<TransactionFormCubit>()
                        .createTransaction(request);
                  } else {
                    await context
                        .read<TransactionFormCubit>()
                        .updateTransaction(
                          transactionId: transaction.id,
                          updateRequest: request,
                        );
                  }
                },
                onDelete: () async {
                  if (transaction != null) {
                    await context
                        .read<TransactionFormCubit>()
                        .deleteTransaction(transaction.id);
                  }
                },
              );
            },
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  ).then((_) {
    onReload();
  });
}
