import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/widgets/format_date.dart';
import 'package:shmr_finance_app/domain/bloc/history/history_cubit.dart';

class TransactionDateChoiceWidget extends StatelessWidget {
  const TransactionDateChoiceWidget({
    required this.title,
    required this.isStartDate,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    super.key,
  });

  final String title;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool isStartDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: InkWell(
        onTap: () async {
          final historyCubit = context.read<HistoryCubit>();
          final pick = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
          );
          if (pick != null) {
            isStartDate
                ? historyCubit.updateStart(pick)
                : historyCubit.updateEnd(pick);
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
              Text(title, style: theme.textTheme.bodyLarge),
              Text(
                formatDate(date: initialDate),
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
