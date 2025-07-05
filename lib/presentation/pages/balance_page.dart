import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/animated_balance_widget.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/currency_changer_widget.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/update_balance_name_widget.dart';
import 'package:shmr_finance_app/core/widgets/charts/custom_bar_chart.dart';
import 'package:shmr_finance_app/domain/bloc/balance/balance_cubit.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage>
    with SingleTickerProviderStateMixin {
  bool _hidden = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  static const double _flipThreshold = -7;

  Future<void> _showCurrencyPicker() async {
    final balanceCubit = context.read<BalanceCubit>();

    final selectedCurrency = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => const CurrencyChangerWidget(),
    );

    if (selectedCurrency != null) {
      await balanceCubit.updateAccountCurrency(selectedCurrency);
    }
  }

  void _handleAccelerometer(AccelerometerEvent event) {
    final z = event.z;

    if (z < _flipThreshold) {
      setState(() => _hidden = !_hidden);
    }
  }

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEventStream().listen(
      _handleAccelerometer,
    );
    context.read<BalanceCubit>().getTransactionsForLastMonth();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: const Text(
              'Мой счет',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
            ),
            centerTitle: true,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Theme.of(
              context,
            ).floatingActionButtonTheme.backgroundColor,
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          ),
          body: Builder(
            builder: (context) {
              return switch (state) {
                BalanceLoadingState() => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                BalanceErrorState() => Center(child: Text(state.errorMessage)),
                BalanceIdleState(
                  :final balance,
                  :final currency,
                  :final name,
                  :final dailyTransactionAmounts,
                ) =>
                  Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '💰',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          title: InkWell(
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                useRootNavigator: false,
                                builder: (context) => UpdateBalanceNameWidget(
                                  accountName: state.name,
                                ),
                              );
                            },
                            child: Text(
                              name,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBalanceWidget(
                                hidden: _hidden,
                                balance: balance,
                                currency: currency,
                              ),
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () =>
                                    setState(() => _hidden = !_hidden),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: ListTile(
                          title: Text(
                            'Валюта',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currency,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              IconButton(
                                onPressed: _showCurrencyPicker,
                                icon: const Icon(Icons.navigate_next),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (dailyTransactionAmounts.isNotEmpty)
                        CustomBarChart(
                          dailyTransactionAmounts: dailyTransactionAmounts,
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
