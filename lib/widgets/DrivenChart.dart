import 'package:flutter/widgets.dart';
import 'package:flutter_chartx/components/types.dart';

/// This abstract classs that defines a comprehensive chart widget.
abstract class DrivenChart extends StatefulWidget {
  const DrivenChart({
    super.key,
    required this.width,
    required this.height,
    this.theme
  });

  final double width;
  final double height;
  final ChartTheme? theme;
}