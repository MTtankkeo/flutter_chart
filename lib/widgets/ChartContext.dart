import 'package:flutter/material.dart';
import 'package:flutter_chartx/components/ChartAnimation.dart';

mixin ChartContext {
  TickerProvider get vsync;
  ChartAnimation get animation;
}