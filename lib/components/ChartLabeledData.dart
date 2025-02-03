import 'package:flutter/widgets.dart';

class ChartLabeledData {
  const ChartLabeledData({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;
}