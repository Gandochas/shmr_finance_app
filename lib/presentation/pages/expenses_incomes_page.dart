import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transaction_list_tile.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transactions_sum_widget.dart';
import 'package:shmr_finance_app/domain/bloc/expenses_incomes/expenses_incomes_cubit.dart';
import 'package:shmr_finance_app/domain/bloc/history/history_cubit.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/presentation/pages/history_page.dart';

class ExpensesIncomesPage extends StatelessWidget {
  const ExpensesIncomesPage({required this.isIncomePage, super.key});

  final bool isIncomePage;

  void _navigateToHistoryPage(BuildContext context) {
    final transactionRepository = context.read<TransactionRepository>();
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
  }

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
                onPressed: () => _navigateToHistoryPage(context),
                icon: const Icon(Icons.history),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              return switch (state) {
                ExpensesIncomesLoadingState() => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                ExpensesIncomesErrorState() => Center(
                  child: Text(state.errorMessage),
                ),
                ExpensesIncomesIdleState(:final transactions) => Column(
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
                ),
              };
            },
          ),
        );
      },
    );
  }
}
