import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/components/ChartController.dart';
import 'package:flutter_chart/components/ChartGroup.dart';
import 'package:flutter_chart/types.dart';
import 'package:flutter_chart/widgets/DrivenChart.dart';

class ColumnChart extends DrivenChart<num> {
  const ColumnChart({
    super.key,
    super.width = 500,
    super.height = 300,
    required super.groups,
    this.backgroundColor,
    this.separatedLineCount = 5,
    this.separatedLineWidth = 1,
    this.separatedLineColor = const Color.fromRGBO(220, 220, 220, 1),
    this.separatedTextStyle = const TextStyle(fontSize: 14, color: Colors.black),
    this.separatedTextMargin = 15,
    this.separatedTextAlignment = ChartSeparatedTextAlignment.trailing,
    this.separatedLineCap = StrokeCap.square
  });

  final Color? backgroundColor;

  final int separatedLineCount;
  final Color separatedLineColor;
  final double separatedLineWidth;
  final TextStyle separatedTextStyle;
  final double separatedTextMargin;
  final ChartSeparatedTextAlignment separatedTextAlignment;
  final StrokeCap separatedLineCap;

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  final ChartController controller = ChartController();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ColumnChartPainter(
        spacing: 15,
        groups: widget.groups,
        backgroundColor: widget.backgroundColor,
        separatedLineCount: widget.separatedLineCount,
        separatedLineColor: widget.separatedLineColor,
        separatedLineWidth: widget.separatedLineWidth,
        separatedTextStyle: widget.separatedTextStyle,
        separatedTextMargin: widget.separatedTextMargin,
        separatedTextAlignment: widget.separatedTextAlignment,
        separatedLineCap: widget.separatedLineCap
      ),
      size: Size(widget.width, widget.height),
    );
  }
}

class ColumnChartPainter extends CustomPainter {
  const ColumnChartPainter({
    required this.backgroundColor,
    required this.separatedLineCount,
    required this.separatedLineWidth,
    required this.separatedLineColor,
    required this.separatedTextMargin,
    required this.separatedTextStyle,
    required this.separatedTextAlignment,
    required this.separatedLineCap,
    required this.spacing,
    required this.groups,
  });

  final Color? backgroundColor;
  final int separatedLineCount;
  final Color separatedLineColor;
  final double separatedLineWidth;
  final double separatedTextMargin;
  final TextStyle separatedTextStyle;
  final ChartSeparatedTextAlignment separatedTextAlignment;
  final StrokeCap separatedLineCap;
  final double spacing;

  final List<ChartGroup> groups;

  /// Gets whether the group is a single group.
  bool get isSingleData => groups.length == 1;

  double layoutGroupLabels() {
    return 0;
  }

  void drawBackground(Canvas canvas, Size size) {
    final separatedTextPainters = <TextPainter>[];
    final separatedLinePaint = Paint()
      ..strokeWidth = separatedLineWidth
      ..strokeCap = separatedLineCap
      ..color = separatedLineColor;

    double separatedTextMaxWidth = 0;

    for (int i = 0; i < separatedLineCount; i++) {
      final percent = i / (separatedLineCount - 1);

      // Draw about the text.
      final text = "${(100 - percent * 100).toInt()}";
      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: separatedTextStyle,
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      separatedTextPainters.add(textPainter);
      separatedTextMaxWidth = max(separatedTextMaxWidth, textPainter.width);
    }

    final innerLeft = separatedTextMaxWidth + separatedTextMargin;

    if (backgroundColor != null) {
      canvas.drawRect(Rect.fromLTRB(innerLeft, 0, size.width, size.height), Paint()..color = backgroundColor!);
    }

    // Darw about the separated text and line.
    for (int i = 0; i < separatedLineCount; i++) {
      final textPainter = separatedTextPainters[i];
      final percent = i / (separatedLineCount - 1);
      final height = size.height * percent;
      final textWidth = textPainter.width;
      final textHeight = height - textPainter.size.height / 2;

      // About text.
      switch (separatedTextAlignment) {
        case ChartSeparatedTextAlignment.center: textPainter.paint(canvas, Offset((separatedTextMaxWidth - textWidth) / 2, textHeight)); break;
        case ChartSeparatedTextAlignment.leading: textPainter.paint(canvas, Offset(0, textHeight)); break;
        case ChartSeparatedTextAlignment.trailing: textPainter.paint(canvas, Offset(separatedTextMaxWidth - textWidth, textHeight)); break;
      }

      // About line
      canvas.drawLine(Offset(innerLeft, height), Offset(size.width, height), separatedLinePaint);
    }
  }

  void drawForeground(Canvas canvas, Size size) {
    for (final group in groups) {
      for (final data in group.datas) {
        data.key;
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawBackground(canvas, size);
    drawForeground(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}