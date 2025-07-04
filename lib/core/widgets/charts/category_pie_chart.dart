import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({
    required this.amountsByCategory,
    required this.categoryNames,
    this.maxTitles = 5,
    super.key,
  });

  final List<double> amountsByCategory;
  final List<String> categoryNames;
  final int maxTitles;

  @override
  Widget build(BuildContext context) {
    final totalAmount = amountsByCategory.fold<double>(
      0,
      (previousValue, element) => previousValue + element,
    );

    var titleCount = 0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    pieTouchData: PieTouchData(enabled: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 90,
                    sections: _buildSections(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: amountsByCategory.asMap().entries.map((entry) {
                    final index = entry.key;
                    final percentage = (entry.value / totalAmount) * 100;
                    final categoryName = categoryNames[index];
                    final color = _getCategoryColor(index);
                    if (titleCount > maxTitles) {
                      return const SizedBox.shrink();
                    }
                    if (titleCount == maxTitles) {
                      return Text(
                        '...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      );
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
            ),
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
          radius: 30,
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
