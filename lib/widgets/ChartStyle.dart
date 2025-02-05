import 'package:flutter/material.dart';
import 'package:flutter_chartx/components/ChartAnimation.dart';
import 'package:flutter_chartx/components/ChartBehavior.dart';
import 'package:flutter_chartx/components/types.dart';

class ChartStyle extends InheritedWidget {
  const ChartStyle({
    super.key, 
    required super.child,
    this.theme,
    this.behavior,
    this.animation,
  });

  final ChartTheme? theme;
  final ChartBehavior? behavior;
  final ChartAnimation? animation;

  /// Returns the [ChartStyle] most closely associated with the given
  /// context, and returns null if there is no [ChartStyle] associated
  /// with the given context.
  static ChartStyle? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChartStyle>();
  }

  @override
  bool updateShouldNotify(covariant ChartStyle oldWidget) {
    return theme != oldWidget.theme
        || behavior != oldWidget.behavior
        || animation != oldWidget.animation;
  }
}