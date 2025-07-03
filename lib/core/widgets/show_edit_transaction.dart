import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/bloc/edit_transaction/edit_transaction_cubit.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/presentation/pages/edit_transaction_page.dart';

void showEditTransaction({
  required BuildContext context,
  required TransactionResponse transaction,
  required bool isIncomePage,
  required VoidCallback onReload,
}) {
  final bankAccountRepository = context.read<BankAccountRepository>();
  final categoryRepository = context.read<CategoryRepository>();
  final transactionRepository = context.read<TransactionRepository>();

  showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Редактировать транзакцию',
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: BlocProvider(
          create: (context) => EditTransactionCubit(
            bankAccountRepository: bankAccountRepository,
            categoryRepository: categoryRepository,
            transactionRepository: transactionRepository,
            isIncomePage: isIncomePage,
          ),
          child: Builder(
            builder: (context) {
              return EditTransactionPage(
                transaction: transaction,
                isIncomePage: isIncomePage,
                onSave: (updatedTransactionRequest) async {
                  await context.read<EditTransactionCubit>().updateTransaction(
                    updatedTransactionRequest,
                  );
                },
                onDelete: () async {
                  await context.read<EditTransactionCubit>().deleteTransaction(
                    transaction.id,
                  );
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
  ).then((value) {
    onReload();
  });
}
