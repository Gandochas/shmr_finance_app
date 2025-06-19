import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/bloc/history/history_cubit.dart';

const _monthNames = [
  'Января',
  'Февраля',
  'Марта',
  'Апреля',
  'Мая',
  'Июня',
  'Июля',
  'Августа',
  'Сентября',
  'Октября',
  'Ноября',
  'Декабря',
];

String _formatDate(DateTime date) {
  final day = date.day;
  final month = _monthNames[date.month - 1];
  final year = date.year;
  return '$day $month $year';
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({required this.isIncomePage, super.key});

  final bool isIncomePage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Моя история'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.analytics_outlined),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              switch (state) {
                case HistoryLoadingState():
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                case HistoryErrorState():
                  return Center(child: Text(state.errorMessage));
                case HistoryIdleState():
                  final sum = state.transactions.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + int.parse(element.amount),
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: InkWell(
                          onTap: () async {
                            final historyCubit = context.read<HistoryCubit>();
                            final pick = await showDatePicker(
                              context: context,
                              initialDate: state.startDate,
                              firstDate: DateTime(1970),
                              lastDate: state.endDate,
                            );
                            if (pick != null) {
                              historyCubit.updateStart(pick);
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
                                Text(
                                  'Начало',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  _formatDate(state.startDate),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Divider(color: Theme.of(context).dividerColor),

                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: InkWell(
                          onTap: () async {
                            final historyCubit = context.read<HistoryCubit>();
                            final pick = await showDatePicker(
                              context: context,
                              initialDate: state.endDate,
                              firstDate: state.startDate,
                              lastDate: DateTime.now(),
                            );
                            if (pick != null) {
                              historyCubit.updateEnd(pick);
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
                                Text(
                                  'Конец',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  _formatDate(state.endDate),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Divider(color: Theme.of(context).dividerColor),

                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Padding(
                          padding: const EdgeInsetsGeometry.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Сумма',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              //! TODO: change currency logic
                              Text(
                                '$sum ${state.transactions.isNotEmpty ? state.transactions.first.currency : '₽'}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Expanded(
                        child: ListView.separated(
                          itemCount: state.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = state.transactions[index];
                            return ListTile(
                              leading: !isIncomePage
                                  ? CircleAvatar(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      child: Text(transaction.emoji),
                                    )
                                  : null,
                              title: Text(
                                transaction.categoryName,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              subtitle: transaction.comment.isNotEmpty
                                  ? Text(
                                      transaction.comment,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    )
                                  : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${transaction.amount} ${transaction.currency}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                  const Icon(Icons.navigate_next),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            // height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                    ],
                  );
              }
            },
          ),
        );
      },
    );
  }
}
