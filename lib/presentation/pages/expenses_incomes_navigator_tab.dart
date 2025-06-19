import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/bloc/expenses_incomes/expenses_incomes_cubit.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/presentation/pages/expenses_incomes_page.dart';

class ExpensesIncomesNavigatorTab extends StatelessWidget {
  const ExpensesIncomesNavigatorTab({required this.isIncomePage, super.key});

  final bool isIncomePage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpensesIncomesCubit(
        transactionRepository: context.read<TransactionRepository>(),
        isIncomePage: isIncomePage,
      )..loadTodayTransactions(),
      child: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) =>
                ExpensesIncomesPage(isIncomePage: isIncomePage),
          );
        },
      ),
    );
  }
}
