// P3: Bounded request queue with drop policy
// Source: solutions/ch06/README.md
import 'dart:collection';

enum DropPolicy { dropNewest, dropOldest }

class Request {
  Request(this.id, this.payload);
  final String id;
  final List<int> payload;
}

class BoundedRequestQueue {
  BoundedRequestQueue({
    required this.capacity,
    required this.maxInFlight,
    required this.policy,
    required this.execute,
  });

  final int capacity;
  final int maxInFlight;
  final DropPolicy policy;
  final void Function(Request) execute;

  final _pending = Queue<Request>();
  var _inFlight = 0;

  bool submit(Request req) {
    if (_pending.length + _inFlight >= capacity) {
      switch (policy) {
        case DropPolicy.dropNewest:
          return false;
        case DropPolicy.dropOldest:
          if (_pending.isEmpty) return false;
          _pending.removeFirst();
      }
    }
    _pending.addLast(req);
    _pump();
    return true;
  }

  void onComplete() {
    if (_inFlight > 0) _inFlight--;
    _pump();
  }

  void _pump() {
    while (_inFlight < maxInFlight && _pending.isNotEmpty) {
      final next = _pending.removeFirst();
      _inFlight++;
      execute(next);
    }
  }
}
