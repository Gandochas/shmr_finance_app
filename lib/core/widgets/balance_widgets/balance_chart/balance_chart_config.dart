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
