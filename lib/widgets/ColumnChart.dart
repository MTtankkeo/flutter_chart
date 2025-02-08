import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chartx/flutter_chart.dart';

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
    this.behavior,
    this.backgroundColor,
    this.barRatio = 0.5,
    this.maxValue,
    this.markType = ChartMarkType.integer,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.separatedLineCount = 5,
    this.separatedLineWidth = 2,
    this.separatedLineColor,
    this.separatedTextStyle,
    this.separatedTextMargin = 15,
    this.separatedTextAlignment = ChartSeparatedTextAlignment.trailing,
    this.separatedTextDirection = ChartSeparatedTextDirection.leading,
    this.separatedBorderColor,
    this.separatedBorderWidth,
    this.separatedLineCap = StrokeCap.butt,
    this.labelTextMargin = 5,
    this.labelTextStyle,
    this.barInnerTextMargin = 10,
    this.barOuterTextMargin = 3,
    this.barInnerTextStyle,
    this.barOuterTextStyle,
    this.barTextAlignment = ChartBarTextAlignment.outer,
    this.barBorderRadius = BorderRadius.zero,
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

  /// The instance that defines current behavior of the chart.
  final ChartBehavior? behavior;

  /// The background color excluding the separated text area and the bottom labels area.
  final Color? backgroundColor;

  /// The ratio that is rate of width at which the bar is rendered in the bar area.
  final double barRatio;

  /// The value that defines the maximum value in this chart.
  final double? maxValue;

  /// The value that defines type of how to display values in a chart.
  final ChartMarkType markType;

  /// The callback that is called when each bar in the column chart is single tapped.
  final ChartInteractionCallback? onTap;

  /// The callback that is called when each bar in the column chart is double tapped.
  final ChartInteractionCallback? onDoubleTap;

  /// The callback that is called when each bar in the column chart is long pressed.
  final ChartInteractionCallback? onLongPress;

  final int separatedLineCount;
  final Color? separatedLineColor;
  final double separatedLineWidth;
  final TextStyle? separatedTextStyle;
  final double separatedTextMargin;
  final ChartSeparatedTextAlignment separatedTextAlignment;
  final ChartSeparatedTextDirection separatedTextDirection;
  final Color? separatedBorderColor;
  final double? separatedBorderWidth;
  final StrokeCap separatedLineCap;

  final double labelTextMargin;
  final TextStyle? labelTextStyle;

  final double barInnerTextMargin;
  final double barOuterTextMargin;
  final ChartTextStyleBuilder<ChartLabeledState>? barInnerTextStyle;
  final ChartTextStyleBuilder<ChartLabeledState>? barOuterTextStyle;
  final ChartBarTextAlignment barTextAlignment;
  final BorderRadius barBorderRadius;

  final bool isVisibleSeparatedText;
  final bool isVisibleBarText;
  final bool isVisibleLabel;

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> with ChartContext, TickerProviderStateMixin {
  late final ChartController<ChartLabeledState> _controller = widget.controller ?? ChartController();

  late final _fadeController = AnimationController(vsync: this, duration: animation.fadeDuration);
  late final _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: animation.fadeCurve!);

  /// Returns a list that defines values from the given data list.
  List<double> get values => widget.datas.map((data) => data.value).toList();

  @override
  TickerProvider get vsync => this;

  @override
  ChartAnimation get animation {
    return defaultAnimation
      .merge(ChartStyle.maybeOf(context)?.animation)
      .merge(widget.animation);
  }

  @override
  ChartBehavior get behavior {
    return defaultBehavior
      .merge(ChartStyle.maybeOf(context)?.behavior)
      .merge(widget.behavior);
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

  TextStyle get defaultBarInnerTextStyle {
    return theme == ChartTheme.light
      ? const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)
      : const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black);
  }

  TextStyle defaultBarOuterTextStyleOf(ChartLabeledState state) {
    return TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: state.data.color);
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

    // About initial fade-in animation effect.
    _fadeController.forward();
    _fadeController.addListener(didUpdate);

    for (final data in widget.datas) {
      _controller.attach(createState(data));
    }
  }

  @override
  void dispose() {
    _controller.removeListener(didUpdate);
    _fadeController.removeListener(didUpdate);
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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: widget.onTap != null ? (details) {
        final target = _controller.findStateByHitTest(details.localPosition);
        if (target != null) {
          widget.onTap?.call(target);
        }
      } : null,
      onDoubleTapDown: widget.onDoubleTap != null ? (details) {
        final target = _controller.findStateByHitTest(details.localPosition);
        if (target != null) {
          widget.onDoubleTap?.call(target);
        }
      } : null,
      onLongPressStart: widget.onLongPress != null ? (details) {
        final target = _controller.findStateByHitTest(details.localPosition);
        if (target != null) {
          widget.onLongPress?.call(target);
        }
      } : null,
      child: CustomPaint(
        painter: ColumnChartPainter(
          states: _controller.states,
          backgroundColor: widget.backgroundColor,
          barRatio: widget.barRatio,
          maxValue: widget.maxValue ?? states.map((e) => e.value).reduce((a, b) => max(a, b)),
          markType: widget.markType,
          fadePercent: _fadeAnimation.value,
          defaultTextStyle: defaultTextStyle,
          separatedLineCount: widget.separatedLineCount,
          separatedLineColor: widget.separatedLineColor ?? defaultSeparatedLineColor,
          separatedLineWidth: widget.separatedLineWidth,
          separatedTextStyle: defaultSeparatedTextStyle.merge(widget.separatedTextStyle),
          separatedTextMargin: widget.separatedTextMargin,
          separatedTextAlignment: widget.separatedTextAlignment,
          separatedTextDirection: widget.separatedTextDirection,
          separatedBorderColor: widget.separatedBorderColor ?? defaultSeparatedBorderColor,
          separatedBorderWidth: widget.separatedBorderWidth ?? widget.separatedLineWidth,
          separatedLineCap: widget.separatedLineCap,
          labelTextMargin: widget.labelTextMargin,
          labelTextStyle: defaultLabelTextStyle.merge(widget.labelTextStyle),
          barInnerTextMargin: widget.barInnerTextMargin,
          barOuterTextMargin: widget.barOuterTextMargin,
          barInnerTextStyle: (state) {
            return defaultBarInnerTextStyle.merge(widget.barInnerTextStyle?.call(state));
          },
          barOuterTextStyle: (state) {
            return defaultBarOuterTextStyleOf(state).merge(widget.barOuterTextStyle?.call(state));
          },
          barTextAlignment: widget.barTextAlignment,
          barBorderRadius: widget.barBorderRadius,
          isVisibleSeparatedText: widget.isVisibleSeparatedText,
          isVisibleBarText: widget.isVisibleBarText,
          isVisibleLabel: widget.isVisibleLabel
        ),
        size: Size(widget.width, widget.height),
      ),
    );
  }
}

