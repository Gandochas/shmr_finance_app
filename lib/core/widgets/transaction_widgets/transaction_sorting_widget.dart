import 'package:flutter/material.dart';
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
