import 'package:flutter/widgets.dart';

class ChartPainterConstriant {
  const ChartPainterConstriant({
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0
  });

  final double left;
  final double right;
  final double top;
  final double bottom;
}

abstract class ChartPainter extends CustomPainter {
  var _constraint = ChartPainterConstriant();

  void constraint(ChartPainterConstriant given) {
    _constraint = ChartPainterConstriant(
      left: _constraint.left + given.left,
      right: _constraint.right + given.right,
      top: _constraint.top + given.top,
      bottom: _constraint.bottom + given.bottom
    );
  }

  /// Returns the absolute offset by a given normalized offset(0 ~ 1) and size.
  Offset absOffsetOf(Size size, Offset offset) {
    assert(offset.dx >= 0, "A given offset value must be between 0 and 1 or between.");
    assert(offset.dx <= 1, "A given offset value must be between 0 and 1 or between.");

    return Offset(
      _constraint.left + (size.width - _constraint.left - _constraint.right) * offset.dx,
      _constraint.top + (size.height - _constraint.top - _constraint.bottom) * offset.dy
    );
  }
}