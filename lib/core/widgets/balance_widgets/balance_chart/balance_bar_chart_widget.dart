import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/balance_chart/balance_bar_data.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/balance_chart/balance_chart_config.dart';

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
