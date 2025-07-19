import 'package:flutter/material.dart';
import 'package:shmr_finance_app/domain/models/transaction_response/transaction_response.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';

class TransactionsSumWidget extends StatelessWidget {
  const TransactionsSumWidget({required this.transactions, super.key});

  final List<TransactionResponse> transactions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    final transactionsSum = transactions.fold<double>(
      0,
      (previousValue, element) => previousValue + double.parse(element.amount),
    );

    return DecoratedBox(
      decoration: BoxDecoration(color: theme.colorScheme.secondary),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(localization.total, style: theme.textTheme.bodyLarge),
            Text(
              transactions.isNotEmpty
                  ? '$transactionsSum ${transactions.first.account.currency}'
                  : localization.no_transactions_today,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
