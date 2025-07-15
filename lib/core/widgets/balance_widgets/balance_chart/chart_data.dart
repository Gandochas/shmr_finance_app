import 'package:shmr_finance_app/core/widgets/balance_widgets/balance_chart/balance_bar_data.dart';
import 'package:shmr_finance_app/core/widgets/balance_widgets/balance_chart/balance_chart_config.dart';

class ChartData {
  ChartData(this.bars, this.config);
  final List<BalanceBarData> bars;
  final BalanceChartConfig config;
}
