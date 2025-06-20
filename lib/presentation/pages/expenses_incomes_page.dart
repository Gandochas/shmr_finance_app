import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/widgets/transaction_list_tile.dart';
import 'package:shmr_finance_app/core/widgets/transactions_sum_widget.dart';
import 'package:shmr_finance_app/domain/bloc/expenses_incomes/expenses_incomes_cubit.dart';
import 'package:shmr_finance_app/domain/bloc/history/history_cubit.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/presentation/pages/history_page.dart';

class ExpensesIncomesPage extends StatelessWidget {
  const ExpensesIncomesPage({required this.isIncomePage, super.key});

  final bool isIncomePage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesIncomesCubit, ExpensesIncomesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(
              isIncomePage ? 'Доходы сегодня' : 'Расходы сегодня',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  final transactionRepository = context
                      .read<TransactionRepository>();
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (context) => RepositoryProvider.value(
                        value: transactionRepository,
                        child: BlocProvider(
                          create: (context) => HistoryCubit(
                            transactionRepository: transactionRepository,
                            isIncomePage: isIncomePage,
                          )..loadHistory(),
                          child: HistoryPage(isIncomePage: isIncomePage),
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.history),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              switch (state) {
                case ExpensesIncomesLoadingState():
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                case ExpensesIncomesErrorState():
                  return Center(child: Text(state.errorMessage));
                case ExpensesIncomesIdleState():
                  final transactions = state.transactions;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TransactionsSumWidget(transactions: transactions),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return TransactionListTile(
                              isIncomePage: isIncomePage,
                              transaction: transaction,
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          itemCount: transactions.length,
                        ),
                      ),
                    ],
                  );
              }
            },
          ),
        );
      },
    );
  }
}
