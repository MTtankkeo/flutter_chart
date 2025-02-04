import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chartx/components/ChartAnimation.dart';
import 'package:flutter_chartx/components/ChartController.dart';
import 'package:flutter_chartx/components/ChartLabeledData.dart';
import 'package:flutter_chartx/components/ChartState.dart';
import 'package:flutter_chartx/components/types.dart';
import 'package:flutter_chartx/widgets/ChartContext.dart';
import 'package:flutter_chartx/widgets/ChartStyle.dart';
import 'package:flutter_chartx/widgets/DrivenChart.dart';

/// ## Introduction
/// A column chart is a method of displaying data with categories
/// represented by a rectangle—sometimes called vertical bar charts.
/// They allow easy comparisons among a number of items and trends analysis.
/// 
/// ## Preview
/// ![preview](https://github.com/user-attachments/assets/a81e24cc-ec07-472f-a284-54f41ee21236)
class ColumnChart extends DrivenChart {
  const ColumnChart({
    super.key,
    super.width = 500,
    super.height = 300,
    required this.datas,
    this.controller,
    this.animation,
    this.backgroundColor,
    this.barRatio = 0.5,
    this.maxValue,
    this.markType = ChartMarkType.integer,
    this.theme,
    this.separatedLineCount = 5,
    this.separatedLineWidth = 2,
    this.separatedLineColor,
    this.separatedTextStyle,
    this.separatedTextMargin = 15,
    this.separatedTextAlignment = ChartSeparatedTextAlignment.trailing,
    this.separatedBorderColor,
    this.separatedBorderWidth,
    this.separatedLineCap = StrokeCap.square,
    this.labelTextMargin = 5,
    this.labelTextStyle,
    this.barTextMargin = 10,
    this.barTextStyle,
    this.barTextAlignment = ChartBarTextAlignment.leading,
    this.isVisibleSeparatedText = true,
    this.isVisibleBarText = false,
    this.isVisibleLabel = true,
  }) : assert(separatedLineCount > 1);

  /// The values that defines the current datas of column chart.
  final List<ChartLabeledData> datas;

  /// The instance that defines the current controller of the chart.
  final ChartController<ChartLabeledState>? controller;

  /// The instance that defines current animation setting values of the chart.
  final ChartAnimation? animation;

  /// The background color excluding the separated text area and the bottom labels area.
  final Color? backgroundColor;

  /// The ratio that is rate of width at which the bar is rendered in the bar area.
  final double barRatio;

  /// The value that defines the maximum value in this chart.
  final double? maxValue;

  /// The value that defines type of how to display values in a chart.
  final ChartMarkType markType;

  /// The value that defines the theme in this chart.
  final ChartTheme? theme;

  final int separatedLineCount;
  final Color? separatedLineColor;
  final double separatedLineWidth;
  final TextStyle? separatedTextStyle;
  final double separatedTextMargin;
  final ChartSeparatedTextAlignment separatedTextAlignment;
  final Color? separatedBorderColor;
  final double? separatedBorderWidth;
  final StrokeCap separatedLineCap;

  final double labelTextMargin;
  final TextStyle? labelTextStyle;

  final double barTextMargin;
  final TextStyle? barTextStyle;
  final ChartBarTextAlignment barTextAlignment;

