import 'package:flutter/widgets.dart';
import 'package:flutter_chart/components/ChartData.dart';

class ChartGroup<T extends ChartData> {
  const ChartGroup({
    required this.label,
    required this.datas,
    this.color,
  });

  final String label;
  final Color? color;
  final List<ChartData> datas;
}