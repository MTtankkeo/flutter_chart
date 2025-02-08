import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_chartx/components/ChartState.dart';
import 'package:flutter_chartx/components/types.dart';

class ChartPainterConstraint {
  const ChartPainterConstraint({
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
  var constraint = ChartPainterConstraint();

  /// Sets the constraint about the current chart layout.
  void constraintBy(ChartPainterConstraint given) {
    constraint = ChartPainterConstraint(
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
    constraint = ChartPainterConstraint();
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
    required this.separatedTextDirection,
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
  final ChartSeparatedTextDirection separatedTextDirection;
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

    final innerSide = separatedTextMaxWidth + separatedTextMargin;
    final bodyWidth = size.width - innerSide;
    final bodyHeight = size.height - bottomLabelAreaHeight;

    if (backgroundColor != null) {
      canvas.drawRect(
        separatedTextDirection == ChartSeparatedTextDirection.leading
          ? Rect.fromLTRB(innerSide, 0, size.width, bodyHeight)
          : Rect.fromLTRB(0, 0, size.width - innerSide, bodyHeight),
        Paint()..color = backgroundColor!
      );
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

        print(separatedTextAlignment);

        switch (separatedTextAlignment) {
          case ChartSeparatedTextAlignment.center:
            separatedTextDirection == ChartSeparatedTextDirection.leading
              ? textPainter.paint(canvas, Offset((separatedTextMaxWidth - textWidth) / 2, textHeight))
              : textPainter.paint(canvas, Offset(size.width - (separatedTextMaxWidth + textWidth) / 2, textHeight));
            break;

          case ChartSeparatedTextAlignment.leading:
            separatedTextDirection == ChartSeparatedTextDirection.leading
              ? textPainter.paint(canvas, Offset(0, textHeight))
              : textPainter.paint(canvas, Offset(size.width - textWidth, textHeight));
            break;

          case ChartSeparatedTextAlignment.trailing:
            separatedTextDirection == ChartSeparatedTextDirection.leading
              ? textPainter.paint(canvas, Offset(separatedTextMaxWidth - textWidth, textHeight))
              : textPainter.paint(canvas, Offset(size.width - separatedTextMaxWidth, textHeight));
            break;
        }
      }

      // About line.
      if (i == separatedLineCount - 1) {
        separatedLinePaint.color = separatedBorderColor;
        separatedLinePaint.strokeWidth = separatedBorderWidth;
      }

      if (separatedTextDirection == ChartSeparatedTextDirection.leading) {
        canvas.drawLine(Offset(innerSide, height), Offset(size.width, height), separatedLinePaint);
      } else {
        canvas.drawLine(Offset(0, height), Offset(size.width - innerSide, height), separatedLinePaint);
      }
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
        final textMargin = separatedTextDirection == ChartSeparatedTextDirection.leading ? innerSide : 0;

        textPainter.paint(
          canvas,
          Offset(((textMargin + areaLeft) + areaWidth / 2) - textWidth / 2, textHeight + labelTextMargin)
        );
      }
    }

    // Sets the bottom constraint to the label area height.
    constraintBy(ChartPainterConstraint(bottom: bottomLabelAreaHeight));

    // Sets the left or right constraint to the inner side width.
    if (separatedTextDirection == ChartSeparatedTextDirection.leading) {
      constraintBy(ChartPainterConstraint(left: innerSide));
    } else {
      constraintBy(ChartPainterConstraint(right: innerSide));
    }
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