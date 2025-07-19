import 'package:flutter/material.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';
import 'package:shmr_finance_app/presentation/pages/history_page.dart';

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
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(localization.sorting, style: theme.textTheme.bodyLarge),
            DropdownButton<SortField>(
              value: currentField,
              items: [
                DropdownMenuItem(
                  value: SortField.date,
                  child: Text(
                    localization.by_date,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                DropdownMenuItem(
                  value: SortField.amount,
                  child: Text(
                    localization.by_amount,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
              onChanged: onFieldChanged,
            ),
            DropdownButton<SortOrder>(
              value: currentOrder,
              items: [
                DropdownMenuItem(
                  value: SortOrder.asc,
                  child: Text(
                    localization.ascending,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                DropdownMenuItem(
                  value: SortOrder.desc,
                  child: Text(
                    localization.descending,
                    style: theme.textTheme.bodyLarge,
                  ),
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
