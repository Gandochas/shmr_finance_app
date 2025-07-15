import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/show_transaction_form.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transaction_list_tile.dart';
import 'package:shmr_finance_app/domain/bloc/history/history_cubit.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/presentation/pages/history_page.dart';

class HistoryTransactionsListView extends StatelessWidget {
  const HistoryTransactionsListView({
    required this.transactions,
    required SortField sortField,
    required SortOrder sortOrder,
    required this.widget,
    super.key,
  }) : _sortField = sortField,
       _sortOrder = sortOrder;

  final List<TransactionResponse> transactions;
  final SortField _sortField;
  final SortOrder _sortOrder;
  final HistoryPage widget;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final sortedTransactions = [...transactions]
          ..sort((a, b) {
            final compareBy = switch (_sortField) {
              SortField.date => a.transactionDate.compareTo(b.transactionDate),
              SortField.amount => double.parse(
                a.amount,
              ).compareTo(double.parse(b.amount)),
            };
            return _sortOrder == SortOrder.asc ? compareBy : -compareBy;
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
              onReload: () => context.read<HistoryCubit>().loadHistory(),
            ),
            icon: const Icon(Icons.navigate_next),
          ),
          isHeader: false,
        );
      },
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Theme.of(context).dividerColor),
    );
  }
}
