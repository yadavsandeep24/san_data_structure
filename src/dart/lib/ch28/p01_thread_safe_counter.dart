// P1: Thread-safe counter
// Source: solutions/ch28/README.md
import 'dart:async';

/// Command-serialized counter (single isolate).

class SerialCounter {
  int _value = 0;
  Future<void> _chain = Future.value();

  Future<int> increment() {
    final completer = Completer<int>();
    _chain = _chain.then((_) async {
      _value++;
      completer.complete(_value);
    });
    return completer.future;
  }

  Future<int> get() {
    final completer = Completer<int>();
    _chain = _chain.then((_) async {
      completer.complete(_value);
    });
    return completer.future;
  }
}
