import 'package:flutter_chartx/components/ChartState.dart';
import 'package:flutter_chartx/components/ChartTooltip.dart';

class ChartBehavior<T extends ChartState> {
  const ChartBehavior({
    this.tooltip
  });

  final ChartTooltip<T>? tooltip;

  /// Returns a new chart behavior that is a combination of this behavior and the given [other] behavior.
  ChartBehavior merge(ChartBehavior? other) {
    if (other == null) return this;

    return ChartBehavior(
      tooltip: other.tooltip ?? tooltip,
    );
  }
}