class ColumnChartPainter extends GridLabeledChartPainter {
  ColumnChartPainter({
    required super.defaultTextStyle,
    required super.states,
    required super.maxValue,
    required super.markType,
    required super.backgroundColor,
    required super.separatedLineCount,
    required super.separatedLineWidth,
    required super.separatedLineColor,
    required super.separatedTextMargin,
    required super.separatedTextStyle,
    required super.separatedTextAlignment,
    required super.separatedTextDirection,
    required super.separatedBorderColor,
    required super.separatedBorderWidth,
    required super.separatedLineCap,
    required super.labelTextMargin,
    required super.labelTextStyle,
    required super.isVisibleSeparatedText,
    required super.isVisibleLabel,
    required this.barRatio,
    required this.fadePercent,
    required this.barInnerTextMargin,
    required this.barOuterTextMargin,
    required this.barInnerTextStyle,
    required this.barOuterTextStyle,
    required this.barTextAlignment,
    required this.barBorderRadius,
    required this.isVisibleBarText,
  });

  final double barRatio;
  final double fadePercent;
  final double barInnerTextMargin;
  final double barOuterTextMargin;
  final ChartTextStyleBuilder<ChartLabeledState> barInnerTextStyle;
  final ChartTextStyleBuilder<ChartLabeledState> barOuterTextStyle;
  final ChartBarTextAlignment barTextAlignment;
  final BorderRadius barBorderRadius;

  final bool isVisibleBarText;

  bool get isInnerBarTextAlignment {
    return barTextAlignment == ChartBarTextAlignment.inner_center
        || barTextAlignment == ChartBarTextAlignment.inner_leading
        || barTextAlignment == ChartBarTextAlignment.inner_trailing;
  }

  @override
  void drawForeground(Canvas canvas, Size size) {
    if (states.isEmpty) return;

    final maxWidth = size.width - constraint.width;
    final maxHeight = size.height - constraint.height - (separatedBorderWidth * barRatio);
    final areaWidth = maxWidth / states.length;
    final barWidth = areaWidth * barRatio;

    for (int i = 0; i < states.length; i++) {
      final target = states[i];
      final height = ((target.value * fadePercent) / maxValue) * maxHeight;

      // About the position of a bar.
      final startX = constraint.left + (areaWidth * i) + (areaWidth - barWidth) / 2;
      final startY = maxHeight - height;
      final paint = Paint()..color = target.data.color;
      final rrect = barBorderRadius.toRRect(Rect.fromLTRB(startX, startY, startX + barWidth, maxHeight));

      target.position = ChartPosition(path: Path()..addRRect(rrect));
      canvas.drawRRect(rrect, paint);

      if (isVisibleBarText) {
        final text = "${target.value.round()}";
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: defaultTextStyle.merge(
                barTextAlignment == ChartBarTextAlignment.inner_center
             || barTextAlignment == ChartBarTextAlignment.inner_leading
             || barTextAlignment == ChartBarTextAlignment.inner_trailing
             ? barInnerTextStyle(target)
             : barOuterTextStyle(target)
          )),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(maxWidth: maxWidth);

        final textWidth = textPainter.width;
        final textHeight = textPainter.height;
        final textStartX = startX + (barWidth - textWidth) / 2;

        // Not drawing when overflow in layout calculation for the bar text.
        if (isInnerBarTextAlignment && height < textHeight + barInnerTextMargin * 2) {
          continue;
        }

        switch (barTextAlignment) {
          case ChartBarTextAlignment.inner_center:
            textPainter.paint(canvas, Offset(textStartX, startY + height / 2));
            break;

          case ChartBarTextAlignment.inner_leading:
            textPainter.paint(canvas, Offset(textStartX, startY + barInnerTextMargin));
            break;

          case ChartBarTextAlignment.inner_trailing:
            textPainter.paint(canvas, Offset(textStartX, (startY + height) - textHeight - barInnerTextMargin));
            break;

          case ChartBarTextAlignment.outer:
            textPainter.paint(canvas, Offset(textStartX, (startY - textHeight) - barOuterTextMargin));
            break;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}