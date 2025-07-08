import 'package:flutter/material.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';

class TransactionsSumWidget extends StatelessWidget {
  const TransactionsSumWidget({required this.transactions, super.key});

  final List<TransactionResponse> transactions;

  @override
  Widget build(BuildContext context) {
    final transactionsSum = transactions.fold<double>(
      0,
      (previousValue, element) => previousValue + double.parse(element.amount),
    );
    return DecoratedBox(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Всего', style: Theme.of(context).textTheme.bodyLarge),
            Text(
              transactions.isNotEmpty
                  ? '$transactionsSum ${transactions.first.account.currency}'
                  : 'Сегодня транзакций не было',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
