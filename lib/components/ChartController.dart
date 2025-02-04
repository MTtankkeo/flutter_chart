import 'package:flutter/foundation.dart';
import 'package:flutter_chartx/components/ChartState.dart';

/// Signature for the callback function that is called when the state changes.
typedef ChartControllerListener = VoidCallback;

class ChartController<T extends ChartState> {
  final _states = <T>[];
  final _listeners = ObserverList<ChartControllerListener>();

  List<T> get states {
    return _states.toList();
  }

  void attach(T state) {
    assert(!_states.contains(state), "Already attached a given state in the controller.");
    _states.add(state..addListener(notifyListeners));
  }

  void detach(T state) {
    assert(_states.contains(state), "Already detached a given state in the controller.");
    _states.remove(state..removeListener(notifyListeners));
  }

  T? findStateByKey(dynamic key) {
    for (final state in _states) {
      if (state.key == key) return state;
    }

    return null;
  }

  void addListener(ChartControllerListener callback) {
    assert(!_listeners.contains(callback), "Already exists a given listener in the controller.");
    _listeners.add(callback);
  }

  void removeListener(ChartControllerListener callback) {
    assert(!_listeners.contains(callback), "Already not exists a given listener in the controller.");
    _listeners.remove(callback);
  }

  void notifyListeners() {
    for (final callback in _listeners) { callback(); }
  }
}