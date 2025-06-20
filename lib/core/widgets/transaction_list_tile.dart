import 'package:flutter/material.dart';
import 'package:shmr_finance_app/core/widgets/format_date.dart';
import 'package:shmr_finance_app/domain/bloc/expenses_incomes/expenses_incomes_cubit.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({
    required this.isIncomePage,
    required this.transaction,
    super.key,
  });

  final bool isIncomePage;
  final TransactionsOnScreen transaction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: !isIncomePage
          ? Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
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
              style: Theme.of(context).textTheme.bodyMedium,
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${transaction.amount} ${transaction.currency}\n${formatDate(transaction.transactionDate)}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.navigate_next)),
        ],
      ),
    );
  }
}
