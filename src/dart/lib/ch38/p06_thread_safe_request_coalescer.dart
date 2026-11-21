// P6. Thread-Safe Request Coalescer
// Source: solutions/ch38/README.md

class Coalescer<T> {
  final _inflight = <String, Future<T>>{};
  Future<T> load(String key, Future<T> Function() produce) {
    return _inflight.putIfAbsent(key, () async {
      try { return await produce(); }
      finally { _inflight.remove(key); }
    });
  }
}