  final bool isVisibleSeparatedText;
  final bool isVisibleBarText;
  final bool isVisibleLabel;

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> with ChartContext, TickerProviderStateMixin {
  late final ChartController<ChartLabeledState> _controller = widget.controller ?? ChartController();

  /// Returns a list that defines values from the given data list.
  List<double> get values => widget.datas.map((data) => data.value).toList();

  ChartTheme get theme {
    return widget.theme ?? ChartStyle.maybeOf(context)?.theme ?? ChartTheme.light;
  }

  @override
  ChartAnimation get animation {
    return defaultAnimation
      .merge(ChartStyle.maybeOf(context)?.animation)
      .merge(widget.animation);
  }

  @override
  TickerProvider get vsync => this;

  ChartAnimation get defaultAnimation {
    return ChartAnimation(
      fadeDuration: Duration(milliseconds: 500),
      fadeCurve: Curves.easeInOutCubic,
      transitionDuration: Duration(milliseconds: 500),
      transitionCurve: Curves.easeInOutQuad
    );
  }

  Color get defaultSeparatedLineColor {
    return theme == ChartTheme.light
      ? const Color.fromRGBO(230, 230, 230, 1)
      : const Color.fromRGBO(30, 30, 30, 1);
  }

  Color get defaultSeparatedBorderColor {
    return theme == ChartTheme.light
      ? Colors.black
      : Colors.white;
  }

  TextStyle get defaultSeparatedTextStyle {
    return theme == ChartTheme.light
      ? const TextStyle(fontSize: 14, color: Colors.black)
      : const TextStyle(fontSize: 14, color: Colors.white);
  }

  TextStyle get defaultLabelTextStyle => defaultSeparatedTextStyle;

  TextStyle get defaultBarTextStyle {
    return theme == ChartTheme.light
      ? const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)
      : const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black);
  }

  ChartLabeledState createState(ChartLabeledData data) {
    return ChartLabeledState(context: this, initialData: data);
  }

  /// Called when a state of the controller changes.
  void didUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(didUpdate);

    for (final data in widget.datas) {
      _controller.attach(createState(data));
    }
  }

  @override
  void dispose() {
    _controller.removeListener(didUpdate);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ColumnChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    final compared = ChartLabeledData.comparedOf(oldWidget.datas, widget.datas);
    final removed = compared["removed"] ?? [];
    final created = compared["created"] ?? [];
    final changed = compared["changed"] ?? [];

    // When items is removed.
    for (final data in removed) {
      final state = _controller.findStateByKey(data.label);
      if (state != null) {
        _controller.detach(state);
      }
    }

    // When items is created.
    for (final data in created) {
      final state = _controller.findStateByKey(data.label);
      assert(state == null, "Already exists the data with the same key.");

      _controller.attach(createState(data));
    }

    for (final data in changed) {
      final state = _controller.findStateByKey(data.label);
      assert(state != null, "The corresponding state of the changed data does not exist.");

      state?.updateTo(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final states = _controller.states;
    final contextTheme = Theme.of(context);
    final defaultTextStyle = contextTheme.textTheme.bodyMedium ?? TextStyle();

    return CustomPaint(
      painter: ColumnChartPainter(
        states: _controller.states,
        backgroundColor: widget.backgroundColor,
        barRatio: widget.barRatio,
        maxValue: widget.maxValue ?? states.map((e) => e.value).reduce((a, b) => max(a, b)),
        markType: widget.markType,
        defaultTextStyle: defaultTextStyle,
        separatedLineCount: widget.separatedLineCount,
        separatedLineColor: widget.separatedLineColor ?? defaultSeparatedLineColor,
        separatedLineWidth: widget.separatedLineWidth,
        separatedTextStyle: defaultSeparatedTextStyle.merge(widget.separatedTextStyle),
        separatedTextMargin: widget.separatedTextMargin,
        separatedTextAlignment: widget.separatedTextAlignment,
        separatedBorderColor: widget.separatedBorderColor ?? defaultSeparatedBorderColor,
        separatedBorderWidth: widget.separatedBorderWidth ?? widget.separatedLineWidth,
        separatedLineCap: widget.separatedLineCap,
        labelTextMargin: widget.labelTextMargin,
        labelTextStyle: defaultLabelTextStyle.merge(widget.labelTextStyle),
        barTextMargin: widget.barTextMargin,
        barTextStyle: defaultBarTextStyle.merge(widget.barTextStyle),
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
    required this.defaultTextStyle,
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
    required this.states,
  });

  final Color? backgroundColor;
  final double barRatio;
  final double maxValue;
  final ChartMarkType markType;
  final TextStyle defaultTextStyle;
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

  final List<ChartLabeledState> states;

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

    return Size(innerLeft, bottomLabelAreaHeight);
  }

  void drawForeground(Canvas canvas, Size size, Size consumed) {
    if (states.isEmpty) return;

    final maxWidth = size.width - consumed.width;
    final maxHeight = size.height - consumed.height - (separatedBorderWidth * barRatio);
    final areaWidth = maxWidth / states.length;
    final barWidth = areaWidth * barRatio;

    for (int i = 0; i < states.length; i++) {
      final target = states[i];
      final height = (target.value / maxValue) * maxHeight;

      // About the position of a bar.
      final startX = consumed.width + (areaWidth * i) + (areaWidth - barWidth) / 2;
      final startY = maxHeight - height;
      final paint = Paint()..color = target.data.color;

      canvas.drawRect(Rect.fromLTRB(startX, startY, startX + barWidth, maxHeight), paint);

      if (isVisibleBarText) {
        final textPainter = TextPainter(
          text: TextSpan(text: "${target.value.round()}", style: defaultTextStyle.merge(barTextStyle)),
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