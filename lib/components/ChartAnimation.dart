import 'package:flutter/animation.dart';

class ChartAnimation {
  const ChartAnimation({
    this.fadeDuration,
    this.fadeCurve,
    this.transitionDuration,
    this.transitionCurve
  });

  final Duration? fadeDuration;
  final Curve? fadeCurve;
  final Duration? transitionDuration;
  final Curve? transitionCurve;

  ChartAnimation merge(ChartAnimation? animation) {
    if (animation == null) return this;

    return ChartAnimation(
      fadeDuration: animation.fadeDuration ?? fadeDuration,
      fadeCurve: animation.fadeCurve ?? fadeCurve,
      transitionDuration: animation.transitionDuration ?? transitionDuration,
      transitionCurve: animation.transitionCurve ?? transitionCurve,
    );
  }
}