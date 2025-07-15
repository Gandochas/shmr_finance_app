import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/animated_balance_widget.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/balance_chart/balance_bar_chart_widget.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/balance_chart/balance_bar_data.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/balance_chart/balance_chart_config.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/balance_chart/chart_data.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/balance_chart/chart_mode.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/currency_changer_widget.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/update_balance_name_widget.dart';
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
  ChartMode _mode = ChartMode.byDay;

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
    final cubit = context.read<BalanceCubit>();
    cubit.loadAll();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            title: Text('Мой счет', style: theme.appBarTheme.titleTextStyle),
            centerTitle: true,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
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
                  :final monthlyTransactionAmounts,
                ) =>
                  Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          border: Border(
                            bottom: BorderSide(color: theme.dividerColor),
                          ),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
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
                            child: Text(name, style: theme.textTheme.bodyLarge),
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
                          color: theme.colorScheme.secondary,
                        ),
                        child: ListTile(
                          title: Text(
                            'Валюта',
                            style: theme.textTheme.bodyLarge,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(currency, style: theme.textTheme.bodyLarge),
                              IconButton(
                                onPressed: _showCurrencyPicker,
                                icon: const Icon(Icons.navigate_next),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SegmentedButton<ChartMode>(
                          segments: [
                            ButtonSegment(
                              value: ChartMode.byDay,
                              label: Text(
                                'За месяц',
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                            ButtonSegment(
                              value: ChartMode.byMonth,
                              label: Text(
                                'За год',
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                          selected: {_mode},
                          onSelectionChanged: (modes) {
                            setState(() => _mode = modes.first);
                          },
                          showSelectedIcon: false,
                        ),
                      ),

                      Expanded(
                        child: SafeArea(
                          bottom: true,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 60),
                            child: Builder(
                              builder: (context) {
                                final chartTimeline = _mode == ChartMode.byDay
                                    ? _buildDayBars(dailyTransactionAmounts)
                                    : _buildMonthBars(
                                        monthlyTransactionAmounts,
                                      );

                                return BalanceBarChartWidget(
                                  bars: chartTimeline.bars,
                                  config: chartTimeline.config,
                                );
                              },
                            ),
                          ),
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

  ChartData _buildDayBars(Map<DateTime, double> daily) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 1, now.day);
    final end = DateTime(now.year, now.month, now.day);
    final total = end.difference(start).inDays + 1;

    final bars = <BalanceBarData>[];
    double prev = 0;
    for (var i = 0; i < total; i++) {
      final d = start.add(Duration(days: i));
      final sum = daily[d] ?? prev;
      bars.add(
        BalanceBarData(
          x: i + 1,
          value: sum,
          color: sum >= 0 ? Colors.green : Colors.red,
        ),
      );
      prev = sum;
    }

    final labelX = [1, (total / 2).ceil(), total];
    final maxY = bars.map((b) => b.value.abs()).fold<double>(0, max) * 1.2;
    final config = BalanceChartConfig(
      minY: 0,
      maxY: maxY,
      barsCount: total,
      labelX: labelX,
      xLabelFormatter: (x) {
        final d = start.add(Duration(days: x - 1));
        return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}';
      },
    );
    return ChartData(bars, config);
  }

  ChartData _buildMonthBars(Map<DateTime, double> monthly) {
    final now = DateTime.now();

    final start = DateTime(now.year - 1, now.month, 1);
    const count = 12;

    final bars = <BalanceBarData>[];
    double prev = 0;
    for (var i = 0; i < count; i++) {
      final d = DateTime(start.year, start.month + i, 1);
      final sum = monthly[d] ?? prev;
      bars.add(
        BalanceBarData(
          x: i + 1,
          value: sum,
          color: sum >= 0 ? Colors.green : Colors.red,
          label: '${d.month.toString().padLeft(2, '0')}.${d.year}',
        ),
      );
      prev = sum;
    }

    final labelX = [1, (count / 2).ceil(), count];
    final maxY = bars.map((b) => b.value.abs()).fold<double>(0, max) * 1.2;
    final config = BalanceChartConfig(
      minY: 0,
      maxY: maxY,
      barsCount: count,
      labelX: labelX,
      xLabelFormatter: (x) {
        final idx = x - 1;
        return (idx >= 0 && idx < bars.length) ? (bars[idx].label ?? '') : '';
      },
    );
    return ChartData(bars, config);
  }
}
