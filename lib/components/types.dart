// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_chartx/components/ChartState.dart';

/// Signature for the callback function that is called when gesture actioned.
typedef ChartInteractionCallback<T extends ChartState> = void Function(T state);

/// Signature for the callback function that is called when need to
/// create the instance of [TextStyle] according to the state.
typedef ChartTextStyleBuilder<T extends ChartState> = TextStyle Function(T state);

/// Signature for the enumeration that defines alignment type about separated text.
enum ChartSeparatedTextAlignment {
  center,
  leading,
  trailing
}

/// Signature for the enumeration that defines alignment type about bar text.
enum ChartBarTextAlignment {
  center,
  inner_leading,
  inner_trailing,
  outer,
}

/// Signature for the enumeration that defines type of how to display values in a chart.
enum ChartMarkType {
  integer,
  percent
}

/// Signature for the enumeration that defines rounding modes for numerical values.
enum ChartRoundingModes {
  none,
  ceil,
  floor,
  round,
  cutoff
}

/// Signature for the enumeration that defines the chart theme type.
enum ChartTheme {
  light,
  dark
}