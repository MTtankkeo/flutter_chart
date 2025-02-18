import 'package:flutter/animation.dart';

class ChartAnimation {
  const ChartAnimation({
    this.fadeDuration,
    this.fadeCurve,
    this.transitionDuration,
    this.transitionCurve,
    this.hoverDuration,
    this.hoverCurve
  });

  final Duration? fadeDuration;
  final Curve? fadeCurve;
  final Duration? transitionDuration;
  final Curve? transitionCurve;
  final Duration? hoverDuration;
  final Curve? hoverCurve;

  /// Returns a new chart animation that is a combination of this animation and the given [other] animation.
  ChartAnimation merge(ChartAnimation? other) {
    if (other == null) return this;

    return ChartAnimation(
      fadeDuration: other.fadeDuration ?? fadeDuration,
      fadeCurve: other.fadeCurve ?? fadeCurve,
      transitionDuration: other.transitionDuration ?? transitionDuration,
      transitionCurve: other.transitionCurve ?? transitionCurve,
      hoverDuration: hoverDuration,
      hoverCurve: hoverCurve
    );
  }
}