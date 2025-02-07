import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_chartx/components/ChartState.dart';
import 'package:flutter_chartx/components/types.dart';

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

  double get width => left + right;
  double get height => top + bottom;
}

abstract class ChartPainter extends CustomPainter {
  /// This instance that defines the constraint about the chart layout.
  var constraint = ChartPainterConstriant();

  /// Sets the constraint about the current chart layout.
  void constraintBy(ChartPainterConstriant given) {
    constraint = ChartPainterConstriant(
      left: constraint.left + given.left,
      right: constraint.right + given.right,
      top: constraint.top + given.top,
      bottom: constraint.bottom + given.bottom
    );
  }

  /// Returns the absolute offset by a given normalized offset(0 ~ 1) and size.
  Offset absOffsetOf({
    required Size size,
    required Offset offset,
    Offset spacing = Offset.zero
  }) {
    assert(offset.dx >= 0, "A given offset value must be between 0 and 1 or between.");
    assert(offset.dx <= 1, "A given offset value must be between 0 and 1 or between.");

    return Offset(
      (constraint.left + (size.width - constraint.left - constraint.right) * offset.dx) + spacing.dx,
      (constraint.top + (size.height - constraint.top - constraint.bottom) * offset.dy) + spacing.dy
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    constraint = ChartPainterConstriant();
  }
}

abstract class DrivenChartPainter<T extends ChartState> extends ChartPainter {
  DrivenChartPainter({
    required this.defaultTextStyle,
    required this.states,
  });

  /// This instance defines the default text style of the chart.
  final TextStyle defaultTextStyle;

  /// This values defines is the current states of the chart.
  final List<T> states;
}

abstract class GridLabeledChartPainter extends DrivenChartPainter<ChartLabeledState> {
  GridLabeledChartPainter({
    required super.defaultTextStyle,
    required super.states,
    required this.maxValue,
    required this.markType,
    required this.backgroundColor,
    required this.separatedLineCount,
    required this.separatedLineColor,
    required this.separatedLineWidth,
    required this.separatedTextMargin,
    required this.separatedBorderColor,
    required this.separatedBorderWidth,
    required this.separatedLineCap,
    required this.separatedTextStyle,
    required this.separatedTextAlignment,
    required this.labelTextMargin,
    required this.labelTextStyle,
    required this.isVisibleSeparatedText,
    required this.isVisibleLabel,
  });

  final double maxValue;
  final ChartMarkType markType;
  final Color? backgroundColor;
  final int separatedLineCount;
  final Color separatedLineColor;
  final double separatedLineWidth;
  final double separatedTextMargin;
  final Color separatedBorderColor;
  final double separatedBorderWidth;
  final StrokeCap separatedLineCap;
  final TextStyle separatedTextStyle;
  final ChartSeparatedTextAlignment separatedTextAlignment;
  final double labelTextMargin;
  final TextStyle labelTextStyle;
  final bool isVisibleSeparatedText;
  final bool isVisibleLabel;

  /// Draws the background elements of the chart.
  void drawBackground(Canvas canvas, Size size) {
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
          text: TextSpan(text: text, style: defaultTextStyle.merge(separatedTextStyle)),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        separatedTextPainters.add(textPainter);
        separatedTextMaxWidth = max(separatedTextMaxWidth, textPainter.width);
      }
    }

    if (isVisibleLabel) {
      for (int i = 0; i < states.length; i++) {
        final textPainter = TextPainter(
          text: TextSpan(text: states[i].data.label, style: defaultTextStyle.merge(labelTextStyle)),
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
    final bodyHeight = size.height - bottomLabelAreaHeight;

    if (backgroundColor != null) {
      canvas.drawRect(Rect.fromLTRB(innerLeft, 0, size.width, bodyHeight), Paint()..color = backgroundColor!);
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
          case ChartSeparatedTextAlignment.center:
            textPainter.paint(canvas, Offset((separatedTextMaxWidth - textWidth) / 2, textHeight));
            break;

          case ChartSeparatedTextAlignment.leading:
            textPainter.paint(canvas, Offset(0, textHeight));
            break;

          case ChartSeparatedTextAlignment.trailing:
            textPainter.paint(canvas, Offset(separatedTextMaxWidth - textWidth, textHeight));
            break;
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
    for (int i = 0; i < states.length; i++) {
      final percent = i / (states.length);

      if (isVisibleLabel) {
        final textPainter = labelTextPainters[i];
        final areaLeft = bodyWidth * percent;
        final areaWidth = bodyWidth / states.length;
        final textWidth = textPainter.width;
        final textHeight = size.height - bottomLabelAreaHeight;

        textPainter.paint(canvas, Offset(((innerLeft + areaLeft) + areaWidth / 2) - textWidth / 2, textHeight + labelTextMargin));
      }
    }

    constraintBy(ChartPainterConstriant(left: innerLeft, bottom: bottomLabelAreaHeight));
  }

  /// Draws the foreground elements of the chart after background drawing.
  void drawForeground(Canvas canvas, Size size);

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    drawBackground(canvas, size);
    drawForeground(canvas, size);
  }
}