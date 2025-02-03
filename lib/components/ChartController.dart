import 'package:flutter_chart/components/ChartState.dart';

class ChartController {
  final List<ChartState> states = [];

  attach(ChartState state) {
    assert(!states.contains(state), "Already exists a given state in this controller.");
    states.add(state);
  }

  detach(ChartState state) {
    assert(states.contains(state), "Already not exists a given state in this controller");
    states.remove(state);
  }
}