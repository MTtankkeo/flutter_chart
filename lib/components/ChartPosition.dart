import 'package:flutter/painting.dart';

class ChartPosition {
  const ChartPosition({
    required this.path
  });

  final Path path;

  bool hitTest(Offset point) {
    return path.contains(point);
  }
}