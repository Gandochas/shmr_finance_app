import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  // TODO: реализовать переход на экран истории в зависимости от текущего экрана
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
                  final transactions = state.transactions
                      .where(
                        (element) =>
                            isIncomePage ? element.isIncome : !element.isIncome,
                      )
                      .toList();
                  final transactionsSum = transactions.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + int.parse(element.amount),
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Всего',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                '$transactionsSum ${state.transactions.first.currency}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return ListTile(
                              leading: !isIncomePage
                                  ? Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        transaction.emoji,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    )
                                  : null,
                              title: Text(
                                transaction.categoryName,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              subtitle: transaction.comment.isNotEmpty
                                  ? Text(
                                      transaction.comment,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    )
                                  : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${transaction.amount} ${transaction.currency}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.navigate_next),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            // height: 1,
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
