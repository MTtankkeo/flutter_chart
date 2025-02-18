import 'package:flutter/material.dart';
import 'package:flutter_chartx/flutter_chart.dart';

class ChartDetector<T extends ChartState> extends StatefulWidget {
  const ChartDetector({
    super.key,
    required this.child,
    required this.controller,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onHoverStart,
    this.onHoverEnd
  });

  final Widget child;
  final ChartController controller;
  final ChartInteractionCallback<T>? onTap;
  final ChartInteractionCallback<T>? onDoubleTap;
  final ChartInteractionCallback<T>? onLongPress;
  final ChartInteractionCallback<T>? onHoverStart;
  final ChartInteractionCallback<T>? onHoverEnd;

  @override
  State<ChartDetector> createState() => _ChartDetectorState<T>();
}

class _ChartDetectorState<T extends ChartState> extends State<ChartDetector<T>> {
  T? hoverState;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (event) { hoverState = null; },
      onHover: (event) {
        final state = widget.controller.findStateByHitTest(event.localPosition) as T?;
        if (hoverState == null && state != null) {
          widget.onHoverStart?.call(state);
          hoverState = state;
        } else if (hoverState != null && state == null) {
          widget.onHoverEnd?.call(hoverState!);
          hoverState = null;
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: widget.onTap != null ? (details) {
          final target = widget.controller.findStateByHitTest(details.localPosition) as T?;
          if (target != null) {
            widget.onTap?.call(target);
          }
        } : null,
        onDoubleTapDown: widget.onDoubleTap != null ? (details) {
          final target = widget.controller.findStateByHitTest(details.localPosition) as T?;
          if (target != null) {
            widget.onDoubleTap?.call(target);
          }
        } : null,
        onLongPressStart: widget.onLongPress != null ? (details) {
          final target = widget.controller.findStateByHitTest(details.localPosition) as T?;
          if (target != null) {
            widget.onLongPress?.call(target);
          }
        } : null,
        child: widget.child,
      ),
    );
  }
}