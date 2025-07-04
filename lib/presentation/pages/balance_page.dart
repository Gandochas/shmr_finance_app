import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/animated_balance_widget.dart';
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
                      CustomBarChart(),
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

class CustomBarChart extends StatefulWidget {
  const CustomBarChart({super.key});

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  late int showingTooltip;

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

  List<int> dailyTransactionAmounts = [
    200,
    -150,
    300,
    -50,
    0,
    120,
    -30,
    450,
    -100,
    80,
    -20,
    150,
    -60,
    180,
    50,
    100,
    -40,
    300,
    -250,
    500,
    -10,
    0,
    90,
    -200,
    40,
    120,
    -30,
    100,
    -80,
    250,
  ];

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: y.toDouble().abs(),
          color: y > 0 ? Colors.green : Colors.red,
          width: 8,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: AspectRatio(
        aspectRatio: 2,
        child: BarChart(
          BarChartData(
            barGroups: List.generate(dailyTransactionAmounts.length, (index) {
              return generateGroupData(index, dailyTransactionAmounts[index]);
            }),
            barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: false,

              touchCallback: (event, response) {
                if (response != null &&
                    response.spot != null &&
                    event is FlTapUpEvent) {
                  setState(() {
                    final x = response.spot!.touchedBarGroup.x;
                    final isShowing = showingTooltip == x;
                    if (isShowing) {
                      showingTooltip = -1;
                    } else {
                      showingTooltip = x;
                    }
                  });
                }
              },
              mouseCursorResolver: (event, response) {
                return response == null || response.spot == null
                    ? MouseCursor.defer
                    : SystemMouseCursors.click;
              },
            ),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  // getTitlesWidget: (value, meta) {
                  //   return value % 100 == 0 ? Text('$value') : const Text('');
                  // },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  getTitlesWidget: (value, meta) {
                    final date = DateTime.now().subtract(
                      Duration(
                        days:
                            dailyTransactionAmounts.length - 1 - value.toInt(),
                      ),
                    );
                    return Text('${date.day}.${date.month}');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: true),
          ),
        ),
      ),
    );
  }
}
