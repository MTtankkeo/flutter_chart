import 'package:flutter/material.dart';
import 'package:flutter_chartx/components/types.dart';

class ChartStyle extends InheritedWidget {
  const ChartStyle({
    super.key, 
    required super.child,
    this.theme
  });

  final ChartTheme? theme;

  /// Returns the [ChartStyle] most closely associated with the given
  /// context, and returns null if there is no [ChartStyle] associated
  /// with the given context.
  static ChartStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChartStyle>();
  }

  @override
  bool updateShouldNotify(covariant ChartStyle oldWidget) {
    return theme != oldWidget.theme;
  }
}