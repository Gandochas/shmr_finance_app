import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/widgets/format_date.dart';
import 'package:shmr_finance_app/core/widgets/svg_icon.dart';
import 'package:shmr_finance_app/core/widgets/transaction_list_tile.dart';
import 'package:shmr_finance_app/core/widgets/transactions_sum_widget.dart';
import 'package:shmr_finance_app/domain/bloc/history/history_cubit.dart';

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
                onPressed: () {},
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
                HistoryIdleState() => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: InkWell(
                        onTap: () async {
                          final historyCubit = context.read<HistoryCubit>();
                          final pick = await showDatePicker(
                            context: context,
                            initialDate: state.startDate,
                            firstDate: DateTime(1970),
                            lastDate: state.endDate,
                          );
                          if (pick != null) {
                            historyCubit.updateStart(pick);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsetsGeometry.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Начало',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                formatDate(state.startDate),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        border: BoxBorder.symmetric(
                          horizontal: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final historyCubit = context.read<HistoryCubit>();
                          final pick = await showDatePicker(
                            context: context,
                            initialDate: state.endDate,
                            firstDate: state.startDate,
                            lastDate: DateTime.now(),
                          );
                          if (pick != null) {
                            historyCubit.updateEnd(pick);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsetsGeometry.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Конец',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                formatDate(state.endDate),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
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
                    TransactionsSumWidget(transactions: state.transactions),

                    Expanded(
                      child: ListView.separated(
                        itemCount: state.transactions.length,
                        itemBuilder: (context, index) {
                          final sortedTransactions = [...state.transactions]
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

class TransactionSortingWidget extends StatelessWidget {
  const TransactionSortingWidget({
    required this.currentField,
    required this.currentOrder,
    required this.onFieldChanged,
    required this.onOrderChanged,
    super.key,
  });

  final SortField currentField;
  final SortOrder currentOrder;
  final ValueChanged<SortField?> onFieldChanged;
  final ValueChanged<SortOrder?> onOrderChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Сортировка', style: Theme.of(context).textTheme.bodyLarge),
            DropdownButton<SortField>(
              value: currentField,
              items: const [
                DropdownMenuItem(value: SortField.date, child: Text('По дате')),
                DropdownMenuItem(
                  value: SortField.amount,
                  child: Text('По сумме'),
                ),
              ],
              onChanged: onFieldChanged,
            ),
            DropdownButton<SortOrder>(
              value: currentOrder,
              items: const [
                DropdownMenuItem(
                  value: SortOrder.asc,
                  child: Text('По возрастанию'),
                ),
                DropdownMenuItem(
                  value: SortOrder.desc,
                  child: Text('По убыванию'),
                ),
              ],
              onChanged: onOrderChanged,
            ),
          ],
        ),
      ),
    );
  }
}
