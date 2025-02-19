import 'package:flutter/material.dart';
import 'package:flutter_chartx/components/ChartAnimation.dart';
import 'package:flutter_chartx/components/ChartBehavior.dart';
import 'package:flutter_chartx/components/ChartState.dart';
import 'package:flutter_chartx/components/ChartTooltip.dart';
import 'package:flutter_chartx/components/types.dart';
import 'package:flutter_chartx/widgets/ChartStyle.dart';
import 'package:flutter_chartx/widgets/DrivenChart.dart';

mixin ChartContext<T extends DrivenChart> on State<T> {
  TickerProvider get vsync;
  ChartAnimation get animation;
  ChartBehavior get behavior;

  ChartTheme get theme {
    return widget.theme ?? ChartStyle.maybeOf(context)?.theme ?? ChartTheme.light;
  }

  /// Returns the default animation setting values that is properties defined all.
  ChartAnimation get defaultAnimation {
    return ChartAnimation(
      fadeDuration: Duration(seconds: 1),
      fadeCurve: Curves.easeOutQuart,
      transitionDuration: Duration(milliseconds: 500),
      transitionCurve: Curves.easeInOutQuad,
      hoverDuration: Duration(milliseconds: 250),
      hoverCurve: Curves.ease
    );
  }

  /// Returns the default behavior that is properties defined all.
  ChartBehavior get defaultBehavior {
    return ChartBehavior(
      tooltip: ChartTooltip<ChartLabeledState>(builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: theme == ChartTheme.light ? Colors.white : Color.fromRGBO(30, 30, 30, 1),
            borderRadius: BorderRadius.circular(15)
          ),
          child: Text("${state.value}"),
        );
      })
    );
  }
}