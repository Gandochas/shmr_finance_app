import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/animated_balance_widget.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/currency_changer_widget.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/update_balance_name_widget.dart';
import 'package:shmr_finance_app/domain/bloc/balance/balance_cubit.dart';

enum ChartMode { byDay, byMonth }

class _ChartData {
  _ChartData(this.bars, this.config);
  final List<BalanceBarData> bars;
  final BalanceChartConfig config;
}

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
                  :final monthlyTransactionAmounts,
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

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SegmentedButton<ChartMode>(
                          segments: const [
                            ButtonSegment(
                              value: ChartMode.byDay,
                              label: Text('За месяц'),
                            ),
                            ButtonSegment(
                              value: ChartMode.byMonth,
                              label: Text('За год'),
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
                            child: BalanceBarChartWidget(
                              bars:
                                  (_mode == ChartMode.byDay
                                          ? _buildDayBars(
                                              dailyTransactionAmounts,
                                            )
                                          : _buildMonthBars(
                                              monthlyTransactionAmounts,
                                            ))
                                      .bars,
                              config:
                                  (_mode == ChartMode.byDay
                                          ? _buildDayBars(
                                              dailyTransactionAmounts,
                                            )
                                          : _buildMonthBars(
                                              monthlyTransactionAmounts,
                                            ))
                                      .config,
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

  _ChartData _buildDayBars(Map<DateTime, double> daily) {
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
    final cfg = BalanceChartConfig(
      minY: 0,
      maxY: maxY,
      barsCount: total,
      labelX: labelX,
      xLabelFormatter: (x) {
        final d = start.add(Duration(days: x - 1));
        return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}';
      },
    );
    return _ChartData(bars, cfg);
  }

  _ChartData _buildMonthBars(Map<DateTime, double> monthly) {
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
    final cfg = BalanceChartConfig(
      minY: 0,
      maxY: maxY,
      barsCount: count,
      labelX: labelX,
      xLabelFormatter: (x) {
        final idx = x - 1;
        return (idx >= 0 && idx < bars.length) ? (bars[idx].label ?? '') : '';
      },
    );
    return _ChartData(bars, cfg);
  }
}

class BalanceBarData {
  BalanceBarData({
    required this.x,
    required this.value,
    required this.color,
    this.label,
  });
  final int x;
  final double value;
  final Color color;
  final String? label;
}

class BalanceChartConfig {
  BalanceChartConfig({
    required this.minY,
    required this.maxY,
    required this.barsCount,
    required this.labelX,
    this.xLabelFormatter,
  });
  final double minY;
  final double maxY;
  final int barsCount;
  final List<int> labelX;
  final String Function(int x)? xLabelFormatter;
}

class BalanceBarChartWidget extends StatelessWidget {
  const BalanceBarChartWidget({
    required this.bars,
    required this.config,
    super.key,
  });
  final List<BalanceBarData> bars;
  final BalanceChartConfig config;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            barGroups: bars
                .map(
                  (bar) => BarChartGroupData(
                    x: bar.x,
                    barRods: [
                      BarChartRodData(
                        toY: bar.value.abs(),
                        color: bar.color,
                        width: 6,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(92),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final x = value.toInt();
                    if (config.labelX.contains(x)) {
                      final label =
                          config.xLabelFormatter?.call(x) ?? x.toString();
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          label,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  reservedSize: 24,
                ),
              ),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barTouchData: const BarTouchData(enabled: true),
            maxY: config.maxY,
            minY: config.minY,
          ),
        ),
      ),
    );
  }
}
