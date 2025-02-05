import 'package:flutter/material.dart';

class ChartOverlay extends StatefulWidget {
  const ChartOverlay({
    super.key,
    required this.overlay,
    required this.child,
  });

  final Widget overlay;
  final Widget child;

  @override
  State<ChartOverlay> createState() => _ChartOverlayState();
}

class _ChartOverlayState extends State<ChartOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 0,
          left: 0,
          child: RepaintBoundary(
            child: widget.overlay,
          ),
        )
      ],
    );
  }
}