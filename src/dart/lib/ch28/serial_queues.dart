// Serial queues
// Source: book/part-vii/28-concurrency.md
import 'dart:async';

class SerialQueue {
  Future<void> _chain = Future.value();

  Future<T> enqueue<T>(FutureOr<T> Function() fn) {
    final run = _chain.then((_) => fn());
    _chain = run.then((_) {}, onError: (_) {});
    return run;
  }
}
