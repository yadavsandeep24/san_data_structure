// P2: Bounded blocking queue or async channel
// Source: solutions/ch28/README.md
import 'dart:async';
import 'dart:collection';

class BoundedAsyncQueue<T> {
  BoundedAsyncQueue(this.capacity) : assert(capacity > 0);
  final int capacity;
  final Queue<T> _q = Queue();
  final Queue<Completer<void>> _putWaiters = Queue();
  final Queue<Completer<T>> _takeWaiters = Queue();

  Future<void> put(T value) async {
    while (_q.length >= capacity && _takeWaiters.isEmpty) {
      final c = Completer<void>();
      _putWaiters.add(c);
      await c.future;
    }
    if (_takeWaiters.isNotEmpty) {
      _takeWaiters.removeFirst().complete(value);
    } else {
      _q.add(value);
    }
    _drainPutWaiters();
  }

  Future<T> take() async {
    if (_q.isNotEmpty) {
      final v = _q.removeFirst();
      _drainPutWaiters();
      return v;
    }
    final c = Completer<T>();
    _takeWaiters.add(c);
    return c.future;
  }

  void _drainPutWaiters() {
    while (_q.length < capacity && _putWaiters.isNotEmpty) {
      _putWaiters.removeFirst().complete();
    }
  }
}
