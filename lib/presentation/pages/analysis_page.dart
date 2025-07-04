import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/widgets/charts/category_pie_chart.dart';
import 'package:shmr_finance_app/core/widgets/show_transaction_form.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transaction_date_choice_widget.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transaction_list_tile.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transactions_sum_widget.dart';
import 'package:shmr_finance_app/domain/bloc/history/history_cubit.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({required this.isIncomePage, super.key});

  final bool isIncomePage;

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final _expandedCategories = <String>{};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Анализ'),
            centerTitle: true,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          ),
          body: Builder(
            builder: (context) {
              return switch (state) {
                HistoryLoadingState() => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                HistoryErrorState() => Center(child: Text(state.errorMessage)),
                HistoryIdleState(
                  :final transactions,
                  :final startDate,
                  :final endDate,
                ) =>
                  Builder(
                    builder: (context) {
                      final groupingByCategory =
                          <String, List<TransactionResponse>>{};

                      for (final transaction in transactions) {
                        groupingByCategory
                            .putIfAbsent(transaction.category.name, () => [])
                            .add(transaction);
                      }

                      final categoryNames = groupingByCategory.keys.toList();

                      final amountsByCategory = <double>[];

                      for (final category in groupingByCategory.keys) {
                        final categoryTransactions =
                            groupingByCategory[category];

                        final sum =
                            categoryTransactions?.fold<double>(
                              0,
                              (previousValue, transaction) =>
                                  previousValue +
                                  double.parse(transaction.amount),
                            ) ??
                            0;
                        amountsByCategory.add(sum);
                      }

                      final totalTransactionsSum = amountsByCategory
                          .fold<double>(
                            0,
                            (previousValue, element) => previousValue + element,
                          );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TransactionDateChoiceWidget(
                            title: 'Начало',
                            initialDate: startDate,
                            firstDate: DateTime(2000),
                            lastDate: endDate,
                            isStartDate: true,
                          ),

                          TransactionDateChoiceWidget(
                            title: 'Конец',
                            initialDate: endDate,
                            firstDate: startDate,
                            lastDate: DateTime.now(),
                            isStartDate: false,
                          ),

                          TransactionsSumWidget(transactions: transactions),

                          CategoryPieChart(
                            amountsByCategory: amountsByCategory,
                            categoryNames: categoryNames,
                          ),
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                final groupName = categoryNames[index];
                                final transactionsByCategoryName =
                                    groupingByCategory[groupName]!..sort(
                                      (a, b) => a.transactionDate.compareTo(
                                        b.transactionDate,
                                      ),
                                    );
                                final isExpanded = _expandedCategories.contains(
                                  groupName,
                                );
                                final sumByCategory = transactionsByCategoryName
                                    .fold<int>(
                                      0,
                                      (previousValue, element) =>
                                          previousValue +
                                          int.parse(element.amount),
                                    );
                                return Column(
                                  children: [
                                    TransactionListTile(
                                      isIncomePage: widget.isIncomePage,
                                      percentage:
                                          (sumByCategory /
                                              totalTransactionsSum) *
                                          100,
                                      transaction:
                                          transactionsByCategoryName.last,
                                      iconButton: IconButton(
                                        icon: Icon(
                                          isExpanded
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (isExpanded) {
                                              _expandedCategories.remove(
                                                groupName,
                                              );
                                            } else {
                                              _expandedCategories.add(
                                                groupName,
                                              );
                                            }
                                          });
                                        },
                                      ),
                                      isHeader: true,
                                      sumByCategory: sumByCategory,
                                    ),
                                    if (isExpanded)
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            transactionsByCategoryName.length,
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                              height: 1,
                                              color: Theme.of(
                                                context,
                                              ).dividerColor,
                                            ),
                                        itemBuilder: (context, index) {
                                          final transaction =
                                              transactionsByCategoryName[index];
                                          return TransactionListTile(
                                            isIncomePage: widget.isIncomePage,
                                            transaction: transaction,
                                            iconButton: IconButton(
                                              onPressed: () =>
                                                  showTransactionForm(
                                                    context: context,
                                                    transaction: transaction,
                                                    isIncomePage:
                                                        widget.isIncomePage,
                                                    onReload: () => context
                                                        .read<HistoryCubit>()
                                                        .loadHistory(),
                                                  ),
                                              icon: const Icon(
                                                Icons.navigate_next,
                                              ),
                                            ),
                                            isHeader: false,
                                          );
                                        },
                                      ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                color: Theme.of(context).dividerColor,
                                height: 1,
                              ),
                              itemCount: categoryNames.length,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              };
            },
          ),
        );
      },
    );
  }
}
