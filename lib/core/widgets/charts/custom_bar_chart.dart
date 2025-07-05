import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shmr_finance_app/core/widgets/format_date.dart';

class CustomBarChart extends StatefulWidget {
  const CustomBarChart({required this.dailyTransactionAmounts, super.key});

  final Map<DateTime, double> dailyTransactionAmounts;

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

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: y.toDouble().abs(),
          color: y > 0 ? Colors.green : Colors.red,
          width: 6,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedDailyTransactionAmounts =
        widget.dailyTransactionAmounts.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));
    return Padding(
      padding: const EdgeInsets.all(28),
      child: AspectRatio(
        aspectRatio: 2,
        child: BarChart(
          BarChartData(
            barGroups: widget.dailyTransactionAmounts.entries.map((entry) {
              // final date = entry.key;
              final amount = entry.value;
              return BarChartGroupData(
                x: sortedDailyTransactionAmounts.indexOf(entry),
                barRods: [
                  BarChartRodData(
                    toY: amount.abs(),
                    color: amount > 0 ? Colors.green : Colors.red,
                    width: 6,
                  ),
                ],
              );
            }).toList(),
            // List.generate(dailyTransactionAmounts.length, (index) {
            //   return generateGroupData(index, dailyTransactionAmounts[index]);
            // }),
            barTouchData: const BarTouchData(enabled: true),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final totalColumns = sortedDailyTransactionAmounts.length;
                    if (value.toInt() == 0 ||
                        value.toInt() == (totalColumns / 2).floor() ||
                        value.toInt() == totalColumns - 1) {
                      final date = formatDate(
                        date: DateTime.now().subtract(
                          Duration(days: totalColumns - 1 - value.toInt()),
                        ),
                        // sortedDailyTransactionAmounts[value.toInt()].key,
                        withYear: false,
                      );
                      return Text(
                        date,
                        style: Theme.of(context).textTheme.bodyLarge,
                      );
                    }
                    // if (value == 0 ||
                    //     value == totalColumns - 1 ||
                    //     value == (totalColumns / 2).floor()) {
                    //   final date = formatDate(
                    //     date: DateTime.now().subtract(
                    //       Duration(days: totalColumns - 1 - value.toInt()),
                    //     ),
                    //     withYear: false,
                    //   );
                    //   return Text(date);
                    // }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: false),
          ),
        ),
      ),
    );
  }
}
