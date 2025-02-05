import 'package:flutter/widgets.dart';
import 'package:flutter_chartx/components/ChartState.dart';

/// Signature for the callback function that is called when need tooltip widget in the chart.
typedef ChartTooltipBuilder<T extends ChartState> = Widget Function(BuildContext context, T state);

class ChartTooltip<T extends ChartState> {
  const ChartTooltip({
    required this.builder
  });

  final ChartTooltipBuilder<T> builder;
}