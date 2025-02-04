import 'package:flutter/material.dart';
import 'package:flutter_chartx/components/ChartLabeledData.dart';
import 'package:flutter_chartx/components/ChartPosition.dart';
import 'package:flutter_chartx/widgets/ChartContext.dart';

abstract class ChartState extends Listenable {
  /// Returns the key for comparing about the chart state.
  dynamic get key;

  /// Returns the value for about the chart data.
  double get value;

  /// Returns whether a given offset fits the chart position.
  bool hitTest(Offset point);
}

class ChartLabeledState extends ChartState {
  ChartLabeledState({ 
    required ChartContext context,
    required ChartLabeledData initialData
  }) : data = initialData {
    _controller = AnimationController(vsync: context.vsync, duration: context.animation.transitionDuration);
    _animation = CurvedAnimation(parent: _controller, curve: context.animation.transitionCurve!);
    _tween = Tween(begin: data.value, end: data.value);
  }

  late final AnimationController _controller;
  late final CurvedAnimation _animation;
  late final Tween<double> _tween;

  ChartLabeledData data;
  ChartPosition? position;

  @override
  void addListener(VoidCallback listener) {
    _animation.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _animation.removeListener(listener);
  }

  void updateTo(ChartLabeledData given) {
    final double oldValue = value;
    final double newValue = given.value;

    _tween.begin = oldValue;
    _tween.end = newValue;
    data = given;

    if (oldValue != newValue) {
      _controller.stop();
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  get key => data.label;

  @override
  double get value => _tween.transform(_animation.value);

  @override
  bool hitTest(Offset point) {
    return position?.hitTest(point) ?? false;
  }
}