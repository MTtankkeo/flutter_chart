import 'package:flutter/material.dart';
import 'package:flutter_chartx/flutter_chart.dart';

class ChartDetector extends StatelessWidget {
  const ChartDetector({
    super.key,
    required this.child,
    required this.controller,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress
  });

  final Widget child;
  final ChartController controller;
  final ChartInteractionCallback? onTap;
  final ChartInteractionCallback? onDoubleTap;
  final ChartInteractionCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: onTap != null ? (details) {
        final target = controller.findStateByHitTest(details.localPosition);
        if (target != null) {
          onTap?.call(target);
        }
      } : null,
      onDoubleTapDown: onDoubleTap != null ? (details) {
        final target = controller.findStateByHitTest(details.localPosition);
        if (target != null) {
          onDoubleTap?.call(target);
        }
      } : null,
      onLongPressStart: onLongPress != null ? (details) {
        final target = controller.findStateByHitTest(details.localPosition);
        if (target != null) {
          onLongPress?.call(target);
        }
      } : null,
      child: child,
    );
  }
}