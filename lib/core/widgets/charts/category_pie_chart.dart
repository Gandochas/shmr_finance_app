import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({
    required this.amountsByCategory,
    required this.categoryNames,
    super.key,
  });

  final List<double> amountsByCategory;
  final List<String> categoryNames;

  @override
  Widget build(BuildContext context) {
    final totalAmount = amountsByCategory.fold<double>(
      0,
      (previousValue, element) => previousValue + element,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(show: false),
                pieTouchData: PieTouchData(enabled: false),
                sectionsSpace: 0,
                centerSpaceRadius: 60,
                sections: _buildSections(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 6,
            children: amountsByCategory.asMap().entries.map((entry) {
              final index = entry.key;
              final percentage = (entry.value / totalAmount) * 100;
              final categoryName = categoryNames[index];
              final color = _getCategoryColor(index);
              return Row(
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
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    final sections = <PieChartSectionData>[];
    for (var i = 0; i < amountsByCategory.length; i++) {
      sections.add(
        PieChartSectionData(
          value: amountsByCategory[i],
          title: '',
          color: _getCategoryColor(i),
          radius: 40,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    return sections;
  }

  Color _getCategoryColor(int index) {
    final colors = <Color>[
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.yellow,
      Colors.brown,
      Colors.blueGrey,
    ];
    return colors[index % colors.length];
  }
}
