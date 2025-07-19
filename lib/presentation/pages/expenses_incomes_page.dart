import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/show_transaction_form.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transactions_list_view.dart';
import 'package:shmr_finance_app/core/widgets/transaction_widgets/transactions_sum_widget.dart';
import 'package:shmr_finance_app/domain/bloc/expenses_incomes/expenses_incomes_cubit.dart';
import 'package:shmr_finance_app/domain/bloc/history/history_cubit.dart';
import 'package:shmr_finance_app/domain/controllers/haptic_touch/haptic_touch_controller.dart';
import 'package:shmr_finance_app/domain/repositories/transaction_repository.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';
import 'package:shmr_finance_app/presentation/pages/history_page.dart';

class ExpensesIncomesPage extends StatelessWidget {
  const ExpensesIncomesPage({required this.isIncomePage, super.key});

  final bool isIncomePage;

  void _navigateToHistoryPage(BuildContext context) {
    final transactionRepository = context.read<TransactionRepository>();
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => RepositoryProvider.value(
          value: transactionRepository,
          child: BlocProvider(
            create: (context) => HistoryCubit(
              transactionRepository: transactionRepository,
              isIncomePage: isIncomePage,
            )..loadHistory(),
            child: HistoryPage(isIncomePage: isIncomePage),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hapticTouchController = context.watch<HapticTouchController>();
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return BlocBuilder<ExpensesIncomesCubit, ExpensesIncomesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            title: Text(
              isIncomePage
                  ? localization.today_incomes
                  : localization.today_expenses,
              style: theme.appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => _navigateToHistoryPage(context),
                icon: const Icon(Icons.history),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: isIncomePage ? 'income_add_tag' : 'expense_add_tag',
            onPressed: () {
              if (hapticTouchController.isHapticFeedbackEnabled) {
                HapticFeedback.mediumImpact();
              }
              showTransactionForm(
                context: context,
                isIncomePage: isIncomePage,
                onReload: () => context
                    .read<ExpensesIncomesCubit>()
                    .loadTodayTransactions(),
              );
            },
            backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          ),
          body: Builder(
            builder: (context) {
              return switch (state) {
                ExpensesIncomesLoadingState() => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                ExpensesIncomesErrorState() => Center(
                  child: Text(state.errorMessage),
                ),
                ExpensesIncomesIdleState(:final transactions) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TransactionsSumWidget(transactions: transactions),

                    Expanded(
                      child: TransactionsListView(
                        transactions: transactions,
                        isIncomePage: isIncomePage,
                        theme: theme,
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
