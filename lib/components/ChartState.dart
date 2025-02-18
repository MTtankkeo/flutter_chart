import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chartx/components/ChartAnimation.dart';
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

abstract class AnimatedChartState extends ChartState {
  AnimatedChartState({
    required this.vsync,
  });

  final TickerProvider vsync;

  final animationMap = HashMap<String, ({
    AnimationController controller,
    Tween<double> tween,
    Curve curve,
  })>();
  
  final listeners = ObserverList<VoidCallback>();

  double? animationValueOf(String key) {
    final animation = animationMap[key];
    if (animation != null) {
      return animation.tween.transform(animation.curve.transform(animation.controller.value));
    }

    return null;
  }

  void animateTo(String key, double from, double to, Duration duration, Curve curve) {
    if (animationMap.containsKey(key)) {
      final animation = animationMap[key]!;
      animation.tween.begin = from;
      animation.tween.end = to;

      if (from != to) {
        animation.controller.stop();
        animation.controller.reset();
        animation.controller.forward();
      }

      return;
    }

    final controller = AnimationController(vsync: vsync, duration: duration)
      ..addListener(notifyListeners)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationMap.remove(key)?.controller.dispose();
        }
      })
      ..forward();

    animationMap[key] = (
      controller: controller,
      curve: curve,
      tween: Tween(begin: from, end: to)
    );
  }

  @override
  void addListener(VoidCallback listener) {
    assert(!listeners.contains(listener), "Already exists a given listener.");
    listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    assert(listeners.contains(listener), "Already not exists a given listener.");
    listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in listeners) {
      listener.call();
    }
  }
}

class ChartLabeledState extends AnimatedChartState {
  ChartLabeledState({ 
    required this.context,
    required ChartLabeledData initialData
  }) : data = initialData, super(vsync: context.vsync);

  final ChartContext context;

  ChartAnimation get animation => context.animation;

  ChartLabeledData data;
  ChartPosition? position;

  double hoverAnimTarget = 0;

  void updateTo(ChartLabeledData given) {
    final double oldValue = value;
    final double newValue = given.value;
    data = given;

    assert(animation.transitionDuration != null);
    assert(animation.transitionCurve != null);
    animateTo("transition", oldValue, newValue, animation.transitionDuration!, animation.transitionCurve!);
  }

  void hoverStart() {
    animateTo("hover", hover, 1, animation.hoverDuration!, animation.hoverCurve!);
    hoverAnimTarget = 1;
  }

  void hoverEnd() {
    animateTo("hover", hover, 0, animation.hoverDuration!, animation.hoverCurve!);
    hoverAnimTarget = 0;
  }

  @override
  get key => data.label;

  @override
  double get value => animationValueOf("transition") ?? data.value;
  double get hover => animationValueOf("hover") ?? hoverAnimTarget;

  @override
  bool hitTest(Offset point) {
    return position?.hitTest(point) ?? false;
  }
}