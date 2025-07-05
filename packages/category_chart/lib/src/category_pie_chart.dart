import 'dart:math';

import 'package:category_chart/src/chart_config.dart';
import 'package:category_chart/src/chart_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatefulWidget {
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
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        final t = widget.animation.value;
        final angle = 2 * pi * t;
        final useOld = t <= 0.5;
        final alpha = useOld ? (1 - t * 2) : ((t - 0.5) * 2);
        final data = useOld ? widget.oldData : widget.newData;

        return Opacity(
          opacity: alpha,
          child: Transform.rotate(
            angle: angle,
            child: _buildChart(data, widget.config, context),
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
            pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: (event, response) {
                  if (event is FlTapUpEvent &&
                      response != null &&
                      response.touchedSection != null) {
                    setState(() {
                      touchedIndex =
                          response.touchedSection?.touchedSectionIndex;
                    });
                  } else if (event is FlLongPressEnd ||
                      event is FlPanEndEvent) {
                    setState(() {
                      touchedIndex = null;
                    });
                  }
                }),
            sectionsSpace: 0,
            centerSpaceRadius: 90,
            sections: List.generate(data.amounts.length, (index) {
              final value = data.amounts[index];
              final color = _getCategoryColor(index);
              final isTouched = index == touchedIndex;
              final badge = isTouched
                  ? _Badge(
                      label:
                          '${data.names[index]}:\n${value.toStringAsFixed(2)} (${totalAmount == 0 ? 0.0 : (value / totalAmount * 100).toStringAsFixed(2)}%)',
                      color: color,
                    )
                  : null;
              return PieChartSectionData(
                  value: value,
                  color: color,
                  radius: isTouched ? 40 : 30,
                  title: '',
                  badgeWidget: badge,
                  badgePositionPercentageOffset: 1.2);
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
    final colors = widget.config.palette;
    return colors[index % colors.length];
  }
}

/// Простой виджет для отображения popup-метки
class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black87,
            ),
      ),
    );
  }
}
