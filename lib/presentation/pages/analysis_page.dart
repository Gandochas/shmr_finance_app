// import 'package:category_chart/category_chart.dart';

import 'package:category_chart/category_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _AnalysisPageState extends State<AnalysisPage>
    with SingleTickerProviderStateMixin {
  final _expandedCategories = <String>{};
  List<TransactionResponse> _cachedTransactions = [];
  late final AnimationController _chartController;

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    context.read<HistoryCubit>().loadHistory();
  }

  @override
  void dispose() {
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Анализ'), centerTitle: true),
      body: BlocConsumer<HistoryCubit, HistoryState>(
        listener: (context, state) {
          if (state is HistoryLoadingState) {
            _chartController.repeat();
          }
          if (state is HistoryIdleState) {
            _chartController.stop();
            _cachedTransactions = state.transactions;
            _chartController.forward(from: 0);
          }
          if (state is HistoryErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          final isLoading = state is HistoryLoadingState;
          final hasError = state is HistoryErrorState;
          final transactions = _cachedTransactions;

          final sumSection = TransactionsSumWidget(transactions: transactions);

          Widget chartSection;
          {
            final byCat = <String, double>{};
            for (final tx in transactions) {
              byCat[tx.category.name] =
                  (byCat[tx.category.name] ?? 0) + double.parse(tx.amount);
            }
            final names = byCat.keys.toList();
            final amounts = names.map((n) => byCat[n]!).toList();

            chartSection = SizedBox(
              height: 250,
              child: CategoryPieChart(
                animation: _chartController,
                oldData: ChartData(amounts: amounts, names: names),
                newData: ChartData(amounts: amounts, names: names),
              ),
            );
          }

          Widget listSection;
          if (isLoading) {
            listSection = const Center(child: CircularProgressIndicator());
          } else if (hasError) {
            listSection = Center(child: Text(state.errorMessage));
          } else {
            final grouping = <String, List<TransactionResponse>>{};
            for (final tx in transactions) {
              grouping.putIfAbsent(tx.category.name, () => []).add(tx);
            }
            final categoryNames = grouping.keys.toList();
            final totalSum = transactions.fold<int>(
              0,
              (prev, e) => prev + int.parse(e.amount),
            );

            listSection = Expanded(
              child: ListView.separated(
                itemCount: categoryNames.length,
                separatorBuilder: (_, _) =>
                    Divider(color: Theme.of(context).dividerColor, height: 1),
                itemBuilder: (context, index) {
                  final category = categoryNames[index];
                  final items = grouping[category]!
                    ..sort(
                      (a, b) => a.transactionDate.compareTo(b.transactionDate),
                    );
                  final categorySum = items.fold<int>(
                    0,
                    (prev, e) => prev + int.parse(e.amount),
                  );
                  final isExpanded = _expandedCategories.contains(category);

                  return Column(
                    children: [
                      TransactionListTile(
                        isIncomePage: widget.isIncomePage,
                        percentage: totalSum == 0
                            ? 0
                            : (categorySum / totalSum) * 100,
                        transaction: items.last,
                        iconButton: IconButton(
                          icon: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                          ),
                          onPressed: () => setState(() {
                            if (isExpanded) {
                              _expandedCategories.remove(category);
                            } else {
                              _expandedCategories.add(category);
                            }
                          }),
                        ),
                        isHeader: true,
                        sumByCategory: categorySum,
                      ),
                      if (isExpanded)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (_, _) =>
                              Divider(color: Theme.of(context).dividerColor),
                          itemBuilder: (context, index) => TransactionListTile(
                            isIncomePage: widget.isIncomePage,
                            transaction: items[index],
                            iconButton: IconButton(
                              icon: const Icon(Icons.navigate_next),
                              onPressed: () => showTransactionForm(
                                context: context,
                                transaction: items[index],
                                isIncomePage: widget.isIncomePage,
                                onReload: () =>
                                    context.read<HistoryCubit>().loadHistory(),
                              ),
                            ),
                            isHeader: false,
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TransactionDateChoiceWidget(
                title: 'Начало',
                initialDate: state is HistoryIdleState
                    ? state.startDate
                    : DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: state is HistoryIdleState
                    ? state.endDate
                    : DateTime.now(),
                isStartDate: true,
              ),
              TransactionDateChoiceWidget(
                title: 'Конец',
                initialDate: state is HistoryIdleState
                    ? state.endDate
                    : DateTime.now(),
                firstDate: state is HistoryIdleState
                    ? state.startDate
                    : DateTime(2000),
                lastDate: DateTime.now(),
                isStartDate: false,
              ),

              sumSection,

              chartSection,

              listSection,
            ],
          );
        },
      ),
    );
  }
}
