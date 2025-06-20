import 'package:flutter/material.dart';
import 'package:shmr_finance_app/domain/bloc/expenses_incomes/expenses_incomes_cubit.dart';

class TransactionsSumWidget extends StatelessWidget {
  const TransactionsSumWidget({required this.transactions, super.key});

  final List<TransactionsOnScreen> transactions;

  @override
  Widget build(BuildContext context) {
    final transactionsSum = transactions.fold(
      0,
      (previousValue, element) => previousValue + int.parse(element.amount),
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
                  ? '$transactionsSum ${transactions.first.currency}'
                  : 'Сегодня транзакций не было',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
