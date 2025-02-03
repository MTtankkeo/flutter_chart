import 'package:flutter/widgets.dart';

/// This abstract classs that defines a comprehensive chart widget.
abstract class DrivenChart extends StatefulWidget {
  const DrivenChart({
    super.key,
    required this.width,
    required this.height
  });

  final double width;
  final double height;
}