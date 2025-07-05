import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/widgets/show_transaction_form.dart';
import 'package:shmr_finance_app/core/widgets/svg_icon.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transaction_date_choice_widget.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transaction_list_tile.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transaction_sorting_widget.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transactions_sum_widget.dart';
import 'package:shmr_finance_app/domain/bloc/history/history_cubit.dart';
import 'package:shmr_finance_app/presentation/pages/analysis_page.dart';

enum SortField { date, amount }

enum SortOrder { asc, desc }

class HistoryPage extends StatefulWidget {
  const HistoryPage({required this.isIncomePage, super.key});

  final bool isIncomePage;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  SortField _sortField = SortField.date;
  SortOrder _sortOrder = SortOrder.desc;

  void _navigateToAnalysisPage(BuildContext context) {
    final historyCubit = context.read<HistoryCubit>();
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => BlocProvider.value(
          value: historyCubit,
          child: AnalysisPage(isIncomePage: widget.isIncomePage),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Моя история'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => _navigateToAnalysisPage(context),
                icon: const SvgIcon(
                  asset: 'assets/icons/history_analysis_icon.svg',
                ),
              ),
            ],
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
                  Column(
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

                      TransactionSortingWidget(
                        currentField: _sortField,
                        currentOrder: _sortOrder,
                        onFieldChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _sortField = value;
                            });
                          }
                        },
                        onOrderChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _sortOrder = value;
                            });
                          }
                        },
                      ),
                      TransactionsSumWidget(transactions: transactions),

                      Expanded(
                        child: ListView.separated(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final sortedTransactions = [...transactions]
                              ..sort((a, b) {
                                final compareBy = switch (_sortField) {
                                  SortField.date => a.transactionDate.compareTo(
                                    b.transactionDate,
                                  ),
                                  SortField.amount => int.parse(
                                    a.amount,
                                  ).compareTo(int.parse(b.amount)),
                                };
                                return _sortOrder == SortOrder.asc
                                    ? compareBy
                                    : -compareBy;
                              });
                            final transaction = sortedTransactions[index];
                            return TransactionListTile(
                              isIncomePage: widget.isIncomePage,
                              transaction: transaction,
                              iconButton: IconButton(
                                onPressed: () => showTransactionForm(
                                  context: context,
                                  transaction: transaction,
                                  isIncomePage: widget.isIncomePage,
                                  onReload: () => context
                                      .read<HistoryCubit>()
                                      .loadHistory(),
                                ),
                                icon: const Icon(Icons.navigate_next),
                              ),
                              isHeader: false,
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
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
