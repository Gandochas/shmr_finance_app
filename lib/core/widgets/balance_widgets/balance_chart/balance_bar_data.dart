import 'package:flutter/material.dart';

class BalanceBarData {
  BalanceBarData({
    required this.x,
    required this.value,
    required this.color,
    this.label,
  });
  final int x;
  final double value;
  final Color color;
  final String? label;
}
