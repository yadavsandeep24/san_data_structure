// Q37. Thread-Safe Request Coalescer (Single-Flight)
// Source: book/part-viii/29-interview-questions-q31-q40.md

class Coalescer<T> {
  final _inflight = <String, Future<T>>{};
  Future<T> load(String key, Future<T> Function() produce) {
    return _inflight.putIfAbsent(key, () async {
      try { return await produce(); }
      finally { _inflight.remove(key); }
    });
  }
}
