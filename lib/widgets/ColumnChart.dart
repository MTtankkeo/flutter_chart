import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chart/components/ChartController.dart';
import 'package:flutter_chart/components/types.dart';
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
    this.markType = ChartMarkType.integer,
    this.separatedLineCount = 5,
    this.separatedLineWidth = 1,
    this.separatedLineColor = const Color.fromRGBO(230, 230, 230, 1),
    this.separatedTextStyle = const TextStyle(fontSize: 14, color: Colors.black),
    this.separatedTextMargin = 15,
    this.separatedTextAlignment = ChartSeparatedTextAlignment.trailing,
    this.separatedBorderColor = Colors.black,
    this.separatedBorderWidth,
    this.separatedLineCap = StrokeCap.square,
    this.labelTextMargin = 5,
    this.labelTextStyle = const TextStyle(fontSize: 14, color: Colors.black),
    this.barTextMargin = 10,
    this.barTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    this.barTextAlignment = ChartBarTextAlignment.leading,
    this.isVisibleSeparatedText = true,
    this.isVisibleBarText = false,
    this.isVisibleLabel = true,
  });

  final List<ColumnChartData> datas;

  final Color? backgroundColor;
  final double barRatio;
  final double? maxValue;
  final ChartMarkType markType;

  final int separatedLineCount;
  final Color separatedLineColor;
  final double separatedLineWidth;
  final TextStyle separatedTextStyle;
  final double separatedTextMargin;
  final ChartSeparatedTextAlignment separatedTextAlignment;
  final Color separatedBorderColor;
  final double? separatedBorderWidth;
  final StrokeCap separatedLineCap;
  final double labelTextMargin;
  final TextStyle labelTextStyle;
  final double barTextMargin;
  final TextStyle barTextStyle;
  final ChartBarTextAlignment barTextAlignment;

  final bool isVisibleSeparatedText;
  final bool isVisibleBarText;
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
        datas: widget.datas,
        backgroundColor: widget.backgroundColor,
        barRatio: widget.barRatio,
        maxValue: widget.maxValue ?? values.reduce((a, b) => max(a, b)),
        markType: widget.markType,
        separatedLineCount: widget.separatedLineCount,
        separatedLineColor: widget.separatedLineColor,
        separatedLineWidth: widget.separatedLineWidth,
        separatedTextStyle: widget.separatedTextStyle,
        separatedTextMargin: widget.separatedTextMargin,
        separatedTextAlignment: widget.separatedTextAlignment,
        separatedBorderColor: widget.separatedBorderColor,
        separatedBorderWidth: widget.separatedBorderWidth ?? widget.separatedLineWidth,
        separatedLineCap: widget.separatedLineCap,
        labelTextMargin: widget.labelTextMargin,
        labelTextStyle: widget.labelTextStyle,
        barTextMargin: widget.barTextMargin,
        barTextStyle: widget.barTextStyle,
        barTextAlignment: widget.barTextAlignment,
        isVisibleSeparatedText: widget.isVisibleSeparatedText,
        isVisibleBarText: widget.isVisibleBarText,
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
    required this.markType,
    required this.separatedLineCount,
    required this.separatedLineWidth,
    required this.separatedLineColor,
    required this.separatedTextMargin,
    required this.separatedTextStyle,
    required this.separatedTextAlignment,
    required this.separatedBorderColor,
    required this.separatedBorderWidth,
    required this.separatedLineCap,
    required this.labelTextMargin,
    required this.labelTextStyle,
    required this.barTextMargin,
    required this.barTextStyle,
    required this.barTextAlignment,
    required this.isVisibleSeparatedText,
    required this.isVisibleBarText,
    required this.isVisibleLabel,
    required this.datas,
  });

  final Color? backgroundColor;
  final double barRatio;
  final double maxValue;
  final ChartMarkType markType;
  final int separatedLineCount;
  final Color separatedLineColor;
  final double separatedLineWidth;
  final double separatedTextMargin;
  final TextStyle separatedTextStyle;
  final ChartSeparatedTextAlignment separatedTextAlignment;
  final Color separatedBorderColor;
  final double separatedBorderWidth;
  final StrokeCap separatedLineCap;
  final double labelTextMargin;
  final TextStyle labelTextStyle;
  final double barTextMargin;
  final TextStyle barTextStyle;
  final ChartBarTextAlignment barTextAlignment;

  final bool isVisibleSeparatedText;
  final bool isVisibleBarText;
  final bool isVisibleLabel;

  final List<ColumnChartData> datas;

  double layoutGroupLabels() {
    return 0;
  }

  Size drawBackground(Canvas canvas, Size size) {
    final separatedTextPainters = <TextPainter>[];
    final labelTextPainters = <TextPainter>[];
    final separatedLinePaint = Paint()
      ..strokeWidth = separatedLineWidth
      ..strokeCap = separatedLineCap
      ..color = separatedLineColor;

    double separatedTextMaxWidth = 0;
    double bottomLabelAreaHeight = 0;

    if (isVisibleSeparatedText) {
      for (int i = 0; i < separatedLineCount; i++) {
        final percent = i / (separatedLineCount - 1);

        // Draw about the text.
        final value = (maxValue - percent * maxValue).round();
        final text = markType == ChartMarkType.integer
          ? "$value"
          : "$value%";

        final textPainter = TextPainter(
          text: TextSpan(text: text, style: separatedTextStyle),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        separatedTextPainters.add(textPainter);
        separatedTextMaxWidth = max(separatedTextMaxWidth, textPainter.width);
      }
    }

    if (isVisibleLabel) {
      for (int i = 0; i < datas.length; i++) {
        final textPainter = TextPainter(
          text: TextSpan(text: datas[i].label, style: labelTextStyle),
          textDirection: TextDirection.ltr
        );

        textPainter.layout();

        labelTextPainters.add(textPainter);
        bottomLabelAreaHeight = max(bottomLabelAreaHeight, textPainter.height);
      }

      bottomLabelAreaHeight += labelTextMargin;
    }

    final innerLeft = separatedTextMaxWidth + separatedTextMargin;
    final bodyWidth = size.width - innerLeft;

    if (backgroundColor != null) {
      canvas.drawRect(Rect.fromLTRB(innerLeft, 0, size.width, size.height), Paint()..color = backgroundColor!);
    }

    // Darw about the separated text and label and line.
    for (int i = 0; i < separatedLineCount; i++) {
      final percent = i / (separatedLineCount - 1);
      final height = (size.height - bottomLabelAreaHeight) * percent;

      // About separated text.
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

    // Draw the label texts.
    for (int i = 0; i < datas.length; i++) {
      final percent = i / (datas.length);

      if (isVisibleLabel) {
        final textPainter = labelTextPainters[i];
        final areaLeft = bodyWidth * percent;
        final areaWidth = bodyWidth / datas.length;
        final textWidth = textPainter.width;
        final textHeight = size.height - bottomLabelAreaHeight;

        textPainter.paint(canvas, Offset(((innerLeft + areaLeft) + areaWidth / 2) - textWidth / 2, textHeight + labelTextMargin));
      }
    }

    return Size(innerLeft, bottomLabelAreaHeight);
  }

  void drawForeground(Canvas canvas, Size size, Size consumed) {
    if (datas.isEmpty) return;

    final maxWidth = size.width - consumed.width;
    final maxHeight = size.height - consumed.height - (separatedBorderWidth * barRatio);
    final areaWidth = maxWidth / datas.length;
    final barWidth = areaWidth * barRatio;

    for (int i = 0; i < datas.length; i++) {
      final target = datas[i];
      final height = (target.value / maxValue) * maxHeight;

      // About the position of a bar.
      final startX = consumed.width + (areaWidth * i) + (areaWidth - barWidth) / 2;
      final startY = maxHeight - height;
      final paint = Paint()..color = target.color;

      canvas.drawRect(Rect.fromLTRB(startX, startY, startX + barWidth, maxHeight), paint);

      if (isVisibleBarText) {
        final textPainter = TextPainter(
          text: TextSpan(text: "${target.value.round()}", style: barTextStyle),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(maxWidth: maxWidth);

        final textWidth = textPainter.width;
        final textHeight = textPainter.height;
        final textStartX = startX + (barWidth - textWidth) / 2;

        // Not drawing when overflow in layout calculation for the bar text.
        if (height < textHeight + barTextMargin * 2) {
          continue;
        }

        switch (barTextAlignment) {
          case ChartBarTextAlignment.center: textPainter.paint(canvas, Offset(textStartX, startY + height / 2)); break;
          case ChartBarTextAlignment.leading: textPainter.paint(canvas, Offset(textStartX, startY + barTextMargin)); break;
          case ChartBarTextAlignment.trailing: textPainter.paint(canvas, Offset(textStartX, (startY + height) - textHeight - barTextMargin)); break;
        }
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawForeground(canvas, size, drawBackground(canvas, size));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}