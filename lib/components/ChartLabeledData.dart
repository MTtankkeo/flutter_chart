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

  // equality comparison for ChartLabeledData
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChartLabeledData &&
        other.label == label &&
        other.value == value &&
        other.color == color;
  }

  @override
  int get hashCode => label.hashCode ^ value.hashCode ^ color.hashCode;

  static Map<String, List<ChartLabeledData>> comparedOf(List<ChartLabeledData> oldList, List<ChartLabeledData> newList) {
    final oldMap = {for (var item in oldList) item.label: item};
    final newMap = {for (var item in newList) item.label: item};

    final removed = oldMap.keys.where((label) => !newMap.containsKey(label)).map((label) => oldMap[label]!).toList();
    final created = newMap.keys.where((label) => !oldMap.containsKey(label)).map((label) => newMap[label]!).toList();
    final changed = newMap.keys
      .where((label) => oldMap.containsKey(label) && !((oldMap[label]!) == (newMap[label]!)))
      .map((label) => newMap[label]!)
      .toList();

    return {"removed": removed, "created": created, "changed": changed};
  }
}