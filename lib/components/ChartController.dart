import 'package:flutter_chart/components/ChartState.dart';

class ChartController<T extends ChartState> {
  final List<T> states = [];

  attach(T state) {
    assert(!states.contains(state), "Already exists a given state in this controller.");
    states.add(state);
  }

  detach(T state) {
    assert(states.contains(state), "Already not exists a given state in this controller");
    states.remove(state);
  }
}