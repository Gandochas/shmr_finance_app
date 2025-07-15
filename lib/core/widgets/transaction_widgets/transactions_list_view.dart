import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/show_transaction_form.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transaction_list_tile.dart';
import 'package:shmr_finance_app/domain/bloc/expenses_incomes/expenses_incomes_cubit.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';

class TransactionsListView extends StatelessWidget {
  const TransactionsListView({
    required this.transactions,
    required this.isIncomePage,
    required this.theme,
    super.key,
  });

  final List<TransactionResponse> transactions;
  final bool isIncomePage;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionListTile(
          isIncomePage: isIncomePage,
          transaction: transaction,
          iconButton: IconButton(
            onPressed: () => showTransactionForm(
              context: context,
              transaction: transaction,
              isIncomePage: isIncomePage,
              onReload: () =>
                  context.read<ExpensesIncomesCubit>().loadTodayTransactions(),
            ),
            icon: const Icon(Icons.navigate_next),
          ),
          isHeader: false,
        );
      },
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: theme.dividerColor),

      itemCount: transactions.length,
    );
  }
}
