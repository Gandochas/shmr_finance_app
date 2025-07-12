import 'package:flutter/material.dart';

/// Нужные настройки: макс. кол-во титулов, палитра и т.д.
class ChartConfig {
  const ChartConfig({
    this.maxTitles = 3,
    this.palette = const <Color>[
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.yellow,
      Colors.brown,
      Colors.blueGrey,
    ],
  });

  final int maxTitles;
  final List<Color> palette;
}
