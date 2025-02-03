import 'package:flutter/widgets.dart';

abstract class DrivenChart<T> extends StatefulWidget {
  const DrivenChart({
    super.key,
    required this.width,
    required this.height
  });

  final double width;
  final double height;
}