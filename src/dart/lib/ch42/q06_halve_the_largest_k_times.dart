// Q6. Halve the Largest k Times (Compress the Biggest Attachments)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

/// Array-backed max-heap of ints.

class MaxHeap {
  final _a = <int>[];
  bool get isEmpty => _a.isEmpty;

  void push(int x) {
    _a.add(x);
    var i = _a.length - 1;
    while (i > 0) {
      final p = (i - 1) ~/ 2;
      if (_a[p] >= _a[i]) break;
      _swap(p, i);
      i = p;
    }
  }

  int pop() {
    final top = _a.first;
    final last = _a.removeLast();
    if (_a.isNotEmpty) {
      _a[0] = last;
      var i = 0;
      while (true) {
        final l = 2 * i + 1, r = l + 1;
        var m = i;
        if (l < _a.length && _a[l] > _a[m]) m = l;
        if (r < _a.length && _a[r] > _a[m]) m = r;
        if (m == i) break;
        _swap(m, i);
        i = m;
      }
    }
    return top;
  }

  void _swap(int i, int j) {
    final t = _a[i];
    _a[i] = _a[j];
    _a[j] = t;
  }
}

int minSumAfterHalving(List<int> nums, int k) {
  final heap = MaxHeap();
  var sum = 0;
  for (final x in nums) {
    heap.push(x);
    sum += x;
  }
  for (var r = 0; r < k && !heap.isEmpty; r++) {
    final top = heap.pop();
    final half = top - top ~/ 2; // ceil(top / 2)
    sum -= top - half;
    heap.push(half);
  }
  return sum;
}
