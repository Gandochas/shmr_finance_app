import 'package:flutter/material.dart';
import 'package:shmr_finance_app/core/widgets/format_date.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({
    required this.isIncomePage,
    required this.transaction,
    required this.iconButton,
    required this.isHeader,
    this.sumByCategory = 0,
    this.percentage = 0,
    super.key,
  });

  final bool isIncomePage;
  final TransactionResponse transaction;
  final IconButton iconButton;
  final bool isHeader;
  final double sumByCategory;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 72,
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
                transaction.category.emoji,
                style: const TextStyle(fontSize: 18),
              ),
            )
          : null,
      title: Text(
        transaction.category.name,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: transaction.comment != null
          ? Text(
              transaction.comment!,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isHeader
                ? '${percentage.toStringAsFixed(2)}%\n$sumByCategory ${transaction.account.currency}'
                : '${transaction.amount} ${transaction.account.currency}\n${formatDate(date: transaction.transactionDate)}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          iconButton,
        ],
      ),
    );
  }
}
