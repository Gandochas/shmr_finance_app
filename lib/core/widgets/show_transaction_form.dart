import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/bloc/transaction_form/transaction_form_cubit.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/domain/repositories/bank_account_repository.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/presentation/pages/transaction_form_page.dart';

// void showEditTransaction({
//   required BuildContext context,
//   required TransactionResponse transaction,
//   required bool isIncomePage,
//   required VoidCallback onReload,
// }) {
//   final bankAccountRepository = context.read<BankAccountRepository>();
//   final categoryRepository = context.read<CategoryRepository>();
//   final transactionRepository = context.read<TransactionRepository>();

//   showGeneralDialog<void>(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: 'Редактировать транзакцию',
//     pageBuilder: (context, animation, secondaryAnimation) {
//       return SafeArea(
//         child: BlocProvider(
//           create: (context) => TransactionFormCubit(
//             bankAccountRepository: bankAccountRepository,
//             categoryRepository: categoryRepository,
//             transactionRepository: transactionRepository,
//             isIncomePage: isIncomePage,
//           ),
//           child: Builder(
//             builder: (context) {
//               return TransactionFormPage(
//                 transaction: transaction,
//                 isIncomePage: isIncomePage,
//                 onSave: (updatedTransactionRequest) async {
//                   await context.read<TransactionFormCubit>().updateTransaction(
//                     updatedTransactionRequest,
//                   );
//                 },
//                 onDelete: () async {
//                   await context.read<TransactionFormCubit>().deleteTransaction(
//                     transaction.id,
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       );
//     },
//     transitionBuilder: (context, animation, secondaryAnimation, child) {
//       final curved = CurvedAnimation(
//         parent: animation,
//         curve: Curves.easeOutCubic,
//       );
//       return SlideTransition(
//         position: Tween<Offset>(
//           begin: const Offset(0, 1),
//           end: Offset.zero,
//         ).animate(curved),
//         child: child,
//       );
//     },
//   ).then((value) {
//     onReload();
//   });
// }

// void showAddTransaction({
//   required BuildContext context,
//   required bool isIncomePage,
//   required VoidCallback onReload,
// }) {
//   final bankAccountRepository = context.read<BankAccountRepository>();
//   final categoryRepository = context.read<CategoryRepository>();
//   final transactionRepository = context.read<TransactionRepository>();

//   showGeneralDialog<void>(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: 'Добавить транзакцию',
//     pageBuilder: (context, animation, secondaryAnimation) => SafeArea(
//       child: BlocProvider(
//         create: (context) => TransactionFormCubit(
//           bankAccountRepository: bankAccountRepository,
//           categoryRepository: categoryRepository,
//           transactionRepository: transactionRepository,
//           isIncomePage: isIncomePage,
//         ),
//         child: Builder(
//           builder: (context) {
//             return TransactionFormPage(
//               transaction: TransactionResponse(
//                 id: 0,
//                 account: const AccountBrief(
//                   id: 1,
//                   name: '',
//                   balance: '',
//                   currency: '',
//                 ),
//                 category: Category(
//                   id: 0,
//                   name: '',
//                   emoji: '',
//                   isIncome: isIncomePage,
//                 ),
//                 amount: '',
//                 transactionDate: DateTime.now(),
//                 createdAt: DateTime.now(),
//                 updatedAt: DateTime.now(),
//                 comment: null,
//               ),
//               isIncomePage: isIncomePage,
//               isNewTransaction: true,
//               onSave: (request) async {
//                 await context.read<TransactionFormCubit>().createTransaction(
//                   request,
//                 );
//               },
//               onDelete: () async {}, // безуспешный noop
//             );
//           },
//         ),
//       ),
//     ),
//     transitionBuilder: (context, animation, secondaryAnimation, child) {
//       final curved = CurvedAnimation(
//         parent: animation,
//         curve: Curves.easeOutCubic,
//       );
//       return SlideTransition(
//         position: Tween<Offset>(
//           begin: const Offset(0, 1),
//           end: Offset.zero,
//         ).animate(curved),
//         child: child,
//       );
//     },
//   ).then((_) => onReload());
// }

void showTransactionForm({
  required BuildContext context,
  required bool isIncomePage,
  // required bool isNewTransaction,
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
                // isNewTransaction: isNewTransaction,
                onSave: (request) async {
                  if (transaction == null) {
                    await context
                        .read<TransactionFormCubit>()
                        .createTransaction(request);
                  } else {
                    await context
                        .read<TransactionFormCubit>()
                        .updateTransaction(request);
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
