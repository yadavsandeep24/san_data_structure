// P4. Task Scheduler (Priority Queue)
// Source: solutions/ch38/README.md

class TaskScheduler {
  final _heap = <_T>[];
  final _cancelled = <String>{};
  var _seq = 0;

  void schedule(String id, int priority, void Function() run) {
    _heap.add(_T(id, priority, _seq++, run));
    _siftUp(_heap.length - 1);
  }

  void cancel(String id) => _cancelled.add(id);

  bool runNext() {
    while (_heap.isNotEmpty) {
      final t = _pop();
      if (_cancelled.remove(t.id)) continue;
      t.run();
      return true;
    }
    return false;
  }

  /// Higher priority first; tie-break earlier `seq`.
  bool _before(_T a, _T b) =>
      a.priority != b.priority ? a.priority > b.priority : a.seq < b.seq;

  void _siftUp(int i) {
    while (i > 0) {
      final p = (i - 1) >> 1;
      if (!_before(_heap[i], _heap[p])) break;
      final tmp = _heap[i];
      _heap[i] = _heap[p];
      _heap[p] = tmp;
      i = p;
    }
  }

  void _siftDown(int i) {
    for (;;) {
      var best = i;
      final l = i * 2 + 1, r = l + 1;
      if (l < _heap.length && _before(_heap[l], _heap[best])) best = l;
      if (r < _heap.length && _before(_heap[r], _heap[best])) best = r;
      if (best == i) break;
      final tmp = _heap[i];
      _heap[i] = _heap[best];
      _heap[best] = tmp;
      i = best;
    }
  }

  _T _pop() {
    final top = _heap.first;
    final last = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = last;
      _siftDown(0);
    }
    return top;
  }
}

class _T {
  _T(this.id, this.priority, this.seq, this.run);
  final String id;
  final int priority;
  final int seq;
  final void Function() run;
}
