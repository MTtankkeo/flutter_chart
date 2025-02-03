import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chart/components/ChartController.dart';
import 'package:flutter_chart/types.dart';
import 'package:flutter_chart/widgets/DrivenChart.dart';

class ColumnChartData {
  const ColumnChartData({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;
}

class ColumnChart extends DrivenChart<num> {
  const ColumnChart({
    super.key,
    super.width = 500,
    super.height = 300,
    required this.datas,
    this.backgroundColor,
    this.barRatio = 0.5,
    this.maxValue,
    this.separatedLineCount = 5,
    this.separatedLineWidth = 1,
    this.separatedLineColor = const Color.fromRGBO(230, 230, 230, 1),
    this.separatedTextStyle = const TextStyle(fontSize: 14, color: Colors.black),
    this.separatedTextMargin = 15,
    this.separatedTextAlignment = ChartSeparatedTextAlignment.trailing,
    this.separatedBorderColor = Colors.black,
    this.separatedBorderWidth,
    this.separatedLineCap = StrokeCap.square,
    this.isVisibleSeparatedText = true,
    this.isVisibleLabel = true,
  });

  final List<ColumnChartData> datas;

  final Color? backgroundColor;
  final double barRatio;
  final double? maxValue;

  final int separatedLineCount;
  final Color separatedLineColor;
  final double separatedLineWidth;
  final TextStyle separatedTextStyle;
  final double separatedTextMargin;
  final ChartSeparatedTextAlignment separatedTextAlignment;
  final Color separatedBorderColor;
  final double? separatedBorderWidth;
  final StrokeCap separatedLineCap;

  final bool isVisibleSeparatedText; 
  final bool isVisibleLabel;

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  final ChartController controller = ChartController();

  /// Returns a list that defines values from the given data list.
  List<double> get values => widget.datas.map((data) => data.value).toList();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ColumnChartPainter(
        spacing: 15,
        datas: widget.datas,
        backgroundColor: widget.backgroundColor,
        barRatio: widget.barRatio,
        maxValue: widget.maxValue ?? values.reduce((a, b) => max(a, b)),
        separatedLineCount: widget.separatedLineCount,
        separatedLineColor: widget.separatedLineColor,
        separatedLineWidth: widget.separatedLineWidth,
        separatedTextStyle: widget.separatedTextStyle,
        separatedTextMargin: widget.separatedTextMargin,
        separatedTextAlignment: widget.separatedTextAlignment,
        separatedBorderColor: widget.separatedBorderColor,
        separatedBorderWidth: widget.separatedBorderWidth ?? widget.separatedLineWidth,
        separatedLineCap: widget.separatedLineCap,
        isVisibleSeparatedText: widget.isVisibleSeparatedText,
        isVisibleLabel: widget.isVisibleLabel
      ),
      size: Size(widget.width, widget.height),
    );
  }
}

class ColumnChartPainter extends CustomPainter {
  const ColumnChartPainter({
    required this.backgroundColor,
    required this.barRatio,
    required this.maxValue,
    required this.separatedLineCount,
    required this.separatedLineWidth,
    required this.separatedLineColor,
    required this.separatedTextMargin,
    required this.separatedTextStyle,
    required this.separatedTextAlignment,
    required this.separatedBorderColor,
    required this.separatedBorderWidth,
    required this.separatedLineCap,
    required this.spacing,
    required this.isVisibleSeparatedText,
    required this.isVisibleLabel,
    required this.datas,
  });

  final Color? backgroundColor;
  final double barRatio;
  final double maxValue;
  final int separatedLineCount;
  final Color separatedLineColor;
  final double separatedLineWidth;
  final double separatedTextMargin;
  final TextStyle separatedTextStyle;
  final ChartSeparatedTextAlignment separatedTextAlignment;
  final Color separatedBorderColor;
  final double separatedBorderWidth;
  final StrokeCap separatedLineCap;
  final double spacing;
  final bool isVisibleSeparatedText;
  final bool isVisibleLabel;

  final List<ColumnChartData> datas;

  double layoutGroupLabels() {
    return 0;
  }

  Size drawBackground(Canvas canvas, Size size) {
    final separatedTextPainters = <TextPainter>[];
    final separatedLinePaint = Paint()
      ..strokeWidth = separatedLineWidth
      ..strokeCap = separatedLineCap
      ..color = separatedLineColor;

    double separatedTextMaxWidth = 0;

    if (isVisibleSeparatedText) {
      for (int i = 0; i < separatedLineCount; i++) {
        final percent = i / (separatedLineCount - 1);

        // Draw about the text.
        final text = "${(maxValue - percent * maxValue).round()}";
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
    }

    final innerLeft = separatedTextMaxWidth + separatedTextMargin;

    if (backgroundColor != null) {
      canvas.drawRect(Rect.fromLTRB(innerLeft, 0, size.width, size.height), Paint()..color = backgroundColor!);
    }

    // Darw about the separated text and line.
    for (int i = 0; i < separatedLineCount; i++) {
      final percent = i / (separatedLineCount - 1);
      final height = size.height * percent;

      // About text.
      if (isVisibleSeparatedText) {
        final textPainter = separatedTextPainters[i];
        final textWidth = textPainter.width;
        final textHeight = height - textPainter.size.height / 2;

        switch (separatedTextAlignment) {
          case ChartSeparatedTextAlignment.center: textPainter.paint(canvas, Offset((separatedTextMaxWidth - textWidth) / 2, textHeight)); break;
          case ChartSeparatedTextAlignment.leading: textPainter.paint(canvas, Offset(0, textHeight)); break;
          case ChartSeparatedTextAlignment.trailing: textPainter.paint(canvas, Offset(separatedTextMaxWidth - textWidth, textHeight)); break;
        }
      }

      // About line.
      if (i == separatedLineCount - 1) {
        separatedLinePaint.color = separatedBorderColor;
        separatedLinePaint.strokeWidth = separatedBorderWidth;
      }

      canvas.drawLine(Offset(innerLeft, height), Offset(size.width, height), separatedLinePaint);
    }

    return Size(innerLeft, 0);
  }

  void drawForeground(Canvas canvas, Size size, Size consumed) {
    if (datas.isEmpty) return;

    final maxWidth = size.width - consumed.width;
    final maxHeight = size.height - consumed.height - (separatedBorderWidth / 2);
    final areaWidth = maxWidth / datas.length;
    final barWidth = areaWidth / 2;

    for (int i = 0; i < datas.length; i++) {
      final current = datas[i];
      final height = (current.value / maxValue) * maxHeight;

      // About the position of a bar.
      final startX = consumed.width + (areaWidth * i) + (areaWidth - barWidth) / 2;
      final startY = maxHeight - height;
      final paint = Paint()..color = current.color;

      canvas.drawRect(
        Rect.fromLTRB(startX, startY, startX + barWidth, maxHeight),
        paint,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawForeground(canvas, size, drawBackground(canvas, size));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}