import 'package:category_chart/category_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/show_transaction_form.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transaction_date_choice_widget.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transaction_list_tile.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transactions_sum_widget.dart';
import 'package:shmr_finance_app/domain/bloc/history/history_cubit.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';

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
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.analysis,
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
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

          final transactionsSumSection = TransactionsSumWidget(
            transactions: transactions,
          );

          Widget chartSection;
          {
            final transactionsGroupsSumByCategoryName = <String, double>{};
            for (final transaction in transactions) {
              transactionsGroupsSumByCategoryName[transaction.category.name] =
                  (transactionsGroupsSumByCategoryName[transaction
                          .category
                          .name] ??
                      0) +
                  double.parse(transaction.amount);
            }
            final groupNames = transactionsGroupsSumByCategoryName.keys
                .toList();
            final amounts = groupNames
                .map((n) => transactionsGroupsSumByCategoryName[n]!)
                .toList();

            chartSection = SizedBox(
              height: 250,
              child: CategoryPieChart(
                animation: _chartController,
                oldData: ChartData(amounts: amounts, names: groupNames),
                newData: ChartData(amounts: amounts, names: groupNames),
              ),
            );
          }

          Widget transactionsListSection;
          if (isLoading) {
            transactionsListSection = const Center(
              child: CircularProgressIndicator(),
            );
          } else if (hasError) {
            transactionsListSection = Center(child: Text(state.errorMessage));
          } else {
            final transactionsGroupsByCategoryName =
                <String, List<TransactionResponse>>{};
            for (final transaction in transactions) {
              transactionsGroupsByCategoryName
                  .putIfAbsent(transaction.category.name, () => [])
                  .add(transaction);
            }
            final categoryNames = transactionsGroupsByCategoryName.keys
                .toList();
            final totalSum = transactions.fold<double>(
              0,
              (prev, e) => prev + double.parse(e.amount),
            );

            transactionsListSection = Expanded(
              child: ListView.separated(
                itemCount: categoryNames.length,
                separatorBuilder: (_, _) =>
                    Divider(color: theme.dividerColor, height: 1),
                itemBuilder: (context, index) {
                  final categoryName = categoryNames[index];
                  final items = transactionsGroupsByCategoryName[categoryName]!
                    ..sort(
                      (a, b) => a.transactionDate.compareTo(b.transactionDate),
                    );
                  final categorySum = items.fold<double>(
                    0,
                    (previous, element) =>
                        previous + double.parse(element.amount),
                  );
                  final isExpanded = _expandedCategories.contains(categoryName);

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
                              _expandedCategories.remove(categoryName);
                            } else {
                              _expandedCategories.add(categoryName);
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
                              Divider(color: theme.dividerColor, height: 1),

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
                title: localization.beginning,
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
                title: localization.end,
                initialDate: state is HistoryIdleState
                    ? state.endDate
                    : DateTime.now(),
                firstDate: state is HistoryIdleState
                    ? state.startDate
                    : DateTime(2000),
                lastDate: DateTime.now(),
                isStartDate: false,
              ),

              transactionsSumSection,

              chartSection,

              transactionsListSection,
            ],
          );
        },
      ),
    );
  }
}
