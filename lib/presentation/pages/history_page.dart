import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/widgets/svg_icon.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/history_transactions_list_view.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transaction_date_choice_widget.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transaction_sorting_widget.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transactions_sum_widget.dart';
import 'package:shmr_finance_app/domain/bloc/history/history_cubit.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';
import 'package:shmr_finance_app/presentation/pages/analysis_page.dart';

enum SortField { date, amount }

enum SortOrder { asc, desc }

class HistoryPage extends StatefulWidget {
  const HistoryPage({required this.isIncomePage, super.key});

  final bool isIncomePage;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  SortField _sortField = SortField.date;
  SortOrder _sortOrder = SortOrder.desc;

  void _navigateToAnalysisPage(BuildContext context) {
    final historyCubit = context.read<HistoryCubit>();
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => BlocProvider.value(
          value: historyCubit,
          child: AnalysisPage(isIncomePage: widget.isIncomePage),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              localization.my_history,
              style: theme.appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => _navigateToAnalysisPage(context),
                icon: const SvgIcon(
                  asset: 'assets/icons/history_analysis_icon.svg',
                ),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              return switch (state) {
                HistoryLoadingState() => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                HistoryErrorState() => Center(child: Text(state.errorMessage)),
                HistoryIdleState(
                  :final transactions,
                  :final startDate,
                  :final endDate,
                ) =>
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TransactionDateChoiceWidget(
                        title: localization.beginning,
                        initialDate: startDate,
                        firstDate: DateTime(2000),
                        lastDate: endDate,
                        isStartDate: true,
                      ),

                      TransactionDateChoiceWidget(
                        title: localization.end,
                        initialDate: endDate,
                        firstDate: startDate,
                        lastDate: DateTime.now(),
                        isStartDate: false,
                      ),

                      TransactionSortingWidget(
                        currentField: _sortField,
                        currentOrder: _sortOrder,
                        onFieldChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _sortField = value;
                            });
                          }
                        },
                        onOrderChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _sortOrder = value;
                            });
                          }
                        },
                      ),
                      TransactionsSumWidget(transactions: transactions),

                      Expanded(
                        child: HistoryTransactionsListView(
                          transactions: transactions,
                          sortField: _sortField,
                          sortOrder: _sortOrder,
                          widget: widget,
                        ),
                      ),
                    ],
                  ),
              };
            },
          ),
        );
      },
    );
  }
}
