// Producer-consumer and backpressure (network)
// Source: book/part-vii/28-concurrency.md
import 'dart:async';
import 'dart:collection';

class BoundedBuffer<T> {
  BoundedBuffer(this.capacity) : assert(capacity > 0);
  final int capacity;
  final _q = Queue<T>();
  final _putWaiters = Queue<Completer<void>>();
  final _takeWaiters = Queue<Completer<T>>();

  Future<void> put(T x) async {
    while (_q.length >= capacity) {
      final c = Completer<void>();
      _putWaiters.add(c);
      await c.future;
    }
    if (_takeWaiters.isNotEmpty) {
      _takeWaiters.removeFirst().complete(x);
    } else {
      _q.add(x);
    }
    _resumePutWaiters();
  }

  Future<T> take() {
    if (_q.isNotEmpty) {
      final x = _q.removeFirst();
      _resumePutWaiters();
      return Future.value(x);
    }
    final c = Completer<T>();
    _takeWaiters.add(c);
    return c.future;
  }

  void _resumePutWaiters() {
    while (_q.length < capacity && _putWaiters.isNotEmpty) {
      _putWaiters.removeFirst().complete();
    }
  }
}
