import 'package:flutter/widgets.dart';
import 'package:flutter_chart/components/ChartData.dart';
import 'package:flutter_chart/components/ChartGroup.dart';

abstract class DrivenChart<T> extends StatefulWidget {
  const DrivenChart({
    super.key,
    required this.width,
    required this.height,
    required this.groups
  });

  final double width;
  final double height;
  final List<ChartGroup<ChartData<T>>> groups;
}