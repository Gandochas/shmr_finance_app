import 'dart:math';

import 'package:category_chart/src/chart_config.dart';
import 'package:category_chart/src/chart_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({
    required this.oldData,
    required this.newData,
    required this.animation,
    this.config = const ChartConfig(),
    super.key,
  });
  final ChartData oldData;
  final ChartData newData;
  final ChartConfig config;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        final angle = 2 * pi * t;
        final useOld = t <= 0.5;
        final alpha = useOld ? (1 - t * 2) : ((t - 0.5) * 2);
        final data = useOld ? oldData : newData;

        return Opacity(
          opacity: alpha,
          child: Transform.rotate(
            angle: angle,
            child: _buildChart(data, config, context),
          ),
        );
      },
    );
  }

  Stack _buildChart(ChartData data, ChartConfig config, BuildContext context) {
    final totalAmount = data.amounts.fold<double>(
      0,
      (previousValue, element) => previousValue + element,
    );
    var titleCount = 0;

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            borderData: FlBorderData(show: false),
            pieTouchData: PieTouchData(enabled: true),
            sectionsSpace: 0,
            centerSpaceRadius: 90,
            sections: List.generate(data.amounts.length, (index) {
              return PieChartSectionData(
                value: data.amounts[index],
                color: _getCategoryColor(index),
                radius: 30,
                title: '',
              );
            }),
            // _buildSections(),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.amounts.asMap().entries.map((entry) {
            final index = entry.key;
            final percentage =
                totalAmount == 0 ? 0.0 : (entry.value / totalAmount) * 100;
            final categoryName = data.names[index];
            final color = _getCategoryColor(index);
            if (titleCount > config.maxTitles) {
              return const SizedBox.shrink();
            }
            if (titleCount == config.maxTitles) {
              return Text('...', style: Theme.of(context).textTheme.bodyLarge);
            }
            titleCount++;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${percentage.toStringAsFixed(2)}% $categoryName',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getCategoryColor(int index) {
    final colors = config.palette;
    return colors[index % colors.length];
  }
}
